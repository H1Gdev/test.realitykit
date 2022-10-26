//
//  ARViewContainer.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/08/01.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()

        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
