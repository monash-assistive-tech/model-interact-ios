//
//  ModelDetectionOutcome.swift
//  Lemon
//
//  Created by Mohamed Asjad on 7/5/2024.
//

import Foundation
import CoreGraphics

class ModelDetectionOutcome {
    
    public let detectorID: DetectorID
    public let frameSize: CGSize
    private var modelDetectionStore = [WaterCycleClassification: [ModelDetection]]()
    /// Keep track of weights so if a merge occurs twice the confidences don't become skewed towards latest additions
    
    private var classificationWeights = [WaterCycleClassification: Int]()
    public var modelDetections: [ModelDetection] {
        var result = [ModelDetection]()
        for modelDetectionArray in modelDetectionStore.values {
            result.append(contentsOf: modelDetectionArray)
        }
        return result
    }
    
    init(detectorID: DetectorID, frameSize: CGSize) {
        self.detectorID = detectorID
        self.frameSize = frameSize
        for classification in WaterCycleClassification.allCases {
            self.modelDetectionStore[classification] = [ModelDetection]()
            self.classificationWeights[classification] = 0
        }
    }
    
    convenience init(detectorID: DetectorID, frameSize: CGSize, detections: [ModelDetection]) {
        self.init(detectorID: detectorID, frameSize: frameSize)
        for detection in detections {
            self.addDetection(detection)
        }
    }
    
    func addDetection(_ detection: ModelDetection) {
        self.modelDetectionStore[detection.classification]!.append(detection)
        self.classificationWeights[detection.classification]! += 1
    }
    
    func merge() {
        for detectionsToMerge in self.modelDetectionStore.values {
            guard !detectionsToMerge.isEmpty else {
                continue
            }
            let boundingBoxesToMerge = detectionsToMerge.map({ $0.boundingBox })
            let confidencesToMerge = detectionsToMerge.map({ $0.confidence })
            let boundingBox = boundingBoxesToMerge.unionAll()
            let classification = detectionsToMerge.first!.classification
            let label = detectionsToMerge.first!.label
            let confidence = confidencesToMerge.reduce(0, +) / Float(self.classificationWeights[classification]!)
            let mergedDetection = ModelDetection(
                boundingBox: boundingBox,
                label: label,
                classification: classification,
                confidence: confidence
            )
            // Replace entire array with array with just the merged detection
            self.modelDetectionStore[mergedDetection.classification]! = [mergedDetection]
        }
    }
    
    func merged(with other: ModelDetectionOutcome, newID: DetectorID, frameSize: CGSize) -> ModelDetectionOutcome {
        let new = ModelDetectionOutcome(detectorID: newID, frameSize: frameSize)
        self.modelDetections.forEach({ new.addDetection($0) })
        other.modelDetections.forEach({ new.addDetection($0) })
        new.merge()
        return new
    }
    
}

