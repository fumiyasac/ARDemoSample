//
//  CustomSceneView.swift
//  ARDemoSample
//
//  Created by 酒井文也 on 2024/05/19.
//

import SceneKit
import SwiftUI

// MARK: - UIViewRepresentable

//
struct CustomSceneView: UIViewRepresentable {

    // MARK: - `@Binding` Property

    @Binding var scene: SCNScene?

    // MARK: - Function

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}
