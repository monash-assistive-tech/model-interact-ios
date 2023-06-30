//
//  CGPoint.swift
//  Lemon
//
//  Created by Andre Pham on 29/6/2023.
//

import Foundation

extension CGPoint {
    
    static func += (left: inout CGPoint, right: CGPoint) {
        left.x += right.x
        left.y += right.y
    }

    static func -= (left: inout CGPoint, right: CGPoint) {
        left.x -= right.x
        left.y -= right.y
    }
    
    func toString() -> String {
        return "(\(self.x.toString(decimalPlaces: 2)), \(self.y.toString(decimalPlaces: 2)))"
    }
    
}
