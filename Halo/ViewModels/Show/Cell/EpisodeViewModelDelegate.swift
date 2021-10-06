//
//  EpisodeViewModelDelegate.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import Foundation

protocol EpisodeViewModelDelegate: AnyObject {
    func apiDidReturnAnError(error: APIError)
    func didFinishedDownloadingImage(data: Data, forRowAt indexPath: IndexPath)
}
