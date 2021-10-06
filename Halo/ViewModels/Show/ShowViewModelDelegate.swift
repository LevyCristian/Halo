//
//  ShowViewModelDelegate.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import Foundation

protocol ShowViewModelDelegate: AnyObject {
    func didCompleLoadingEpisodes(models: ShowViewModelDataSource.Seasons)
    func apiDidReturnAnError(error: APIError)
    func didFinishedDownloadingImage(data: Data)
}
