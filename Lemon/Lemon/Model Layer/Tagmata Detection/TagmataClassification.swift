//
//  TagmataClassification.swift
//  Lemon
//
//  Created by Andre Pham on 20/6/2023.
//

import Foundation
import UIKit

/// For the sake of syntax, we're pretending the wings are part of the tagmata of an insect.
enum TagmataClassification: String {
    
    case head = "head-yellow"
    case thorax = "thorax-blue"
    case abdomen = "abdomen-magenta"
    case leftWing = "wing-red"
    case rightWing = "wing-green"
    
    public var colorDescription: String {
        switch self {
        case .head: return "Yellow"
        case .thorax: return "Blue"
        case .abdomen: return "Magenta"
        case .leftWing: return "Red"
        case .rightWing: return "Green"
        }
    }
    
    public var color: UIColor {
        switch self {
        case .head: return UIColor.yellow
        case .thorax: return UIColor.blue
        case .abdomen: return UIColor.magenta
        case .leftWing: return UIColor.red
        case .rightWing: return UIColor.green
        }
    }
    
}
