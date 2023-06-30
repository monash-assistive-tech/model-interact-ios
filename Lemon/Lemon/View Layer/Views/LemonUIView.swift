//
//  LemonView.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

typealias LemonUIView = LemonUIViewAbstract & LemonUIViewProtocol

class LemonUIViewAbstract {
    
    public let id = UUID()
    
    init() { }
    
}

protocol LemonUIViewProtocol {
    
    var view: UIView { get }
    
}
extension LemonUIViewProtocol {
    
    public var frame: CGRect {
        return self.view.frame
    }
    
    @discardableResult
    func setFrame(to rect: CGRect) -> Self {
        self.view.frame = rect
        return self
    }
    
    @discardableResult
    func expandFrame(left: Double? = nil, right: Double? = nil, top: Double? = nil, bottom: Double? = nil) -> Self {
        if let left {
            self.view.frame = CGRect(
                x: self.view.frame.origin.x - left, y: self.view.frame.origin.y,
                width: self.view.frame.width + left, height: self.view.frame.height
            )
        }
        if let right {
            self.view.frame = CGRect(
                x: self.view.frame.origin.x, y: self.view.frame.origin.y,
                width: self.view.frame.width + right, height: self.view.frame.height
            )
        }
        if let top {
            self.view.frame = CGRect(
                x: self.view.frame.origin.x, y: self.view.frame.origin.y - top,
                width: self.view.frame.width, height: self.view.frame.height + top
            )
        }
        if let bottom {
            self.view.frame = CGRect(
                x: self.view.frame.origin.x, y: self.view.frame.origin.y,
                width: self.view.frame.width, height: self.view.frame.height + bottom
            )
        }
        return self
    }
    
    @discardableResult
    func expandFrame(horizontal: Double? = nil, vertical: Double? = nil) -> Self {
        return self.expandFrame(left: horizontal, right: horizontal, top: vertical, bottom: vertical)
    }
    
    @discardableResult
    func expandFrame(allSides: Double?) -> Self {
        return self.expandFrame(left: allSides, right: allSides, top: allSides, bottom: allSides)
    }
    
    @discardableResult
    func addSubview(_ view: LemonUIView) -> Self {
        self.view.addSubview(view.view)
        return self
    }
    
    @discardableResult
    func expandWidthAnchor(to width: Double) -> Self {
        self.view.widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func expandHeightAnchor(to height: Double) -> Self {
        self.view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func setBackgroundColor(to color: UIColor) -> Self {
        self.view.backgroundColor = color
        return self
    }
    
    @discardableResult
    func setCornerRadius(to radius: Double) -> Self {
        self.view.layer.cornerRadius = radius
        return self
    }
    
    @discardableResult
    func setPadding(left: Double? = nil, right: Double? = nil, top: Double? = nil, bottom: Double? = nil) -> Self {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        if let superview = self.view.superview {
            if let left {
                self.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
            }
            if let right {
                self.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: right).isActive = true
            }
            if let top {
                self.view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
            }
            if let bottom {
                self.view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
            }
        }
        return self
    }
    
    @discardableResult
    func setPadding(horizontal: Double? = nil, vertical: Double? = nil) -> Self {
        return self.setPadding(left: horizontal, right: horizontal, top: vertical, bottom: vertical)
    }
    
    @discardableResult
    func setPadding(allSides: Double?) -> Self {
        return self.setPadding(left: allSides, right: allSides, top: allSides, bottom: allSides)
    }
    
    @discardableResult
    func addTestingBorder() -> Self {
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.red.cgColor
        return self
    }
    
}
