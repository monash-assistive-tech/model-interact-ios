//
//  Commands.swift
//  Lemon
//
//  Created by Andre Pham on 21/7/2023.
//

import Foundation

/// The various commands the user can speak to perform.
/// These enum values directly represent the command to speak. `case name` responds to the user saying the word "name".
/// If you want your command to be different from the enum name, add a string value. For instance, `case name = "say name"` for the command "say name".
enum Command: String, CaseIterable {
    
    /// Speak the name of the held insect tagma
    case name
    /// Speak the information of the held insect tagma
    case information
    /// Check if the insect is completed
    case completed
    /// A test command (for development purposes)
    case test
    /// No command
    case none
    
}
