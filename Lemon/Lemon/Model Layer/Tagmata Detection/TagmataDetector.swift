//
//  TagmataDetector.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

class TagmataDetector {
    
    private var request: VNCoreMLRequest? = nil
    public weak var objectDetectionDelegate: TagmataDetectionDelegate?
    
    init() {
        self.setupRequest()
    }
    
    func makePrediction(on frame: CGImage) {
        // Run on non-UI related background thread
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            self.process(frame: frame)
        }
    }
    
    private func process(frame: CGImage) {
        assert(!Thread.isMainThread, "Predictions should be made off the main thread")
        guard let request = self.request else {
            // If the request previously failed to setup, try to set it up again and discard this frame
            self.setupRequest()
            return
        }
        let handler = VNImageRequestHandler(cgImage: frame)
        try? handler.perform([request])
    }
    
    private func setupRequest() {
        if let model: MLModel = try? TagmataDetector1(configuration: MLModelConfiguration()).model,
           let visionModel = try? VNCoreMLModel(for: model) {
            self.request = VNCoreMLRequest(model: visionModel, completionHandler: self.visionRequestDidComplete)
            self.request?.imageCropAndScaleOption = .scaleFit
        }
    }
    
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            let detection: TagmataDetectionOutcome = predictions.map({ TagmataDetection(observation: $0) })
            self.delegateOutcome(detection)
        }
    }
    
    private func delegateOutcome(_ outcome: TagmataDetectionOutcome) {
        // Jump back to main thread
        DispatchQueue.main.async {
            self.objectDetectionDelegate?.onTagmataDetection(outcome: outcome)
        }
    }
    
}
