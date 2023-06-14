//
//  ObjectDetection.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

typealias ObjectDetectionOutcome = [ObjectDetection]

class ObjectDetection {
    
    private let observation: VNRecognizedObjectObservation
    public var boundingBox: CGRect {
        return self.observation.boundingBox
    }
    public var label: String {
        return self.observation.labels.first!.identifier
    }
    public var confidence: Float {
        return self.observation.confidence.magnitude
    }
    
    init(observation: VNRecognizedObjectObservation) {
        self.observation = observation
    }
    
}
