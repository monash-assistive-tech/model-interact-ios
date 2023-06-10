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

    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Create a UIStackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding to the stack view using layout margins
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        // Create a header label
        let headerLabel = UILabel()
        headerLabel.text = "Hello World"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        // Create a button
        let button = UIButton(type: .system)
        button.setTitle("Hello Button", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        
        // Add the header label and button to the stack view
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(button)
        
        // Add the stack view to the view
        view.addSubview(stackView)
        
        // Set stack view constraints to take up the entire screen
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
//        // Add border to the stack view
//        button.layer.borderWidth = 1.0
//        button.layer.borderColor = UIColor.black.cgColor
//        // Add border to the stack view
//        headerLabel.layer.borderWidth = 1.0
//        headerLabel.layer.borderColor = UIColor.black.cgColor
        
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        spacerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        stackView.addArrangedSubview(spacerView)
    }
    
    @objc private func buttonTapped() {
        self.isRecording.toggle()
        if self.isRecording {
            self.recognizer.resetTranscript()
            self.recognizer.startTranscribing()
        } else {
            self.recognizer.stopTranscribing()
            print(self.recognizer.transcript)
        }
    }

}

