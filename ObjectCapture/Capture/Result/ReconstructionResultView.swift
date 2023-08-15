//
//  ReconstructionResultView.swift
//  Pocket-Object
//
//  Created by eden on 2023/06/10.
//


import SwiftUI
import SceneKit
import ARKit

struct ReconstructionResultView: View {
    
    let url: URL
    
    var body: some View {
        let scene = try? SCNScene(url: url)
        SceneView(scene: scene, options: [.autoenablesDefaultLighting,.allowsCameraControl])
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
    }
}
