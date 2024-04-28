//
//  DetectsWaterCycle.swift
//  Lemon
//
//  Created by Ishrat Kaur on 29/4/2024.
//

import Foundation
import CoreGraphics // for image processing

// water cycle detector must conform to this protocol
protocol DetectsWaterCycle {
    
    var id: WaterCycleDetectorID { get } // classes must have a id property that can only be read, so each detector would have a unique id
    
    // TODO: water cycle detection delegate
    
    func makePrediction(on frame: CGImage)
    
}

