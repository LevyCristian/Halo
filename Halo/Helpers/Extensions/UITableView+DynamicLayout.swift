//
//  UITableView+DynamicLayout.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import UIKit

extension UITableView {

    /// Set table header view & add Auto layout.
    func setTableHeaderView(headerView: UIView) {
        headerView.translatesAutoresizingMaskIntoConstraints = false

        // Set first.
        self.tableHeaderView = headerView

        // Then setup AutoLayout.
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView
            .anchor(\.centerXAnchor, referentTo: self, equal: \.centerXAnchor)
            .anchor(\.topAnchor, referentTo: self, equal: \.topAnchor)
            .anchor(\.widthAnchor, equalToConstant: UIScreen.main.bounds.width)
    }

    /// Update header view's frame.
    func updateHeaderViewFrame() {
        guard let headerView = self.tableHeaderView else { return }

        // Update the size of the header based on its internal content.
        headerView.layoutIfNeeded()

        // ***Trigger table view to know that header should be updated.
        let header = self.tableHeaderView
        self.tableHeaderView = header
    }
}
