//
//  CameraView.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/11/04.
//

import UIKit
import AVFoundation

class CameraView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        _ = initCaptureSession
        (layer.sublayers?.first as? AVCaptureVideoPreviewLayer)?.frame = frame
    }

    lazy var initCaptureSession: Void = {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back).devices.first else { return }
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }

        let session = AVCaptureSession()
        if session.canAddInput(input) {
            session.addInput(input)
        }
        session.startRunning()

        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(videoPreviewLayer, at: 0)
        updateVideoOrientation(orientation: UIDevice.current.orientation)
    }()

    func updateVideoOrientation(orientation: UIDeviceOrientation) {
        let videoOrientation = { orientation -> AVCaptureVideoOrientation in
            switch (orientation) {
            case .portraitUpsideDown:
                return .portraitUpsideDown
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
            default:
                return .portrait
            }
        }(orientation)

        guard let videoPreviewLayer = layer.sublayers?.first as? AVCaptureVideoPreviewLayer else { return }
        if orientation == .portrait || orientation == .landscapeLeft || orientation == .landscapeRight {
            videoPreviewLayer.connection?.videoOrientation = videoOrientation
        }
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()

        guard let videoPreviewLayer = layer.sublayers?.first as? AVCaptureVideoPreviewLayer else { return }
        videoPreviewLayer.session?.stopRunning()
        videoPreviewLayer.removeFromSuperlayer()
    }
}
