//
//  ShowView.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import UIKit

class ShowView: UIView {

    lazy var tableView: UITableView = {
        let tableView = UITableView()
            .set(\.backgroundColor, to: .clear)
            .set(\.estimatedRowHeight, to: 44)
            .set(\.rowHeight, to: UITableView.automaticDimension)
            .set(\.separatorColor, to: .lightGray)
        tableView.register(EpisodeTableViewCell.self,
                           forCellReuseIdentifier: EpisodeTableViewCell.reuseIdentifier)
        return tableView
    }()

    lazy var tableHeaderView: ShowHeaderView = {
        let header = ShowHeaderView()
        return header
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
}

extension ShowView: ViewCode {
    func buildViewHierarchy() {
        addSubview(tableView)
    }

    func setupConstraints() {
        tableView
            .anchor(\.topAnchor,
                     referentTo: self,
                     equal: \.topAnchor)
            .anchor(\.leadingAnchor,
                     referentTo: self,
                     equal: \.leadingAnchor)
            .anchor(\.trailingAnchor,
                     referentTo: self,
                     equal: \.trailingAnchor)
            .anchor(\.bottomAnchor,
                     referentTo: self,
                     equal: \.bottomAnchor)
    }
}
