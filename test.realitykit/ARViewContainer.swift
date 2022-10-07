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

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        addCoachingOverlay(arView: arView)

        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()

        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)

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
}
