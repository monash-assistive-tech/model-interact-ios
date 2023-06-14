//
//  ObjectDetector.swift
//  Lemon
//
//  Created by Andre Pham on 14/6/2023.
//

import Foundation
import Vision

class ObjectDetector {
    
    private var request: VNCoreMLRequest? = nil
    public weak var objectDetectionDelegate: ObjectDetectionDelegate?
    
    init() {
        self.setupRequest()
    }
    
    private func setupRequest() {
        if let model: MLModel = try? CarLicensePlateExperimentFullNetwork(configuration: MLModelConfiguration()).model,
           let visionModel = try? VNCoreMLModel(for: model) {
            self.request = VNCoreMLRequest(model: visionModel, completionHandler: self.visionRequestDidComplete)
            self.request?.imageCropAndScaleOption = .centerCrop
        }
    }
    
    func process(frame: CGImage) {
        guard let request = self.request else {
            // If the request previously failed to setup, try to set it up again and discard this frame
            self.setupRequest()
            return
        }
        let handler = VNImageRequestHandler(cgImage: frame)
        try? handler.perform([request])
    }
    
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
            self.objectDetectionDelegate?.onObjectDetection(outcome: predictions)
        }
    }
    
}
