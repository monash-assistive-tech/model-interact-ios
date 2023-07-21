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
        self.setToSpeakerMode()
    }
    
    /// This mode is the default mode used for stuff like voice calls, and allows the processing of both input and output text simultaneously. It works great if you're using a bluetooth headset or are holding a phone to your ear, but not if you want to have the main speaker producing the audio. Note: it also has sidetone.
    func setToVOIPMode() {
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowBluetoothA2DP])
            try self.audioSession.setActive(true)
        } catch {
            assertionFailure("Failed to set audio session to universal mode: \(error)")
        }
    }
    
    /// This mode is just for audio playback.
    func setToPlaybackMode() {
        do {
            try self.audioSession.setCategory(.playback, mode: .default, options: [])
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            assertionFailure("Failed to set audio session to playback mode: \(error)")
        }
    }
    
    /// This mode is just for audio recording.
    func setToRecordMode() {
        do {
            try self.audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .mixWithOthers, .allowBluetoothA2DP])
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            assertionFailure("Failed to set audio session to record mode: \(error)")
        }
    }
    
    /// This is the "speaker mode" in voice calls. This mode allows the processing of both input and output text simultaneously. However, it is bound to the device's peripherals (no headset/speakers allowed).
    func setToSpeakerMode() {
        do {
            try self.audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            assertionFailure("Failed to set audio session to speaker mode: \(error)")
        }
    }
    
}
