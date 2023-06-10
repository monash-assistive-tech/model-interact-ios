//
//  ViewController.swift
//  Lemon
//
//  Created by Andre Pham on 10/6/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private let synthesizer = SpeechSynthesizer()
    private let recognizer = SpeechRecognizer()
    private var isRecording = false
    
    private let stack = UIStackView()
    private let header = UILabel()
    private let speakButton = UIButton(type: .roundedRect)
    private let recordButton = UIButton(type: .roundedRect)
    private var verticalSpacer: UIView {
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return spacerView
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
        self.speakButton.setTitle("Play Audio", for: .normal)
        self.speakButton.addTarget(self, action: #selector(self.onSpeakButtonPressed), for: .touchUpInside)
    }
    
    private func setupRecordButton() {
        self.recordButton.setTitle("Start Recording", for: .normal)
        self.recordButton.addTarget(self, action: #selector(self.onRecordButtonPressed), for: .touchUpInside)
    }
    
    private func arrangeViews() {
        self.stack.addArrangedSubview(self.header)
        self.stack.addArrangedSubview(self.speakButton)
        self.stack.addArrangedSubview(self.recordButton)
        self.stack.addArrangedSubview(self.verticalSpacer)
        self.view.addSubview(self.stack)
        NSLayoutConstraint.activate([
            self.stack.topAnchor.constraint(equalTo: view.topAnchor),
            self.stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.stack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupStack()
        self.setupHeader()
        self.setupSpeakButton()
        self.setupRecordButton()
        self.arrangeViews()
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

}

