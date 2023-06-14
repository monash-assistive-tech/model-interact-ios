//
//  LemonView.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

protocol LemonUIView {
    
    var view: UIView { get }
    
}
extension LemonUIView {
    
    public var frame: CGRect {
        return self.view.frame
    }
    
    @discardableResult
    func setFrame(to rect: CGRect) -> Self {
        self.view.frame = rect
        return self
    }
    
    @discardableResult
    func addSubview(_ view: LemonUIView) -> Self {
        self.view.addSubview(view.view)
        return self
    }
    
}
