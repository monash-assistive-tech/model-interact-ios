//
//  TagmataDetection.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

class TagmataDetection {
    
    public let boundingBox: CGRect
    public let label: String
    public let classification: TagmataClassification
    public let confidence: Float
    
    init(observation: VNRecognizedObjectObservation) {
        self.boundingBox = observation.boundingBox
        self.label = observation.labels.first!.identifier
        guard let classification = TagmataClassification(rawValue: self.label) else {
            fatalError("Classification found has no corresponding enum case")
        }
        self.classification = classification
        self.confidence = observation.confidence.magnitude
    }
    
    init(boundingBox: CGRect, label: String, classification: TagmataClassification, confidence: Float) {
        self.boundingBox = boundingBox
        self.label = label
        self.classification = classification
        self.confidence = confidence
    }
    
}
