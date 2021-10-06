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
        navigationItem.title = self.viewModel.show.name
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

    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.episodesModelDataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.episodesModelDataSource[section+1]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: EpisodeTableViewCell.reuseIdentifier,
            for: indexPath) as? EpisodeTableViewCell else {
                let cell = UITableViewCell()
                cell.textLabel?.text = "Unexpected Behavior"
                return cell
            }
        guard var cellViewModel = self.viewModel.episodesModelDataSource[indexPath.section+1]?[indexPath.row] else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Unexpected Behavior"
            return cell
        }
        cellViewModel.indexPath = indexPath
        cellViewModel.delegate = self

        let episode = cellViewModel.episode
        cell.configure(
            title: "\(episode.number). \(episode.name)",
            minutes: episode.runtime,
            sumary: episode.summary?.replaceHTMLOccurrences())

        if let imageData = cellViewModel.episode.downloadedImageData {
            cell.episodeImageView.image = UIImage(data: imageData)
        } else if let imageURL = cellViewModel.episode.image?.medium {
            cellViewModel.downloadImage(from: imageURL)
        } else {
            cell.episodeImageView.backgroundColor = .gray
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            .set(\.backgroundColor, to: .black)

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5,
                                  width: headerView.frame.width-10,
                                  height: headerView.frame.height-10)
        label.text = "Season \(section+1)"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .white

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellViewModel = self.viewModel.episodesModelDataSource[indexPath.section+1]?[indexPath.row] else {
            return
        }
        let controller = EpisodeViewController(viewMode: cellViewModel)
        controller.scrollDelegate = scrollDelegate
        navigationController?.pushViewController(controller, animated: true)
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

extension ShowViewController: ShowViewModelDelegate, EpisodeViewModelDelegate {
    func didFinishedDownloadingImage(data: Data, forRowAt indexPath: IndexPath) {
        guard let cell = self.showView.tableView.cellForRow(at: indexPath) as? EpisodeTableViewCell else {
            return
        }
        cell.episodeImageView.image = UIImage(data: data)
    }

    func didCompleLoadingEpisodes(models: [Int: [EpisodeViewModelDataSource]]) {
        DispatchQueue.main.async { [weak self] in
            self?.showView.tableView.reloadData()
        }
    }

    func apiDidReturnAnError(error: APIError) {
        print(error)
    }

    func didFinishedDownloadingImage(data: Data) {
        self.showView.tableHeaderView.posterImageView.image = UIImage(data: data)
    }
}
