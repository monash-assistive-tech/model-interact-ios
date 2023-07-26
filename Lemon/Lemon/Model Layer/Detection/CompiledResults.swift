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
    /// All detected tagmata that are currently maybe held within frame (close to a hand)
    private(set) var maybeHeldTagmata: [TagmataClassification]
    /// If the insect is complete (all pieces are correctly attached)
    public let insectIsComplete: Bool
    /// True if there were no detected tagmata within frame
    public var hasNoDetections: Bool {
        return self.detectedTagmata.isEmpty
    }
    /// True if there were no detected tagmata being held within frame
    public var hasNoHeldDetections: Bool {
        return self.heldTagmata.isEmpty
    }
    /// True if there were no detected tagmata close to any hands within frame
    public var hasNoMaybeHeldDetections: Bool {
        return self.maybeHeldTagmata.isEmpty
    }
    
    init(
        detectedTagmata: [TagmataClassification] = [],
        heldTagmata: [TagmataClassification] = [],
        maybeHeldTagmata: [TagmataClassification] = [],
        insectIsComplete: Bool = false
    ) {
        self.detectedTagmata = detectedTagmata
        self.heldTagmata = heldTagmata
        self.maybeHeldTagmata = maybeHeldTagmata
        self.insectIsComplete = insectIsComplete
    }
    
    func tagmaStillHeld(original: TagmataClassification) -> Bool {
        // We assume we 100% know they were previously holding the original since it triggered a command
        // Hence if we believe they were already holding it, we don't want to accidentally think they've stopped holding it if we're unsure
        // That can trigger it to stop speaking, which is really annoying if they just took a finger off or something
        // Hence we just look through everything that's currently MAYBE being held
        // If they were holding a piece, and their fingers are still close to it, we say they're still holding it
        for tagma in self.maybeHeldTagmata {
            if tagma == original {
                return true
            }
        }
        return false
    }
    
}
