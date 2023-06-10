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
        self.setToPlaybackMode()
    }
    
    func setToPlaybackMode() {
        do {
            try self.audioSession.setCategory(.playback, mode: .default, options: [])
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("[LEMON ERROR] Failed to set audio session to playback mode: \(error)")
        }
    }
    
    func setToRecordMode() {
        do {
            try self.audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
            try self.audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("[LEMON ERROR] Failed to setup audio session: \(error)")
        }
    }
    
}
