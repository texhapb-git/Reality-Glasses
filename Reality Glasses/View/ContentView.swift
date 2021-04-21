//
//  ContentView.swift
//  Reality Glasses
//
//  Created by Максим Иванов on 28.03.2021.
//

import ARKit
import SwiftUI
import RealityKit

enum KindOfMasks: String, CaseIterable {
    case none = "None"
    case simple = "Simple"
    case complex = "Complex"
}

struct ContentView : View {
    
    @State private var selection: KindOfMasks = .none
    
    var body: some View {
        
        VStack {
            Section() {
                ARViewContainer(selection: selection).edgesIgnoringSafeArea(.all)
            }

            Section(header: Text("Choose mask")) {
                
                Picker("", selection: $selection) {
                    ForEach(KindOfMasks.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
            }
        }
    }
       
}



struct ARViewContainer: UIViewRepresentable {
    
    var selection: KindOfMasks
    
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
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        // Remove all existing anchors
        uiView.scene.anchors.removeAll()
        
        // Create face anchor
        let faceAnchor = AnchorEntity(.face)
        
        
        // Add mask to the anchor
        switch selection {
        case .none:
            break
        case .simple:
            faceAnchor.addChild(createCircle(x: 0.035, y: 0.025, z: 0.06, opacity: true))
            faceAnchor.addChild(createCircle(x: -0.035, y: 0.025, z: 0.06, opacity: true))
        case .complex:
            faceAnchor.addChild(createCircle(x: 0.035, y: 0.025, z: 0.06))
            faceAnchor.addChild(createCircle(x: -0.035, y: 0.025, z: 0.06))
            faceAnchor.addChild(createSphere(z: 0.06, radius: 0.025))
        }
        
        // Add face anchor to the scene
        uiView.scene.anchors.append(faceAnchor)
        
    }
    
    
    // MARK: - Methods
    
    private func createBox() -> Entity {
        
        // Create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.2)
        
        // Create entity
        let entity = ModelEntity(mesh: mesh)
        
        return entity
    }
    
    private func createCircle(x: Float = 0, y: Float = 0, z: Float, opacity: Bool = false) -> Entity {
        
        // Create mesh (geometry)
        let mesh = MeshResource.generateBox(size: 0.05, cornerRadius: 0.025)
        
        // Create material
        var material = SimpleMaterial(color: .green, isMetallic: true)
        
        if opacity {
            material.baseColor = MaterialColorParameter.color(.init(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.4))
        }
        

        
        // Create entity
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        entity.position = SIMD3(x, y, z)
        
        entity.scale.x = 1.1
        entity.scale.z = 0.01
        
        return entity
    }
    
    private func createSphere(x: Float = 0, y: Float = 0, z: Float = 0, color: UIColor = .red, radius: Float = 1) -> Entity {
        
        // Create mesh (geometry)
        let mesh = MeshResource.generateSphere(radius: radius)
        
        let material = SimpleMaterial(color: color, isMetallic: true)
        
        // Create entity
        let entity = ModelEntity(mesh: mesh, materials: [material])
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
