//
//  CGPoint+Distance.swift
//  Halo
//
//  Created by Levy Cristian on 03/10/21.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}
