//
//  AudioRecorder.swift
//  Lemon
//
//  Created by Andre Pham on 26/7/2023.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    private var audioRecorder: AVAudioRecorder!
    private var audioPlayer: AVAudioPlayer!
    public var isRecording: Bool {
        return self.audioRecorder?.isRecording ?? false
    }
    public var isPlaying: Bool {
        return self.audioPlayer?.isPlaying ?? false
    }
    
    private let audioFileName = "test.m4a"
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(audioFileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC), // AAC is a good choice for lossy compression
            AVSampleRateKey: 44100, // 44.1 kHz is standard for audio CD quality
            AVNumberOfChannelsKey: 2, // 2 signifies stereo recording
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue // High quality recording
        ]
        
        // Better quality audio (less noise)
        AudioSessionManager.inst.setToRecordMode()

        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stopRecording() {
        self.audioRecorder.stop()
        self.audioRecorder = nil
        // Undo setting to record mode
        AudioSessionManager.inst.setPreviousMode()
    }
    
    func startPlayback() {
        let audioFilename = self.getDocumentsDirectory().appendingPathComponent(audioFileName)
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
        } catch {
            print("Could not start playback: \(error)")
        }
    }
    
    func stopPlayback() {
        audioPlayer.stop()
        audioPlayer = nil
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
