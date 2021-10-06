//
//  ShowViewController.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import UIKit

class ShowViewController: UIViewController {

    private lazy var showView: ShowView = {
        let view = ShowView()
            .set(\.tableView.delegate, to: self)
            .set(\.tableView.dataSource, to: self)
        return view
    }()

    private var lastContentOffset: CGFloat = 0
    weak var scrollDelegate: DiscoveryScrollDelegate?

    var viewModel: ShowViewModelDataSource

    init(viewModel: ShowViewModelDataSource) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.loadShowInfo()
        self.populateSchedule()
    }

    required init?(coder: NSCoder) {
        fatalError("Class not avaliable to be used by Visual Interface")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = showView
        configureNavigationApparence()
        self.showView.tableView.setTableHeaderView(headerView: showView.tableHeaderView)
        self.showView.tableView.updateHeaderViewFrame()
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

    private func loadShowInfo() {
        showView.tableHeaderView.titleLabel.text = self.viewModel.show.name
        showView.tableHeaderView.subTitleLabel.text =  self.viewModel.show.genres.joined(separator: " / ")
        let text = self.viewModel.show.summary?.replaceHTMLOccurrences()
        showView.tableHeaderView.sumary.attributedText = text?.justifiedTextAttribute()
        showView.tableHeaderView.sumary.text = text
    }

    private func populateSchedule() {
        guard let schedule = self.viewModel.show.schedule else {
            return
        }
        if !schedule.time.isEmpty {
            let timeLabel = UILabel.factorDefaultSubtitleLabel()
                .set(\.attributedText,
                  to: schedule.time.imageAttributedString(sfSymbol: "clock.fill"))
            self.showView.tableHeaderView.scheduleStackView.addArrangedSubview(timeLabel)
        }
        if !schedule.days.isEmpty {
            let daysLabel = UILabel.factorDefaultSubtitleLabel()
                .set(\.attributedText,
                      to: schedule.days.joined(separator: ",").imageAttributedString(sfSymbol: "calendar.badge.clock"))
            self.showView.tableHeaderView.scheduleStackView.addArrangedSubview(daysLabel)

        }
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

extension ShowViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "asjajids"
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

extension ShowViewController: ShowViewModelDelegate {
    func didCompleLoadingShows(models: [DiscoveryCellViewModelDataSource]) {

    }

    func apiDidReturnAnError(error: APIError) {
        print(error)
    }

    func didFinishedDownloadingImage(data: Data) {
        self.showView.tableHeaderView.posterImageView.image = UIImage(data: data)
    }
}
