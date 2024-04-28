//
//  DetectorID.swift
//  Lemon
//
//  Created by Ishrat Kaur on 29/4/2024.
//

import Foundation

struct WaterCycleDetectorID {
    
    private let id = UUID() // universally unique identifier
    public var idString: String {
        // accessible outside the struct
        return self.id.uuidString // should return unique identifier as a string
    }

    // checks if ids are equal
    func matches(_ other: WaterCycleDetectorID) -> Bool {
        return self.id == other.id
    }
    
}
