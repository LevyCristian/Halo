//
//  UILabel+Default.swift
//  Halo
//
//  Created by Levy Cristian on 06/10/21.
//

import Foundation
import UIKit

extension UILabel {
    static func factorDefaultSubtitleLabel() -> UILabel {
        let label = UILabel()
            .set(\.textAlignment, to: .center)
            .set(\.numberOfLines, to: 2)
            .set(\.textColor, to: .lightGray)
            .set(\.font, to: UIFont.systemFont(ofSize: 18, weight: .regular))
        return label
    }
}
