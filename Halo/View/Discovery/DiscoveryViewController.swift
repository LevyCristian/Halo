//
//  DiscoveryViewController.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import UIKit

class DiscoveryViewController: UIViewController {

    private lazy var discoveryView: DiscoveryView = {
        let view = DiscoveryView()
            .set(\.collectionView.delegate, to: self)
            .set(\.collectionView.dataSource, to: self)

        if let layout = view.collectionView.collectionViewLayout as? CardsFlowLayout {
            layout.delegate = self
        }
        return view
    }()

    private var viewModel: DiscoveryViewModelDataSource

    private var lastContentOffset: CGFloat = 0
    weak var scrollDelegate: FloatyBarScrollDelegate?

    init(viewModel: DiscoveryViewModelDataSource) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Class not avaliable to be used by Visual Interface")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = discoveryView
    }
}

extension DiscoveryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            self.viewModel.currentPage += 1
            self.viewModel.loadShows(at: self.viewModel.currentPage)
        }
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

extension DiscoveryViewController: CardsLayoutDelegate {
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

extension DiscoveryViewController: DiscoveryViewModelDelegate, DiscoveryCellViewModelDelegate {
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
