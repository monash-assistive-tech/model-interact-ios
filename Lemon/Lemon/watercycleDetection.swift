//
//  watercycleDetection.swift
//  Lemon
//
//  Created by Andy liu on 2024/5/1.
//

import Foundation
import UIKit
import AVFoundation
import Vision

class watercycleDetection: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    // Variables for video capture and display, model requests, and annotation layers
    var previewLayer: AVCaptureVideoPreviewLayer!
    var detectionRequest: VNCoreMLRequest?
    var detectionSession: AVCaptureSession!
    var annotationsLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCameraLiveView()
        setupModel()
        setupAnnotationsLayer()
    }

    func setupAnnotationsLayer() {
        annotationsLayer = CALayer()
        annotationsLayer.frame = view.bounds
        annotationsLayer.masksToBounds = true
        view.layer.addSublayer(annotationsLayer)
    }

    func setupCameraLiveView() {
        detectionSession = AVCaptureSession()
        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: camera)
            detectionSession.addInput(input)
        } catch {
            print("Camera input error: \(error)")
        }

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        detectionSession.addOutput(output)

        previewLayer = AVCaptureVideoPreviewLayer(session: detectionSession)
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        detectionSession.startRunning()
    }

    func setupModel() {
        guard let model = try? VNCoreMLModel(for: watercycle().model) else { return }
        detectionRequest = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
            self?.processDetections(for: request, error: error)
        })
    }

    func processDetections(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.annotationsLayer.sublayers?.forEach { $0.removeFromSuperlayer() }

            guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
            for result in results {
                let bbox = strongSelf.transformBoundingBox(result.boundingBox)
                strongSelf.drawBoundingBox(bbox)

                if let topLabel = result.labels.first {
                    strongSelf.drawLabel(topLabel.identifier, at: bbox.origin)
                }
            }
        }
    }

    func transformBoundingBox(_ box: CGRect) -> CGRect {
        let x = box.origin.x * previewLayer.bounds.width
        let y = (1 - box.origin.y - box.size.height) * previewLayer.bounds.height
        let width = box.size.width * previewLayer.bounds.width
        let height = box.size.height * previewLayer.bounds.height
        return CGRect(x: x, y: y, width: width, height: height)
    }

    func drawBoundingBox(_ rect: CGRect) {
        let boundingBox = CALayer()
        boundingBox.frame = rect
        boundingBox.borderColor = UIColor.red.cgColor
        boundingBox.borderWidth = 2
        annotationsLayer.addSublayer(boundingBox)
    }

    func drawLabel(_ text: String, at point: CGPoint) {
        let label = CATextLayer()
        label.string = text
        label.fontSize = 14
        label.alignmentMode = .left
        label.foregroundColor = UIColor.white.cgColor
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        label.frame = CGRect(x: point.x, y: point.y - 20, width: 200, height: 20)
        annotationsLayer.addSublayer(label)
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer),
              let detectionRequest = self.detectionRequest else { return }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Failed to perform detection.\n\(error.localizedDescription)")
        }
    }
}

