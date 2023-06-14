//
//  ViewController.swift
//  Lemon
//
//  Created by Andre Pham on 10/6/2023.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, CaptureDelegate, ObjectDetectionDelegate {
    
    private static let PREDICTION_INTERVAL = 1
    
    private let captureSession = CaptureSession()
    private let synthesizer = SpeechSynthesizer()
    private let recognizer = SpeechRecognizer()
    private let objectDetector = ObjectDetector()
    private var imageView = UIImageView()
    private var overlayView = PredictionBoxView()
    private var currentFrame: CGImage? = nil
    private var currentFrameID = 0
    private var overlayFrameSyncRequired = true
    private var isRecordingAudio = false
    
    private let stack = LemonVStack()
    private let header = LemonText(text: "Lemon").setSize(to: 24.0)
    private let speakButton = LemonButton(label: "Play Audio")
    private let recordButton = LemonButton(label: "Start Recording")
    private let flipButton = LemonButton(label: "Flip Camera")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupSubviews()
        self.setupObjectDetection()
        self.setupAndBeginCapturingVideoFrames()
        // Stop the device automatically sleeping
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func setupSubviews() {
        // Buttons
        self.speakButton.setOnTap({
            self.synthesizer.speak("Hello Lemon!")
        })
        self.recordButton.setOnTap({
            self.toggleAudioRecording()
        })
        self.flipButton.setOnTap({
            self.flipCamera()
        })
        
        // Stack
        self.stack
            .addView(self.header)
            .addView(self.speakButton)
            .addView(self.recordButton)
            .addView(self.flipButton)
            .addSpacer()
            .addTo(self.view)
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
    
    private func setupView() {
        self.imageView.frame = self.view.frame
        self.view.addSubview(self.imageView)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.addSubview(self.overlayView)
    }
    
    private func setView(to image: CGImage) {
        self.imageView.image = UIImage(cgImage: image)
        if self.overlayFrameSyncRequired {
            self.matchOverlayFrame()
            self.overlayFrameSyncRequired = false
        }
    }
    
    private func matchOverlayFrame() {
        let overlaySize = self.imageView.image!.size
        var overlayFrame = CGRect(origin: CGPoint(), size: overlaySize).scale(toAspectFillSize: self.imageView.frame.size)
        // Align overlay frame center to view center
        overlayFrame.origin.x += self.imageView.frame.center.x - overlayFrame.center.x
        overlayFrame.origin.y += self.imageView.frame.center.y - overlayFrame.center.y
        self.overlayView.frame = overlayFrame
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
            self.currentFrame = frame
            
            if self.currentFrameID%Self.PREDICTION_INTERVAL == 0 {
                self.currentFrameID = 0
                self.objectDetector.makePrediction(on: frame)
            }
            
            self.setView(to: frame)
        }
    }
    
    func onObjectDetection(outcome: ObjectDetectionOutcome) {
        self.overlayView.drawBoxes(for: outcome)
    }

}

