//
//  String+Replacing.swift
//  Halo
//
//  Created by Levy Cristian on 05/10/21.
//

import UIKit

extension String {
    func replaceHTMLOccurrences() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    func justifiedTextAttribute() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified

        let attributedString = NSAttributedString(string: self,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.baselineOffset: NSNumber(value: 0)
            ])
        return attributedString
    }

    func imageAttributedString(sfSymbol: String) -> NSMutableAttributedString {
        let image = UIImage(systemName: sfSymbol)?.withTintColor(.lightGray, renderingMode: .alwaysTemplate)

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let fullString = NSMutableAttributedString(attachment: imageAttachment)
        fullString.append(NSAttributedString(string: " \(self)"))
        return fullString
    }
}
