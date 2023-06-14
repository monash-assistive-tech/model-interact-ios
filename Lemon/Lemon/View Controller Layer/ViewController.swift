//
//  ViewController.swift
//  Lemon
//
//  Created by Andre Pham on 10/6/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, CaptureDelegate {
    
    private static let PREDICTION_INTERVAL = 1
    
    private let captureSession = CaptureSession()
    private let synthesizer = SpeechSynthesizer()
    private let recognizer = SpeechRecognizer()
    private let objectDetector = ObjectDetector()
    private var imageView = UIImageView()
    private var overlayView = UIView()
    private var currentFrame: CGImage? = nil
    private var currentFrameID = 0
    private var overlayFrameSyncRequired = true
    private var isRecording = false
    
    private let stack = UIStackView()
    private let header = UILabel()
    private let speakButton = UIButton(type: .custom)
    private let recordButton = UIButton(type: .custom)
    private let flipButton = UIButton(type: .custom)
    private var verticalSpacer: UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return spacerView
    }
    private var buttonConfig: UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.background.cornerRadius = 20
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 20,
            bottom: 10,
            trailing: 20
        )
        return configuration
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupStack()
        self.setupHeader()
        self.setupSpeakButton()
        self.setupRecordButton()
        self.setupFlipButton()
        self.arrangeViews()
        self.setupAndBeginCapturingVideoFrames()
        // Stop the device automatically sleeping
        UIApplication.shared.isIdleTimerDisabled = true
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
    
    private func arrangeViews() {
        self.stack.addArrangedSubview(self.header)
        self.stack.addArrangedSubview(self.speakButton)
        self.stack.addArrangedSubview(self.recordButton)
        self.stack.addArrangedSubview(self.flipButton)
        self.stack.addArrangedSubview(self.verticalSpacer)
        self.view.addSubview(self.stack)
        NSLayoutConstraint.activate([
            self.stack.topAnchor.constraint(equalTo: view.topAnchor),
            self.stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupStack() {
        self.stack.axis = .vertical
        self.stack.alignment = .center
        self.stack.spacing = 16
        self.stack.translatesAutoresizingMaskIntoConstraints = false
        self.stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.stack.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupHeader() {
        self.header.text = "Lemon"
        self.header.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func setupSpeakButton() {
        var config = self.buttonConfig
        config.title = "Play Audio"
        self.speakButton.configuration = config
        self.speakButton.addTarget(self, action: #selector(self.onSpeakButtonPressed), for: .touchUpInside)
    }
    
    private func setupRecordButton() {
        var config = self.buttonConfig
        config.title = "Start Recording"
        self.recordButton.configuration = config
        self.recordButton.addTarget(self, action: #selector(self.onRecordButtonPressed), for: .touchUpInside)
    }
    
    private func setupFlipButton() {
        var config = self.buttonConfig
        config.title = "Flip Camera"
        self.flipButton.configuration = config
        self.flipButton.addTarget(self, action: #selector(self.onFlipButtonPressed), for: .touchUpInside)
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
    
    @objc private func onSpeakButtonPressed() {
        self.synthesizer.speak("Hello Lemon!")
    }
    
    @objc private func onRecordButtonPressed() {
        self.isRecording.toggle()
        if self.isRecording {
            self.recordButton.setTitle("End Recording", for: .normal)
            self.recognizer.resetTranscript()
            self.recognizer.startTranscribing()
        } else {
            self.recordButton.setTitle("Start Recording", for: .normal)
            self.recognizer.stopTranscribing()
            print(self.recognizer.transcript)
        }
    }
    
    @objc private func onFlipButtonPressed() {
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
                self.objectDetector.process(frame: frame)
            }
            
            self.setView(to: frame)
        }
    }

}

