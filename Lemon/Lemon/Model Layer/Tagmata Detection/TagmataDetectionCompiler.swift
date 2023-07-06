//
//  TagmataDetectionCompiler.swift
//  Lemon
//
//  Created by Andre Pham on 7/7/2023.
//

import Foundation

class TagmataDetectionCompiler {
    
    private static let DETECTION_BATCH_SIZE = 10
    private static let DETECTION_THRESHOLD = 4
    
    private var compiledOutcomes = [TagmataDetectionOutcome]()
    private var results = [TagmataClassification]()
    private(set) var newResultsReady = false
    
    func addOutcome(_ outcome: TagmataDetectionOutcome) {
        self.compiledOutcomes.append(outcome)
        let results = self.compileResults(detectionThreshold: Self.DETECTION_THRESHOLD)
        let resultsAreReady = !results.isEmpty
        let thresholdReached = self.compiledOutcomes.count >= Self.DETECTION_BATCH_SIZE
        if resultsAreReady || thresholdReached {
            self.publishResults(results)
        } else if self.compiledOutcomes.count > Self.DETECTION_BATCH_SIZE - Self.DETECTION_THRESHOLD {
            // Let's say you need to detect a tagma at least 4 times for it
            // to be part of the results and our batch size is 10. If we've
            // compiled 7 results then with a detection threshold of 1 if
            // there are no results, we know for sure the final results
            // will be empty, so we may as well abandon this compilation
            // and restart early.
            let earlyThreshold = self.compiledOutcomes.count + Self.DETECTION_THRESHOLD - Self.DETECTION_BATCH_SIZE
            let earlyResults = self.compileResults(detectionThreshold: earlyThreshold)
            if earlyResults.isEmpty {
                self.publishResults([])
            }
        }
    }
    
    func retrieveResults() -> [TagmataClassification] {
        self.newResultsReady = false
        return self.results
    }
    
    private func publishResults(_ results: [TagmataClassification]) {
        self.compiledOutcomes.removeAll()
        self.results = results
        self.newResultsReady = true
    }
    
    private func compileResults(detectionThreshold: Int) -> [TagmataClassification] {
        var tally = [TagmataClassification: Int]()
        TagmataClassification.allCases.forEach({ tally[$0] = 0 })
        
        for outcome in self.compiledOutcomes {
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
        return results
    }
    
}
