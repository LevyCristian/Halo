//
//  ShowsViewModelDelegate.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

protocol ShowsViewModelDelegate: AnyObject {
    func didCompleLoadingShows(models: [DiscoveryCellViewModelDataSource])
    func apiDidReturnAnError(error: APIError)
}
