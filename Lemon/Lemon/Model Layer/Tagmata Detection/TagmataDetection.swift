//
//  TagmataDetection.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

typealias TagmataDetectionOutcome = [TagmataDetection]

class TagmataDetection {
    
    private let observation: VNRecognizedObjectObservation
    public var boundingBox: CGRect {
        return self.observation.boundingBox
    }
    public var label: String {
        return self.observation.labels.first!.identifier
    }
    public var classification: TagmataClassification {
        guard let result = TagmataClassification(rawValue: self.label) else {
            fatalError("Classification found has no corresponding enum case")
        }
        return result
    }
    public var confidence: Float {
        return self.observation.confidence.magnitude
    }
    
    init(observation: VNRecognizedObjectObservation) {
        self.observation = observation
    }
    
}
