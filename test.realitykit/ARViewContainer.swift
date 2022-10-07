//
//  ARViewContainer.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/08/01.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {

    func makeCoordinator() -> ARViewCoordinator {
        ARViewCoordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        addCoachingOverlay(arView: arView)
        context.coordinator.arView = arView

        startARSession(arView: arView, delegate: context.coordinator)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    private func addCoachingOverlay(arView: ARView) {
        let arCoachingOverlayView = ARCoachingOverlayView()
        arCoachingOverlayView.session = arView.session
        arCoachingOverlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        arCoachingOverlayView.goal = .horizontalPlane
        arView.addSubview(arCoachingOverlayView)
    }

    private func removeCoachingOverlay(arView: ARView) {
        for subview in arView.subviews {
            if let arCoachingOverlayView = subview as? ARCoachingOverlayView {
                arCoachingOverlayView.removeFromSuperview()
            }
        }
    }

    private func startARSession(arView: ARView, delegate: ARSessionDelegate, options:ARSession.RunOptions = []) {
        arView.automaticallyConfigureSession = true

#if false
        let configuration = ARBodyTrackingConfiguration()
#else
        let configuration = ARWorldTrackingConfiguration()
#endif
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic

#if false
        configuration.sceneReconstruction = .meshWithClassification
        // https://developer.apple.com/documentation/realitykit/arview/debugoptions-swift.struct
        arView.debugOptions.insert(.showAnchorGeometry)
#endif

        arView.session.delegate = delegate
        arView.session.run(configuration, options: options)
    }
}
