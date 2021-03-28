//
//  ContentView.swift
//  Reality Glasses
//
//  Created by Максим Иванов on 28.03.2021.
//

import ARKit
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        // Create ARView
        let arView = ARView(frame: .zero)
        
        // Check face tracking feature
        guard ARFaceTrackingConfiguration.isSupported  else {
            print(#line, #function, "Face tracking is not supported")
            return arView
        }
        
        // Create face tracking configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run face tracking session
        arView.session.run(configuration, options: [])
        
        // Create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        // Add box to the anchor
        faceAnchor.addChild(createSphere(y: 0.25))
        
        // Add face anchor to the scene
        arView.scene.anchors.append(faceAnchor)
        
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
    // MARK: - Methods
    
    func createBox() -> Entity {
        
        // Create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        
        // Create entity
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    func createSphere(x: Float = 0, y: Float = 0, z: Float = 0) -> Entity {
        
        // Create mesh (geometry)
        let mesh = MeshResource.generateSphere(radius: 0.075)
        
        // Create entity
        let entity = ModelEntity(mesh: mesh)
        entity.position = SIMD3(x, y, z)
        
        return entity
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
