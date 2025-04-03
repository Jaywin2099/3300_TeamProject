import SwiftUI
import RealityKit
import ARKit

class WorldViewController: UIViewController {
    
    var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(arView)
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration)
        
        // Create a cube model
        let model = Entity()
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .blue, roughness: 0.15, isMetallic: true)
        model.components.set(ModelComponent(mesh: mesh, materials: [material]))
        model.position = [0, 0.05, 0]
        
        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.addChild(model)
        
        arView.scene.addAnchor(anchor)
    }
    
    func pauseSession() {
        arView.session.pause()
        print("AR Session Paused")
    }
    
    func resumeSession() {
        let configuration = ARWorldTrackingConfiguration()
        arView.session.run(configuration, options: [])
        print("AR Session Resumed")
    }
}

struct WorldViewContainer: UIViewControllerRepresentable {
    @Binding var isActive: Bool
    let controller = WorldViewController()
    
    func makeUIViewController(context: Context) -> WorldViewController {
        return controller
    }
    
    func updateUIViewController(_ uiViewController: WorldViewController, context: Context) {
        if isActive {
            uiViewController.resumeSession()
        } else {
            uiViewController.pauseSession()
        }
    }
}
