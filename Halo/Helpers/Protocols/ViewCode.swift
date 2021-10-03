//
//  ViewCode.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import Foundation

protocol ViewCode {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfigurantion()
    func setupView()
}

extension ViewCode {
   public func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfigurantion()
    }
    
    public func setupAdditionalConfigurantion() {
        //
    }
}
