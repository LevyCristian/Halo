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
        // .set(\.collectionView.delegate, to: self)
        // .set(\.collectionView.dataSource, to: self)

        if let layout = view.collectionView.collectionViewLayout as? CardsFlowLayout {
            // layout.delegate = self
        }
        return view
    }()

    lazy var searchController: UISearchController = {
        let searchControl = UISearchController(searchResultsController: nil)
        return searchControl
    }()

    public lazy var timer: Timer = {
        let time = Timer()
        return time
    }()

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
            selector: #selector(didHitScheduleTime),
            userInfo: searchBar.text,
            repeats: false)

    }

    @objc func didHitScheduleTime() {
        if timer.userInfo != nil, let query = timer.userInfo as? String {
            if query.isEmpty {
                return
            }
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
