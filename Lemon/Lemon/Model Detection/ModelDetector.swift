//
//  ModelDetector.swift
//  Lemon
//
//  Created by Mohamed Asjad on 7/5/2024.
//

import Foundation
import Vision

class ModelDetector: DetectsModel {
    
    
    private static let MAX_THREADS = 3
    
    public let id = DetectorID()
    private var visionModel: VNCoreMLModel? = nil
    private var request: VNCoreMLRequest? = nil
    var objectDetectionDelegate: ModelDetectionDeletegate?

    private var activeThreads = 0
    
    init(mlModelFile: URL) {
            self.setupModel(from: mlModelFile)
        }
    
    func makePrediction(on frame: CGImage) {
        guard self.activeThreads < Self.MAX_THREADS else {
            return
        }
        self.activeThreads += 1
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
            let detection = ModelDetectionOutcome(
                detectorID: self.id,
                frameSize: CGSize(width: frame.width, height: frame.height),
                detections: predictions.map({ ModelDetection(observation: $0) })
            )
            detection.merge()
            self.delegateOutcome(detection)
        } else {
            self.delegateOutcome(nil)
        }
    }
    
    private func setupModel(from mlModelFile: URL) {
            do {
                let model = try MLModel(contentsOf: mlModelFile)
                self.visionModel = try VNCoreMLModel(for: model)
            } catch {
                print("Error loading ML model:", error)
            }
        }
    
    private func createRequest() -> VNCoreMLRequest? {
            guard let visionModel = self.visionModel else {
                print("Vision model is not set up.")
                return nil
            }
            let request = VNCoreMLRequest(model: visionModel)
            request.imageCropAndScaleOption = .scaleFit
            return request
        }
    
    private func delegateOutcome(_ outcome: ModelDetectionOutcome?) {
        // Jump back to main thread
        DispatchQueue.main.async {
            self.activeThreads -= 1
            self.objectDetectionDelegate?.onModelDetection(outcome: outcome)
        }
    }
    
}
