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

            if let planeAnchor = anchor as? ARPlaneAnchor {
                // ModelEntity
                // - MeshResource.generatePlane() generates only rectangle.
                var descriptor = MeshDescriptor(name: "ARPlaneAnchor")
                descriptor.positions = MeshBuffer(planeAnchor.geometry.vertices)
                descriptor.primitives = .triangles(planeAnchor.geometry.triangleIndices.map { UInt32($0) })
                descriptor.textureCoordinates = MeshBuffer(planeAnchor.geometry.textureCoordinates)

                let material = UnlitMaterial(color: .green.withAlphaComponent(0.2))

                let modelEntity = ModelEntity(mesh: try! .generate(from: [descriptor]), materials: [material])
                anchorEntity.addChild(modelEntity)
            }

            arView.scene.anchors.append(anchorEntity)
        }
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let arView = arView else { return }

        for anchor in anchors {
            let filtered = arView.scene.anchors.filter {
                if case .anchor(let anchorIdentifier) = $0.anchoring.target {
                    return anchorIdentifier == anchor.identifier
                }
                return false
            }
            if let anchorEntity = filtered.first {
                if let planeAnchor = anchor as? ARPlaneAnchor {
                    // ModelEntity
                    var descriptor = MeshDescriptor(name: "ARPlaneAnchor")
                    descriptor.positions = MeshBuffer(planeAnchor.geometry.vertices)
                    descriptor.primitives = .triangles(planeAnchor.geometry.triangleIndices.map { UInt32($0) })
                    descriptor.textureCoordinates = MeshBuffer(planeAnchor.geometry.textureCoordinates)

#if true
                    // Recreate ModelEntity.
                    let material = UnlitMaterial(color: .green.withAlphaComponent(0.2))

                    let modelEntity = ModelEntity(mesh: try! .generate(from: [descriptor]), materials: [material])
                    anchorEntity.children.remove(at: 0)
                    anchorEntity.addChild(modelEntity)
#else
                    // Update ModelEntity.
                    // It does not look like good results...
                    let modelEntity = anchorEntity.children[0] as! ModelEntity
                    modelEntity.model?.mesh = try! .generate(from: [descriptor])
#endif
                }
            }
        }
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let arView = arView else { return }

        for anchor in anchors {
            let filtered = arView.scene.anchors.filter {
                if case .anchor(let anchorIdentifier) = $0.anchoring.target {
                    return anchorIdentifier == anchor.identifier
                }
                return false
            }
            if let anchorEntity = filtered.first {
                arView.scene.anchors.remove(anchorEntity)
            }
        }
    }
}
