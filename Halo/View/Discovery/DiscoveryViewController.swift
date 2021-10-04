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

    private var viewModel: PostsViewModelDataSource

    private var lastContentOffset: CGFloat = 0
    weak var scrollDelegate: DiscoveryScrollDelegate?

    init(viewModel: PostsViewModelDataSource) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        cellViewModel.downloadImage(from: cellViewModel.show.image.medium)
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
}

extension DiscoveryViewController: CardsLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let imageData = self.viewModel.discoveryCellViewModels[indexPath.row].downloadedData,
                let image = UIImage(data: imageData) else {
            return 295 + CGFloat.random(in: -20...20)
        }

        return image.size.height
    }
}

extension DiscoveryViewController: ShowsViewModelDelegate, DiscoveryCellViewModelDelegate {
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
