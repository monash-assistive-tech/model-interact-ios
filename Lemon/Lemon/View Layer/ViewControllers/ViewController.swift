//
//  ViewController.swift
//  Lemon
//
//  Created by Andre Pham on 10/6/2023.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, CaptureDelegate, TagmataDetectionDelegate {
    
    private static let PREDICTION_INTERVAL = 1
    
    private let captureSession = CaptureSession()
    private let synthesizer = SpeechSynthesizer()
    private let recognizer = SpeechRecognizer()
    private let objectDetector = TagmataDetector()
    private var currentFrameID = 0
    private var overlayFrameSyncRequired = true
    private var isRecordingAudio = false
    
    private var root: LemonView { return LemonView(self.view) }
    private var image = LemonImage()
    private var predictionOverlay = PredictionBoxView()
    private let stack = LemonVStack()
    private let header = LemonText()
    private let speakButton = LemonButton()
    private let recordButton = LemonButton()
    private let flipButton = LemonButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupObjectDetection()
        self.setupAndBeginCapturingVideoFrames()
        // Stop the device automatically sleeping
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func setupSubviews() {
        // Video view
        self.root.addSubview(self.image)
        self.image.setFrame(to: self.root.frame)
        
        // Prediction Overlay
        self.image.addSubview(self.predictionOverlay)
        
        // Stack
        self.root.addSubview(self.stack)
        self.stack
            .constrainTo(self.root)
            .addView(self.header)
            .addView(self.speakButton)
            .addView(self.recordButton)
            .addView(self.flipButton)
            .addSpacer()
        
        // Header
        self.header
            .setText(to: "Lemon")
            .setSize(to: 24.0)
        
        // Speak button
        self.speakButton
            .setLabel(to: "Play Audio")
            .setOnTap({
                self.synthesizer.speak("Hello Lemon!")
            })
        
        // Record button
        self.recordButton
            .setLabel(to: "Start Recording")
            .setOnTap({
                self.toggleAudioRecording()
            })
        
        // Flip button
        self.flipButton
            .setLabel(to: "Flip Camera")
            .setOnTap({
                self.flipCamera()
            })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.captureSession.stopCapturing {
            super.viewWillDisappear(animated)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // React to change in device orientation
        self.setupAndBeginCapturingVideoFrames()
        self.overlayFrameSyncRequired = true
    }
    
    override func viewDidLayoutSubviews() {
        self.overlayFrameSyncRequired = true
    }
    
    private func setVideoImage(to image: CGImage) {
        self.image.setImage(image)
        if self.overlayFrameSyncRequired {
            self.matchOverlayFrame()
            self.overlayFrameSyncRequired = false
        }
    }
    
    private func matchOverlayFrame() {
        let overlaySize = self.image.imageSize
        var overlayFrame = CGRect(origin: CGPoint(), size: overlaySize).scale(toAspectFillSize: self.image.frame.size)
        // Align overlay frame center to view center
        overlayFrame.origin.x += self.image.frame.center.x - overlayFrame.center.x
        overlayFrame.origin.y += self.image.frame.center.y - overlayFrame.center.y
        self.predictionOverlay.setFrame(to: overlayFrame)
    }
    
    private func setupAndBeginCapturingVideoFrames() {
        self.captureSession.setUpAVCapture { error in
            if let error {
                assertionFailure("Failed to setup camera: \(error)")
                return
            }
            
            self.captureSession.captureDelegate = self
            self.captureSession.startCapturing()
        }
    }
    
    private func setupObjectDetection() {
        self.objectDetector.objectDetectionDelegate = self
    }
    
    private func toggleAudioRecording() {
        self.isRecordingAudio.toggle()
        if self.isRecordingAudio {
            self.recordButton.setLabel(to: "End Recording")
            self.recognizer.resetTranscript()
            self.recognizer.startTranscribing()
        } else {
            self.recordButton.setLabel(to: "Start Recording")
            self.recognizer.stopTranscribing()
            print(self.recognizer.transcript)
        }
    }
    
    private func flipCamera() {
        self.captureSession.flipCamera { error in
            if let error {
                assertionFailure("Failed to flip camera: \(error)")
                return
            }
        }
    }
    
    func onCapture(session: CaptureSession, frame: CGImage?) {
        if let frame {
            self.currentFrameID += 1
            
            if self.currentFrameID%Self.PREDICTION_INTERVAL == 0 {
                self.currentFrameID = 0
                self.objectDetector.makePrediction(on: frame)
            }
            
            self.setVideoImage(to: frame)
        }
    }
    
    func onTagmataDetection(outcome: TagmataDetectionOutcome) {
        self.predictionOverlay.drawBoxes(for: outcome)
    }

}

