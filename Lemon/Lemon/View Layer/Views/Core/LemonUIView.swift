//
//  LemonView.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

typealias LemonUIView = LemonUIViewAbstract & LemonUIViewProtocol

// MARK: - Abstract

class LemonUIViewAbstract {
    
    public let id = UUID()
    
    init() { }
    
}

// MARK: - Protocol

protocol LemonUIViewProtocol {
    
    var view: UIView { get }
    
}
extension LemonUIViewProtocol {
    
    // MARK: - Properties
    
    public var isHidden: Bool {
        return self.view.isHidden
    }
    
    public var frame: CGRect {
        return self.view.frame
    }
    
    // MARK: - Views
    
    @discardableResult
    func addSubview(_ view: LemonUIView) -> Self {
        self.view.addSubview(view.view)
        return self
    }
    
    // MARK: - Frame
    
    @discardableResult
    func setFrame(to rect: CGRect) -> Self {
        self.view.frame = rect
        return self
    }
    
    // MARK: - Constraints
    
    @discardableResult
    func matchWidthConstraint(to other: LemonUIView? = nil) -> Self {
        assert(!self.view.translatesAutoresizingMaskIntoConstraints, "Constraints requirement failed")
        guard let target = other?.view ?? self.view.superview else {
            fatalError("No constraint target found")
        }
        self.view.widthAnchor.constraint(equalTo: target.widthAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func matchHeightConstraint(to other: LemonUIView? = nil) -> Self {
        assert(!self.view.translatesAutoresizingMaskIntoConstraints, "Constraints requirement failed")
        guard let target = other?.view ?? self.view.superview else {
            fatalError("No constraint target found")
        }
        self.view.widthAnchor.constraint(equalTo: target.heightAnchor).isActive = true
        return self
    }
    
    @discardableResult
    func constrainLeft(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        assert(!self.view.translatesAutoresizingMaskIntoConstraints, "Constraints requirement failed")
        guard let target = other?.view ?? self.view.superview else {
            fatalError("No constraint target found")
        }
        self.view.leadingAnchor.constraint(equalTo: target.leadingAnchor, constant: padding).isActive = true
        return self
    }
    
    @discardableResult
    func constrainRight(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        assert(!self.view.translatesAutoresizingMaskIntoConstraints, "Constraints requirement failed")
        guard let target = other?.view ?? self.view.superview else {
            fatalError("No constraint target found")
        }
        self.view.trailingAnchor.constraint(equalTo: target.trailingAnchor, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func constrainTop(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        assert(!self.view.translatesAutoresizingMaskIntoConstraints, "Constraints requirement failed")
        guard let target = other?.view ?? self.view.superview else {
            fatalError("No constraint target found")
        }
        self.view.topAnchor.constraint(equalTo: target.topAnchor, constant: padding).isActive = true
        return self
    }
    
    @discardableResult
    func constrainBottom(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        assert(!self.view.translatesAutoresizingMaskIntoConstraints, "Constraints requirement failed")
        guard let target = other?.view ?? self.view.superview else {
            fatalError("No constraint target found")
        }
        self.view.bottomAnchor.constraint(equalTo: target.bottomAnchor, constant: -padding).isActive = true
        return self
    }
    
    @discardableResult
    func constrainHorizontal(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        self.constrainLeft(to: other, padding: padding)
        self.constrainRight(to: other, padding: padding)
        return self
    }
    
    @discardableResult
    func constrainVertical(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        self.constrainTop(to: other, padding: padding)
        self.constrainBottom(to: other, padding: padding)
        return self
    }
    
    @discardableResult
    func constrainAllSides(to other: LemonUIView? = nil, padding: CGFloat = 0.0) -> Self {
        self.constrainHorizontal(to: other, padding: padding)
        self.constrainVertical(to: other, padding: padding)
        return self
    }
    
    @discardableResult
    func setPadding(top: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil) -> Self {
        self.view.layoutMargins = UIEdgeInsets(
            top: top ?? self.view.layoutMargins.top,
            left: left ?? self.view.layoutMargins.left,
            bottom: bottom ?? self.view.layoutMargins.bottom,
            right: right ?? self.view.layoutMargins.right
        )
        return self
    }
    
    @discardableResult
    func setPaddingVertical(to padding: CGFloat) -> Self {
        return self.setPadding(top: padding, bottom: padding)
    }
    
    @discardableResult
    func setPaddingHorizontal(to padding: CGFloat) -> Self {
        return self.setPadding(left: padding, right: padding)
    }
    
    @discardableResult
    func setPaddingAllSides(to padding: CGFloat) -> Self {
        self.setPaddingVertical(to: padding)
        self.setPaddingHorizontal(to: padding)
        return self
    }
    
    // MARK: - Background
    
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
    func addBorder(width: CGFloat = 1.0, color: UIColor = UIColor.red) -> Self {
        self.view.layer.borderWidth = width
        self.view.layer.borderColor = color.cgColor
        return self
    }
    
    // MARK: - Visibility
    
    @discardableResult
    func setHidden(to isHidden: Bool) -> Self {
        self.view.isHidden = isHidden
        return self
    }
    
}
