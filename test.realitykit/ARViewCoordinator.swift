//
//  ARViewCoordinator.swift
//  test.realitykit
//
//  Created by H1Gdev on 2022/08/01.
//

import RealityKit
import ARKit

class ARViewCoordinator: NSObject {
    var arView: ARView? {
        willSet {
            removeAllAnchorEntities()
        }
        didSet {
        }
    }

    private func removeAllAnchorEntities() {
        guard let arView = arView else { return }

        arView.scene.anchors.removeAll()
    }
}

extension ARViewCoordinator: ARSessionDelegate {

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let arView = arView else { return }

        for anchor in anchors {
            let anchorEntity = AnchorEntity(anchor: anchor)

            arView.scene.anchors.append(anchorEntity)
        }
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let arView = arView else { return }

        for anchor in anchors {
            let filtered = arView.scene.anchors.filter { $0.anchorIdentifier == anchor.identifier }
            if let anchorEntity = filtered.first {
                arView.scene.anchors.remove(anchorEntity)
            }
        }
    }
}
