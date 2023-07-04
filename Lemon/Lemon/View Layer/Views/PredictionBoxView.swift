//
//  PredictionBoxView.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import UIKit

class PredictionBoxView: LemonUIView {
    
    public let view = UIView()
    
    func drawBoxes(for predictionOutcome: TagmataDetectionOutcome, plainOutline: UIColor? = nil) {
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        self.view.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        self.drawAngles(for: predictionOutcome)
//        for prediction in predictionOutcome.tagmataDetections {
//            if let plainOutline {
//                self.drawOutline(for: prediction, color: plainOutline)
//            } else {
//                self.drawBox(for: prediction)
//            }
//        }
    }
    
    private func drawOutline(for prediction: TagmataDetection, color: UIColor) {
        let rect = prediction.getDenormalisedBoundingBox(boundsWidth: self.view.bounds.width, boundsHeight: self.view.bounds.height)
        let newLayer = UIView()
        newLayer.frame = rect
        newLayer.layer.borderColor = color.withAlphaComponent(CGFloat(prediction.confidence)).cgColor
        newLayer.layer.borderWidth = 3.0
        newLayer.layer.cornerRadius = 4
        self.view.addSubview(newLayer)
        let label = UILabel()
        label.text = prediction.label
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = prediction.classification.color
        label.textAlignment = .right
        label.sizeToFit()
        label.center = CGPoint(x: rect.origin.x + label.frame.width/2.0, y: rect.origin.y + label.frame.height/2.0)
        self.view.addSubview(label)
    }
    
    private func drawBox(for prediction: TagmataDetection) {
        let rect = prediction.getDenormalisedBoundingBox(boundsWidth: self.view.bounds.width, boundsHeight: self.view.bounds.height)
        let newLayer = UIView()
        newLayer.frame = rect
        newLayer.backgroundColor = prediction.classification.color.withAlphaComponent(0.5)
        newLayer.layer.cornerRadius = 4
        self.view.addSubview(newLayer)
        let label = UILabel()
        label.text = "\(prediction.label) \((100.0*prediction.confidence).toString(decimalPlaces: 0))%"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        label.center = rect.center
        self.view.addSubview(label)
        let positionLabel = UILabel()
        positionLabel.text = rect.center.toString()
        positionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        positionLabel.textColor = UIColor.black
        positionLabel.textAlignment = .right
        positionLabel.sizeToFit()
        positionLabel.center = CGPoint(x: rect.origin.x + positionLabel.frame.width/2.0, y: rect.origin.y + positionLabel.frame.height/2.0)
        self.view.addSubview(positionLabel)
    }
    
    private func drawAngles(for predictionOutcome: TagmataDetectionOutcome) {
        var predictions = [TagmataClassification: TagmataDetection]()
        for prediction in predictionOutcome.tagmataDetections {
            predictions[prediction.classification] = prediction
        }
        let A = predictions[.head]
        let B = predictions[.leftWing]
        let C = predictions[.thorax]
        let D = predictions[.rightWing]
        let E = predictions[.abdomen]
        
        let angle1 = self.drawAngle(A, C, D)
        let angle2 = self.drawAngle(B, C, A)
        let angle3 = self.drawAngle(E, C, B)
        let angle4 = self.drawAngle(D, C, E)
        
        for prediction in predictionOutcome.tagmataDetections {
            self.drawCircle(
                radius: 20.0,
                center: prediction.getDenormalisedCenter(for: self.view),
                color: prediction.classification.color
            )
        }
        
        if let angle1, let angle2, let angle3, let angle4, let A, let B, let C, let D, let E {
            let sum = angle1 + angle2 + angle3 + angle4
            let sumInRange = sum >= 350 && sum <= 370
            let validAngles = [angle1, angle2, angle3, angle4].allSatisfy({ $0 >= 60 && $0 <= 120 })
            let abdomenIntersects = C.boundingBox.intersects(E.boundingBox)
            let leftWingIntersects = C.boundingBox.intersects(B.boundingBox)
            let rightWingIntersects = C.boundingBox.intersects(D.boundingBox)
            let headIntersects = C.boundingBox.intersects(A.boundingBox)
            let validIntersects = abdomenIntersects && leftWingIntersects && rightWingIntersects && headIntersects
            if sumInRange && validAngles && validIntersects {
                let boundingBox = [A, B, C, D, E].map({ $0.getDenormalisedBoundingBox(for: self.view) }).mergeAll()
                let newLayer = UIView()
                newLayer.frame = boundingBox
                newLayer.backgroundColor = .green.withAlphaComponent(0.5)
                newLayer.layer.cornerRadius = 4
                self.view.addSubview(newLayer)
            }
        }
    }
    
    func drawAngle(_ detection1: TagmataDetection?, _ detection2: TagmataDetection?, _ detection3: TagmataDetection?) -> Double? {
        guard let detection1, let detection2, let detection3 else {
            return nil
        }
        self.drawLine(detection1, detection2, detection3)
        let point1 = detection1.getDenormalisedCenter(for: self.view)
        let point2 = detection2.getDenormalisedCenter(for: self.view)
        let point3 = detection3.getDenormalisedCenter(for: self.view)
        let angleLabelPosition = midpointBetween(
            midpointBetween(point1, point2),
            midpointBetween(point2, point3)
        )
        let angleLabel = UILabel()
        let angle = self.angleBetweenPoints(point1: point1, point2: point2, point3: point3)
        angleLabel.text = "\(angle.rounded(decimalPlaces: 0))"
        angleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        angleLabel.textColor = UIColor.black
        angleLabel.textAlignment = .right
        angleLabel.sizeToFit()
        angleLabel.center = angleLabelPosition
        angleLabel.backgroundColor = .white
        self.view.addSubview(angleLabel)
        return angle
    }
    
    func midpointBetween(_ point1: CGPoint, _ point2: CGPoint) -> CGPoint {
        let midX = (point1.x + point2.x) / 2
        let midY = (point1.y + point2.y) / 2
        return CGPoint(x: midX, y: midY)
    }
    
    func drawLine(_ point1: TagmataDetection, _ point2: TagmataDetection, _ point3: TagmataDetection) {
        self.drawLine(
            point1.getDenormalisedCenter(for: self.view),
            point2.getDenormalisedCenter(for: self.view)
        )
        self.drawLine(
            point2.getDenormalisedCenter(for: self.view),
            point3.getDenormalisedCenter(for: self.view)
        )
    }
    
    func drawLine(_ point1: CGPoint, _ point2: CGPoint) {
        let linePath = UIBezierPath()
        linePath.move(to: point1)
        linePath.addLine(to: point2)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2.0

        self.view.layer.addSublayer(shapeLayer)
    }
    
    func drawCircle(radius: Double, center: CGPoint, color: UIColor) {
        let newLayer = UIView()
        newLayer.frame = CGRect(x: center.x - radius/2, y: center.y - radius/2, width: radius, height: radius)
        newLayer.layer.cornerRadius = radius/2
        newLayer.backgroundColor = color
        self.view.addSubview(newLayer)
    }
    
    func angleBetweenPoints(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> Double {
        let vector1 = CGPoint(x: point2.x - point1.x, y: point2.y - point1.y)
        let vector2 = CGPoint(x: point3.x - point2.x, y: point3.y - point2.y)
        
        let dotProduct = vector1.x * vector2.x + vector1.y * vector2.y
        let magnitude1 = sqrt(vector1.x * vector1.x + vector1.y * vector1.y)
        let magnitude2 = sqrt(vector2.x * vector2.x + vector2.y * vector2.y)
        
        let cosAngle = dotProduct / (magnitude1 * magnitude2)
        let angleInRadians = acos(cosAngle)
        
        let crossProduct = vector1.x * vector2.y - vector1.y * vector2.x
        let angleInDegrees = angleInRadians * (180.0 / .pi)
        
        // Determine the sign of the angle based on the cross product
        let signedAngle = crossProduct >= 0 ? -angleInDegrees : angleInDegrees
        
        return signedAngle
    }
    
}
