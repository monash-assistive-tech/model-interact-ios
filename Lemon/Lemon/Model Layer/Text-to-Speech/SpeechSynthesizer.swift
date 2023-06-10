//
//  SpeechSynthesizer.swift
//  Lemon
//
//  Created by Andre Pham on 11/6/2023.
//

import Foundation
import AVFoundation

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    
    enum Accent: String {
        case american = "en-US"
        case australian = "en-AU"
        // Add more if desired, e.g. en-GB, en-IE
    }
    
    private let synthesiser = AVSpeechSynthesizer()
    private var rate: Float = 0.55
    private var pitchMultiplier: Float = 0.9
    private var postUtteranceDelay: TimeInterval = 0.0
    private var volume: Float = 1.0 // [0.0, 1.0]
    private var voice: AVSpeechSynthesisVoice
    private var lastSpoken: String? = nil
    
    override init() {
        self.voice = AVSpeechSynthesisVoice(language: Accent.american.rawValue)!
        super.init()
        self.synthesiser.delegate = self
    }
    
    private func buildUtterance(speech: String) -> AVSpeechUtterance {
        let utterance = AVSpeechUtterance(string: speech)
        utterance.rate = self.rate
        utterance.pitchMultiplier = self.pitchMultiplier
        utterance.postUtteranceDelay = self.postUtteranceDelay
        utterance.volume = self.volume
        utterance.voice = self.voice
        return utterance
    }
    
    func speak(_ speech: String) {
        let utterance = self.buildUtterance(speech: speech)
        AudioSessionManager.inst.setToPlaybackMode()
        self.synthesiser.speak(utterance)
    }
    
    func stopSpeaking() {
        self.synthesiser.stopSpeaking(at: .immediate)
    }
    
    func repeatLastSpoken() {
        if let lastSpoken {
            self.speak(lastSpoken)
        }
    }
    
}
extension SpeechSynthesizer {
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) { }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) { }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) { }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
    
}
