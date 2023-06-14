//
//  LemonVStack.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

class LemonVStack: LemonUIView {
    
    private let stack = UIStackView()
    public var view: UIView {
        return self.stack
    }
    private var verticalSpacer: UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return spacerView
    }
    
    init(spacing: CGFloat = 16.0, padding: CGFloat = 16.0) {
        // Defaults
        self.stack.axis = .vertical
        self.stack.alignment = .center
        self.stack.spacing = spacing
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        self.stack.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.stack.isLayoutMarginsRelativeArrangement = true
    }
    
    @discardableResult
    func constrainTo(_ view: LemonUIView) -> Self {
        NSLayoutConstraint.activate([
            self.stack.topAnchor.constraint(equalTo: view.view.topAnchor),
            self.stack.leadingAnchor.constraint(equalTo: view.view.leadingAnchor),
            self.stack.bottomAnchor.constraint(equalTo: view.view.bottomAnchor),
            self.stack.trailingAnchor.constraint(equalTo: view.view.trailingAnchor)
        ])
        return self
    }
    
    @discardableResult
    func addView(_ view: LemonUIView) -> Self {
        self.stack.addArrangedSubview(view.view)
        return self
    }
    
    @discardableResult
    func addSpacer() -> Self {
        self.stack.addArrangedSubview(self.verticalSpacer)
        return self
    }
    
    @discardableResult
    func insertView(_ view: LemonUIView, at index: Int) -> Self {
        self.stack.insertArrangedSubview(view.view, at: index)
        return self
    }
    
    @discardableResult
    func insertSpacer(at index: Int) -> Self {
        self.stack.insertArrangedSubview(self.verticalSpacer, at: index)
        return self
    }
    
}
