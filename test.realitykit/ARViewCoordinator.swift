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
        didSet {
        }
    }
}

extension ARViewCoordinator: ARSessionDelegate {
}
