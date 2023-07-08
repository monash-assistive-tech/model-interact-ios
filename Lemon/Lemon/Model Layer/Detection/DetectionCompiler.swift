//
//  DetectionCompiler.swift
//  Lemon
//
//  Created by Andre Pham on 7/7/2023.
//

import Foundation

/// This is used to compile multiple model outputs into a single validated output.
/// For instance, if a tagma is partially visible and hence is flickering, we may not be sure if it's a random misidentification or not.
/// It's unsafe to assume that if a tagma is detected by the model within a single frame, it's 100% there and valid. We want to be more sure that it is indeed there.
/// Hence we compile many detections together (`DETECTION_BATCH_SIZE`). If a certain number (`DETECTION_THRESHOLD`) indicate they do indeed see something, we can be more confident that the something is indeed there and not an outlier misidentification.
/// This also means we don't instantly react to detections. If there's only one frame where a tagma is detected, we don't want to jump the gun and assume that we want to react to it.
class DetectionCompiler {
    
    /// How many detections (model outputs) until we compile results (whether there was something detected)
    private static let DETECTION_BATCH_SIZE = 8
    /// How many of the detections (model outputs) are needed to indicate that something indeed was detected
    private static let DETECTION_THRESHOLD = 3
    
    /// All the tagmata detections to be used to produce the results
    private var compiledTagmataOutcomes = [TagmataDetectionOutcome]()
    /// All the hand detections to be used to produce the results
    private var compiledHandOutcomes = [HandDetectionOutcome]()
    /// The results to be retrieved
    private var results = CompiledResults()
    /// If new results are ready to be read (once retrieved, is toggled to false again)
    private(set) var newResultsReady = false

    func addOutcome(_ tagmataOutcome: TagmataDetectionOutcome, handOutcome: HandDetectionOutcome) {
        self.compiledTagmataOutcomes.append(tagmataOutcome)
        self.compiledHandOutcomes.append(handOutcome)
        let results = self.compileResults(detectionThreshold: Self.DETECTION_THRESHOLD)
        let resultsAreReady = !results.hasNoDetections
        let thresholdReached = self.compiledTagmataOutcomes.count >= Self.DETECTION_BATCH_SIZE
        if resultsAreReady || thresholdReached {
            self.publishResults(results)
        } else if self.compiledTagmataOutcomes.count > Self.DETECTION_BATCH_SIZE - Self.DETECTION_THRESHOLD {
            // Let's say you need to detect a tagma at least 4 times for it
            // to be part of the results and our batch size is 10. If we've
            // compiled 7 results then with a detection threshold of 1 if
            // there are no results, we know for sure the final results
            // will be empty, so we may as well abandon this compilation
            // and restart early.
            let earlyThreshold = self.compiledTagmataOutcomes.count + Self.DETECTION_THRESHOLD - Self.DETECTION_BATCH_SIZE
            let earlyResults = self.compileResults(detectionThreshold: earlyThreshold)
            if earlyResults.hasNoDetections {
                self.publishResults(earlyResults)
            }
        }
    }
    
    func retrieveResults() -> CompiledResults {
        self.newResultsReady = false
        return self.results
    }
    
    private func publishResults(_ results: CompiledResults) {
        self.compiledTagmataOutcomes.removeAll()
        self.compiledHandOutcomes.removeAll()
        self.results = results
        self.newResultsReady = true
    }
    
    private func compileResults(detectionThreshold: Int) -> CompiledResults {
        var tally = [TagmataClassification: Int]()
        TagmataClassification.allCases.forEach({ tally[$0] = 0 })
        
        for outcome in self.compiledTagmataOutcomes {
            for detection in outcome.tagmataDetections {
                tally[detection.classification]! += 1
            }
        }
        
        var results = [TagmataClassification]()
        for (classification, total) in tally {
            if total >= detectionThreshold {
                results.append(classification)
            }
        }
        
        var heldResults = [TagmataClassification]()
        for index in 0..<self.compiledTagmataOutcomes.count {
            let tagmataOutcome = self.compiledTagmataOutcomes[index]
            let handOutcome = self.compiledHandOutcomes[index]
            let beingHeld = self.findTagmataBeingHeld(
                tagmataDetectionOutcome: tagmataOutcome,
                handDetectionOutcome: handOutcome
            )
            heldResults.append(contentsOf: beingHeld)
        }
        var filteredHeldResults = [TagmataClassification]()
        for heldResult in heldResults.filterDuplicates() {
            if results.contains(heldResult) {
                filteredHeldResults.append(heldResult)
            }
        }
        
        return CompiledResults(detectedTagmata: results, heldTagmata: filteredHeldResults)
    }
    
    private func findTagmataBeingHeld(
        tagmataDetectionOutcome: TagmataDetectionOutcome,
        handDetectionOutcome: HandDetectionOutcome
    ) -> [TagmataClassification] {
        if tagmataDetectionOutcome.tagmataDetections.isEmpty {
            return []
        }
        let frameWidth = Double(tagmataDetectionOutcome.frame.width)
        let frameHeight = Double(tagmataDetectionOutcome.frame.height)
        let tagmataClassifications = tagmataDetectionOutcome.tagmataDetections.map({ $0.classification })
        let tagmataPositions = tagmataDetectionOutcome.tagmataDetections.map({
            $0.getDenormalisedCenter(boundsWidth: frameWidth, boundsHeight: frameHeight)
        })
        var result = [TagmataClassification]()
        // Initially the distance threshold was empirically measured using a width/height of 504x896 and was found to be 80
        // This converts the distance threshold to match the frame's width and height
        let distanceThreshold = self.equivalentDistance(
            oldWidth: 504, oldHeight: 896, oldDistance: 80,
            newWidth: frameWidth, newHeight: frameHeight
        )
        for handDetection in handDetectionOutcome.handDetections {
            var heldTagmata = [TagmataClassification]()
            var jointPositions = handDetection.holdingPositions
            var filteredJointPositions = [JointPosition]()
            for jointPosition in jointPositions {
                for tagmataIndex in 0..<tagmataClassifications.count {
                    let tagmataPosition = tagmataPositions[tagmataIndex]
                    let tagmataClassification = tagmataClassifications[tagmataIndex]
                    if let distance = jointPosition.getDenormalisedPosition(viewWidth: frameWidth, viewHeight: frameHeight)?.length(to: tagmataPosition),
                       isLess(distance, distanceThreshold) {
                        heldTagmata.append(tagmataClassification)
                    }
                }
            }
            if let mostCommon = heldTagmata.mostCommonElement() {
                result.append(mostCommon)
            }
        }
        return result
    }
    
    /// Converts a distance in a given frame to the equivalent distance in a new frame.
    /// Example:
    /// ``` equivalentDistance(
    ///         oldWidth: 1000, oldHeight: 1000, oldDistance: 100,
    ///         newWidth: 100, newHeight: 100
    ///     ) -> 10.0
    /// ```
    /// - Parameters:
    ///   - oldWidth: Old frame's width
    ///   - oldHeight: Old frame's height
    ///   - oldDistance: Distance to be converted
    ///   - newWidth: The new width as reference for the new distance
    ///   - newHeight: The new height as reference for the new distance
    /// - Returns: `oldDistance` equivalent to to new width and height
    private func equivalentDistance(
        oldWidth: Double,
        oldHeight: Double,
        oldDistance: Double,
        newWidth: Double,
        newHeight: Double
    ) -> Double {
        let oldDiagonal = sqrt(pow(oldWidth, 2) + pow(oldHeight, 2))
        let proportion = oldDistance / oldDiagonal
        let newDiagonal = sqrt(pow(newWidth, 2) + pow(newHeight, 2))
        let newDistance = proportion * newDiagonal
        return newDistance
    }
    
}
