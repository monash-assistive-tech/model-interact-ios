//
//  CompiledResults.swift
//  Lemon
//
//  Created by Andre Pham on 8/7/2023.
//

import Foundation

class CompiledResults {
    
    /// All detected tagmata within frame
    private(set) var detectedTagmata: [TagmataClassification]
    /// All detected tagmata that are currently being held within frame
    private(set) var heldTagmata: [TagmataClassification]
    /// True if there were no detected tagmata within frame
    public var hasNoDetections: Bool {
        return self.detectedTagmata.isEmpty
    }
    /// True if there were no detected tagmata being held within frame
    public var hasNoHeldDetections: Bool {
        return self.heldTagmata.isEmpty
    }
    
    init(detectedTagmata: [TagmataClassification] = [], heldTagmata: [TagmataClassification] = []) {
        self.detectedTagmata = detectedTagmata
        self.heldTagmata = heldTagmata
    }
    
}
