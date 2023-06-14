//
//  PredictionBoxView.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

class PredictionBoxView: UIView {
    
    func drawBoxes(for predictions: ObjectDetectionOutcome) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        for prediction in predictions {
            self.drawBox(for: prediction)
        }
    }
    
    private func drawBox(for prediction: ObjectDetection) {
        let scale = CGAffineTransform.identity.scaledBy(x: self.bounds.width, y: self.bounds.height)
        let reflection = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -1)
        let rect = prediction.boundingBox.applying(reflection).applying(scale)
        let newLayer = UIView()
        newLayer.frame = rect
        newLayer.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        newLayer.layer.cornerRadius = 4
        self.addSubview(newLayer)
        let label = UILabel()
        label.text = "\(prediction.label) \((100.0*prediction.confidence).toString(decimalPlaces: 0))%"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.center = rect.center
        self.addSubview(label)
    }
    
}
