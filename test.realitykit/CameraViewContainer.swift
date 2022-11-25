//
//  CameraViewContainer.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/11/04.
//

import SwiftUI

struct CameraViewContainer: UIViewRepresentable {
    @Binding var orientation: UIDeviceOrientation

    func makeCoordinator() -> CameraViewCoordinator {
        CameraViewCoordinator()
    }

    func makeUIView(context: Context) -> CameraView {
        let cameraView = CameraView(frame: .zero)

        context.coordinator.cameraView = cameraView

        return cameraView
    }

    func updateUIView(_ uiView: CameraView, context: Context) {
        uiView.updateVideoOrientation(orientation: orientation)
    }
}
