//
//  EpisodeViewController.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import UIKit

class EpisodeViewController: UIViewController {

    private lazy var showView: ShowView = {
        let view = ShowView()
        return view
    }()

    private var lastContentOffset: CGFloat = 0
    weak var scrollDelegate: DiscoveryScrollDelegate?

    private var viewModel: EpisodeViewModelDataSource

    init(viewMode: EpisodeViewModelDataSource) {
        self.viewModel = viewMode
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        loadEpisodeInfo()
        populateSchedule()
    }

    required init?(coder: NSCoder) {
        fatalError("Class not avaliable to be used by Visual Interface")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = showView
        self.showView.tableView.setTableHeaderView(headerView: showView.tableHeaderView)
        self.showView.tableView.updateHeaderViewFrame()
        configureNavigationApparence()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = showView.tableView.tableHeaderView {

            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            // Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                showView.tableView.tableHeaderView = headerView
            }
        }
    }

    private func loadEpisodeInfo() {
        if let imageData = self.viewModel.episode.downloadedImageData {
            self.viewModel.delegate?.didFinishedDownloadingImage(data: imageData, forRowAt: IndexPath())
        }
        if let imageURL = self.viewModel.episode.image?.original {
            self.viewModel.downloadImage(from: imageURL)
        }
        self.showView.tableHeaderView.titleLabel.text = self.viewModel.episode.name
        if let runtime = self.viewModel.episode.runtime {
            showView.tableHeaderView.subTitleLabel.text = "\(runtime) min"
        }
        let text = self.viewModel.episode.summary?.replaceHTMLOccurrences()
        showView.tableHeaderView.sumary.attributedText = text?.justifiedTextAttribute()
        showView.tableHeaderView.sumary.text = text
    }

    private func populateSchedule() {
        let seasonLabel = UILabel.factorDefaultSubtitleLabel()
            .set(\.attributedText,
                  to: "\(self.viewModel.season) Season".imageAttributedString(sfSymbol: "play.square"))
        self.showView.tableHeaderView.scheduleStackView.addArrangedSubview(seasonLabel)

        let epLabel = UILabel.factorDefaultSubtitleLabel()
            .set(\.attributedText,
                  to: "\(self.viewModel.episode.number) Ep".imageAttributedString(sfSymbol: "rectangle.3.group.fill"))
        self.showView.tableHeaderView.scheduleStackView.addArrangedSubview(epLabel)
        navigationItem.title = "\(self.viewModel.season)x\(self.viewModel.episode.number)"
    }

    private func configureNavigationApparence() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        navigationItem.scrollEdgeAppearance = appearance
    }
}

extension EpisodeViewController: EpisodeViewModelDelegate {
    func apiDidReturnAnError(error: APIError) {
        print(error)
    }

    func didFinishedDownloadingImage(data: Data, forRowAt indexPath: IndexPath) {
        self.showView.tableHeaderView.posterImageView.image = UIImage(data: data)
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
