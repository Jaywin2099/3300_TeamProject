import SwiftUI
import RealityKit
import ARKit
import Vision

class WorldViewController: UIViewController, ARSessionDelegate {
    
    var arView: ARView!
    var arSession: ARSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        arSession = arView.session
        
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(arView)
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.delegate = self
        arView.session.run(configuration)
        
        // remove later
        arView.debugOptions = [.showAnchorOrigins, .showAnchorGeometry]
        
        let anchor = createAnchor()
        arView.scene.addAnchor(anchor)
        
        // adds tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
    }
      
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print(env.GEMINI_API_KEY)
        
        // Capture the current frame as an image
        if let currentFrame = arSession.currentFrame {
            let capturedImage = currentFrame.capturedImage
            let ciImage = CIImage(cvPixelBuffer: capturedImage)

            guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else { return }
            guard let uiImage = UIImage(cgImage: cgImage).jpegData(compressionQuality: 0.8) else { return }
            
            print("aquired image for classification")

            // Call the asynchronous classification functions
            Task {
                do {
                    if let classificationResult = try await classifyImage(imageData: uiImage) {
                        print("Image classification result on tap: \(classificationResult)")
                        // Update your AR scene based on the classification
                    }
                } catch {
                    print("Error classifying image on tap: \(error)")
                }
            }
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // idk if we need this anymore
    }
    
    func handleClassification(result: VNClassificationObservation) {
        print("Found: " + result.identifier, result.confidence)
    }
    
    func createAnchor () -> AnchorEntity {
        // Create a cube model
        let model = Entity()
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.009)
        let material = SimpleMaterial(color: .blue, roughness: 0.15, isMetallic: true)
        model.components.set(ModelComponent(mesh: mesh, materials: [material]))
        model.position = [-0.5, -0.5, 0]
        
        // Create horizontal plane anchor for the content
        //let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, 0))
        anchor.addChild(model)
        
        return anchor
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
    
    // image recognition and tap used to get what the user is looking at
    // then combine that data with position data for use later
    // send that packet to another function that will use the features
    // and return a trext description
    // another function calls that function and uses the description, position, and screenshot to create
    //  - a Fact© in the facts page
    //  - a Sign© in the AR view with the text description
    //  - a window in the AR view that shows related facts

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
