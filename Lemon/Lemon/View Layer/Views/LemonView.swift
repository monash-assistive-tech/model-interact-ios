//
//  LemonView.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

class LemonView: LemonUIView {
    
    public let view: UIView
    
    init() {
        self.view = UIView()
    }
    
    init(_ view: UIView) {
        self.view = view
    }
    
}
