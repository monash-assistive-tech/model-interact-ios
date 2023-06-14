//
//  ObjectDetectionDelegate.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

protocol ObjectDetectionDelegate: AnyObject {
    
    func onObjectDetection(outcome: ObjectDetectionOutcome)
    
}
