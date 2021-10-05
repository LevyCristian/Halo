//
//  DiscoveryCellViewModelDelegate.swift
//  Halo
//
//  Created by Levy Cristian on 04/10/21.
//

import Foundation

protocol DiscoveryCellViewModelDelegate: AnyObject {
    func didFinishedDownloadingImage(data: Data, forRowAt indexPath: IndexPath)
    func apiDidReturnAnError(error: APIError)
}
