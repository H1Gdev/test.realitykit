//
//  CameraViewCoordinator.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/11/04.
//

import UIKit
import AVFoundation

class CameraViewCoordinator: NSObject {
    var cameraView: CameraView? {
        willSet {
            removeGesture()
        }
        didSet {
            addGesture()
        }
    }

    private var videoZoomFactor = 1.0
}

extension CameraViewCoordinator {

    private func addGesture() {
        guard let cameraView = cameraView else { return }

        cameraView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(recognizer:))))
    }

    private func removeGesture() {
        guard let cameraView = cameraView else { return }

        cameraView.gestureRecognizers?.forEach(cameraView.removeGestureRecognizer)
    }

    @objc
    private func handlePinch(recognizer: UIPinchGestureRecognizer) {
        guard let cameraView = cameraView else { return }

        guard let videoPreviewLayer = cameraView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer else { return }
        guard let device = (videoPreviewLayer.session?.inputs.first as? AVCaptureDeviceInput)?.device else { return }

        if recognizer.state == .began {
            videoZoomFactor = device.videoZoomFactor
        }

        var toVideoZoomFactor = videoZoomFactor * recognizer.scale
        if toVideoZoomFactor < device.minAvailableVideoZoomFactor {
            toVideoZoomFactor = device.minAvailableVideoZoomFactor
        } else if device.maxAvailableVideoZoomFactor < toVideoZoomFactor {
            toVideoZoomFactor = device.maxAvailableVideoZoomFactor
        }

        do {
            try device.lockForConfiguration()
            device.ramp(toVideoZoomFactor: toVideoZoomFactor, withRate: 32.0)
            device.unlockForConfiguration()
            videoZoomFactor = device.videoZoomFactor
        } catch {
            print("[Camera][Error]can not change zoom factor.")
        }
    }
}
