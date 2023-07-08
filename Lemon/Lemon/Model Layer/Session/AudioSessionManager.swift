//
//  AudioSessionManager.swift
//  Lemon
//
//  Created by Andre Pham on 11/6/2023.
//

import Foundation
import AVFoundation

class AudioSessionManager {
    
    public static let inst = AudioSessionManager()
    private var audioSession: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }
    
    private init() { }
    
    func setup() {
//        self.setToPlaybackMode()
        self.setToSpeakerMode()
    }
    
    func setToPlaybackMode() {
        return
        do {
            try self.audioSession.setCategory(.playback, mode: .default, options: [])
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
//            assertionFailure("Failed to set audio session to playback mode: \(error)")
        }
    }
    
    func setToRecordMode() {
        return
        do {
            try self.audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .allowBluetoothA2DP])
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
//            assertionFailure("Failed to set audio session to record mode: \(error)")
        }
    }
    
    /// This mode allows the processing of both input and output text simultaneously. However, it is bound to the device's peripherals (no headset/speakers allowed).
    func setToSpeakerMode() {
        do {
            try self.audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            assertionFailure("Failed to set audio session to speaker mode: \(error)")
        }
    }
    
}
