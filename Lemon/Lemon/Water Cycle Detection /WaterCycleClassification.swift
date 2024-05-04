//
//  WaterCycleClassification.swift
//  Lemon
//
//  Created by Mohamed Asjad on 1/5/2024.
//

import Foundation
import UIKit

/// For the sake of syntax, we're pretending the wings are part of the tagmata of an insect.
enum WaterCycleClassification: String, CaseIterable {
    case sun = "Sun"
    case rain = "Rain"
    case infiltration = "Infiltration"
    case plantUptake = "PlantUptake"
    case runOff = "RunOff"
    case snow = "Snow"
    case snow_melt = "SnowMelt"
    case mountain = "Mountain"
    case precipitation = "Precipitation"
    case river = "River"
    case condensation = "Condensation"
    case groundWater = "GroundWater"
    case cloud = "Cloud"
    case ocean = "Ocean"
    case transpiration = "Transpiration"
    case evaporation = "Evaporation"
    case arrow = "BlackArrow"
    case unidentified = "Undefined"
    
    
    public var name: String {
        switch self {
        case .sun: return Strings("watercycle.sun").local
        case .rain: return Strings("watercycle.rain").local
        case .infiltration: return Strings("watercycle.infiltration").local
        case .plantUptake: return Strings("watercycle.plant_uptake").local
        case .runOff: return Strings("watercycle.run_off").local
        case .snow: return Strings("watercycle.snow").local
        case .snow_melt: return Strings("watercycle.snow_melt").local
        case .mountain: return Strings("watercycle.mountain").local
        case .precipitation: return Strings("watercycle.precipitation").local
        case .river: return Strings("watercycle.river").local
        case .condensation: return Strings("watercycle.condensation").local
        case .groundWater: return Strings("watercycle.ground_water").local
        case .cloud: return Strings("watercycle.cloud").local
        case .ocean: return Strings("watercycle.ocean").local
        case .transpiration: return Strings("watercycle.transpiration").local
        case .evaporation: return Strings("watercycle.evaporation").local
        case .arrow: return Strings("watercycle.arrow").local
        case.unidentified:return Strings("watercycle.sun").local
        }
    }
    
    public var description: String {
        switch self {
        case .sun: return Strings("description.sun").local
        case .rain: return Strings("description.rain").local
        case .infiltration: return Strings("description.infiltration").local
        case .plantUptake: return Strings("description.plant_uptake").local
        case .runOff: return Strings("description.run_off").local
        case .snow: return Strings("description.snow").local
        case .snow_melt: return
            Strings("description.snow_melt").local
        case .mountain: return
            Strings("description.mountain").local
        case .precipitation: return Strings("description.precipitation").local
        case .river: return Strings("description.river").local
        case .condensation: return Strings("description.condensation").local
        case .groundWater: return Strings("description.ground_water").local
        case .cloud: return Strings("description.cloud").local
        case .ocean: return Strings("description.ocean").local
        case .transpiration: return Strings("description.transpiration").local
        case .evaporation: return Strings("description.evaporation").local
        case .arrow: return Strings("description.arrow").local
        case.unidentified:return Strings("watercycle.sun").local
        }
    }
}
