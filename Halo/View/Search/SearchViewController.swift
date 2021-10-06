//
//  SearchViewController.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import UIKit

class SearchViewController: UIViewController {

    private lazy var discoveryView: DiscoveryView = {
        let view = DiscoveryView()
            .set(\.collectionView.delegate, to: self)
            .set(\.collectionView.dataSource, to: self)

        if let layout = view.collectionView.collectionViewLayout as? CardsFlowLayout {
            layout.delegate = self
        }
        return view
    }()

    private lazy var searchController: UISearchController = {
        let searchControl = UISearchController(searchResultsController: nil)
        return searchControl
    }()

    private lazy var timer: Timer = {
        let time = Timer()
        return time
    }()

    private var viewModel: SearchViewModelDataSource
    private var lastContentOffset: CGFloat = 0

    weak var scrollDelegate: FloatyBarScrollDelegate?

    init(viewModel: SearchViewModelDataSource) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("Class not avaliable to be used by Visual Interface")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = discoveryView
        configureSearchView()
    }

    private func configureSearchView() {
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.loadViewIfNeeded()
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.searchTextField.textColor = .white
        searchController.searchBar.tintColor = .white
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.35,
            target: self,
            selector: #selector(didHitScheduledTime),
            userInfo: searchBar.text,
            repeats: false)
    }

    @objc func didHitScheduledTime() {
        if timer.userInfo != nil, let query = timer.userInfo as? String {
            if query.isEmpty {
                return
            }
            self.viewModel.searchShows(with: query)
        }
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.discoveryView.collectionView.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        self.discoveryView.collectionView.endEditing(true)
        self.searchController.searchBar.endEditing(true)
    }
}

extension SearchViewController: CardsLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        guard let imageData = self.viewModel.discoveryCellViewModels[indexPath.row].show.downloadedImageData,
              let image = UIImage(data: imageData) else {
                  return 295
              }
        return image.size.height
    }

    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 20
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.discoveryCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DiscoveryCollectionViewCell.reuseIdentifier,
            for: indexPath) as? DiscoveryCollectionViewCell else {
                let cell = UICollectionViewCell()
                return cell
            }
        var cellViewModel = self.viewModel.discoveryCellViewModels[indexPath.row]
        cellViewModel.indexPath = indexPath
        cellViewModel.delegate = self
        cell.configureCard(showTitle: cellViewModel.show.name)
        if let imageData = cellViewModel.show.downloadedImageData {
            cell.imageView.image = UIImage(data: imageData)
        } else if let imageURL = cellViewModel.show.image?.medium {
            cellViewModel.downloadImage(from: imageURL)
        } else {
            cell.imageView.backgroundColor = .gray
        }
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset > scrollView.contentOffset.y
            && lastContentOffset < scrollView.contentSize.height - scrollView.frame.height {
            self.scrollDelegate?.scrollViewDidScroll(.up)
        } else if lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 0 {
            self.scrollDelegate?.scrollViewDidScroll(.down)
        }
        lastContentOffset = scrollView.contentOffset.y
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let show = self.viewModel.discoveryCellViewModels[indexPath.row].show
        let viewModel = ShowViewModel(show,
                                      service: self.viewModel.service)
        let viewController = ShowViewController(viewModel: viewModel)
        viewController.scrollDelegate = self.scrollDelegate
        self.navigationController?.pushViewController(viewController,
                                                      animated: true)
    }
}

extension SearchViewController: DiscoveryViewModelDelegate, DiscoveryCellViewModelDelegate {
    func didFinishedDownloadingImage(data: Data, forRowAt indexPath: IndexPath) {
        guard let cell = self.discoveryView.collectionView.cellForItem(at: indexPath) as? DiscoveryCollectionViewCell else {
            return
        }
        cell.loadCardImage(from: data)
    }

    func didCompleLoadingShows(models: [DiscoveryCellViewModelDataSource]) {
        self.discoveryView.collectionView.reloadData()
    }

    func apiDidReturnAnError(error: APIError) {
        print(error)
    }
}
