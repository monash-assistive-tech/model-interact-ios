//
//  ViewController.swift
//  Lemon
//
//  Created by Andre Pham on 10/6/2023.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, CaptureDelegate, TagmataDetectionDelegate, LiveSpeechToTextDelegate {
    
    private var predictionInterval = 1
    private let captureSession = CaptureSession()
    private let synthesizer = SpeechSynthesizer()
    private let recognizer = SpeechRecognizer()
    private var tagmataDetector: DetectsTagmata = TagmataQuadrantDetector()
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
    private let interruptButton = LemonButton()
    private let toolbarStack = LemonVStack()
    private let intervalSlider = LemonLabelledSlider()
    private let detectorSwitch = LemonLabelledSwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubviews()
        self.setupObjectDetection()
        self.setupSpeechRecognition()
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
            .setSpacing(to: 16)
            .constrainHorizontal(padding: 16)
            .constrainTop(padding: Environment.inst.topSafeAreaHeight)
            .constrainBottom(padding: Environment.inst.bottomSafeAreaHeight)
            .addView(self.header)
            .addView(self.speakButton)
            .addView(self.recordButton)
            .addView(self.flipButton)
            .addView(self.interruptButton)
            .addSpacer()
            .addView(self.toolbarStack)
        
        // Header
        self.header
            .setText(to: "Lemon")
            .setSize(to: 24.0)
        
        // Speak button
        self.speakButton
            .setLabel(to: "Play Audio")
            .setOnTap({
                self.synthesizer.speak("Hello Lemon! Filler text is text that shares some characteristics of a real written text, but is random or otherwise generated. It may be used to display a sample of fonts, generate text for testing, or to spoof an e-mail spam filter.")
            })
        
        // Record button
        self.recordButton
            .setLabel(to: "Start Recording")
            .setOnTap({
                self.toggleAudioRecording()
            })
        
        // Interrupt button
        self.interruptButton
            .setLabel(to: "Interrupt")
            .setOnTap({
                self.synthesizer.stopSpeaking()
            })
            .setAccessibilityLabel(to: "STOP")
        
        // Flip button
        self.flipButton
            .setLabel(to: "Flip Camera")
            .setOnTap({
                self.flipCamera()
            })
        
        // Toolbar Stack
        self.toolbarStack
            .constrainHorizontal(padding: 32)
            .setBackgroundColor(to: UIColor.white)
            .setCornerRadius(to: 20)
            .addView(self.intervalSlider)
            .addView(self.detectorSwitch)
        
        // Interval slider
        self.intervalSlider
            .constrainHorizontal(padding: 24)
            .setPaddingVertical(to: 16)
        self.intervalSlider.stack
            .setSpacing(to: 16)
        self.intervalSlider.labelText
            .setText(to: "Interval")
            .setPadding(right: 30)
        self.intervalSlider.slider
            .setValues(minimumValue: 1, maximumValue: 60, value: self.predictionInterval)
            .setRoundToNearest(10)
            .setOnDrag({ value in
                self.predictionInterval = Int(value)
            })
        
        // Detector switch
        self.detectorSwitch
            .constrainHorizontal(padding: 24)
            .setPadding(bottom: 16)
        self.detectorSwitch.labelText
            .setText(to: "Alternate Model")
        self.detectorSwitch.switchView
            .setOnFlick({ isOn in
                if isOn {
                    self.tagmataDetector = TagmataDetector()
                } else {
                    self.tagmataDetector = TagmataQuadrantDetector()
                }
                self.setupObjectDetection()
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
        self.tagmataDetector.objectDetectionDelegate = self
    }
    
    private func setupSpeechRecognition() {
        self.recognizer.liveSpeechToTextDelegate = self
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
            
            if self.currentFrameID%self.predictionInterval == 0 {
                self.currentFrameID = 0
                self.tagmataDetector.makePrediction(on: frame)
            }
            
            self.setVideoImage(to: frame)
        }
    }
    
    func onTagmataDetection(outcome: TagmataDetectionOutcome?) {
        if let outcome {
            self.predictionOverlay.drawBoxes(for: outcome)
        }
    }
    
    func onWordRecognition(currentTranscription: SpeechText) {
        print(currentTranscription.words)
        if currentTranscription.contains("STOP") {
            self.synthesizer.stopSpeaking()
            self.recognizer.resetTranscript()
        }
    }

}

