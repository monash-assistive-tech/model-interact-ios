//
//  SpeechText.swift
//  Lemon
//
//  Created by Andre Pham on 23/6/2023.
//

import Foundation

class SpeechText {
    
    public let text: String
    public let words: [String]
    public var lastWord: String {
        return self.words.last!
    }
    
    init(text: String) {
        self.text = text
        self.words = self.text.components(separatedBy: " ")
    }
    
    func contains(_ text: String) -> Bool {
        return self.text.lowercased().contains(text.lowercased())
    }
    
    
}
