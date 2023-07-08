//
//  TagmataDetector.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

class TagmataDetector: DetectsTagmata {
    
    public let id = DetectorID()
    private var visionModel: VNCoreMLModel? = nil
    private var request: VNCoreMLRequest? = nil
    public weak var objectDetectionDelegate: TagmataDetectionDelegate?
    
    init() {
        self.setupModel()
    }
    
    func makePrediction(on frame: CGImage) {
        // Run on non-UI related background thread
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            self.process(frame: frame)
        }
    }
    
    private func process(frame: CGImage) {
        assert(!Thread.isMainThread, "Predictions should be made off the main thread")
        guard let request = self.createRequest() else {
            self.delegateOutcome(nil)
            return
        }
        
        let handler = VNImageRequestHandler(cgImage: frame)
        do {
            try handler.perform([request])
        } catch {
            assertionFailure("Handler failed with error: \(error)")
        }
        
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            let detection = TagmataDetectionOutcome(
                detectorID: self.id,
                frame: frame,
                detections: predictions.map({ TagmataDetection(observation: $0) })
            )
            detection.merge()
            self.delegateOutcome(detection)
        } else {
            self.delegateOutcome(nil)
        }
    }
    
    private func setupModel() {
        if let model = try? TagmataDetector5_5000(configuration: MLModelConfiguration()).model {
            self.visionModel = try? VNCoreMLModel(for: model)
        }
    }
    
    private func createRequest() -> VNCoreMLRequest? {
        guard let visionModel else {
            self.setupModel()
            return nil
        }
        let request = VNCoreMLRequest(model: visionModel)
        request.imageCropAndScaleOption = .scaleFit
        return request
    }
    
    private func delegateOutcome(_ outcome: TagmataDetectionOutcome?) {
        // Jump back to main thread
        DispatchQueue.main.async {
            self.objectDetectionDelegate?.onTagmataDetection(outcome: outcome)
        }
    }
    
}
