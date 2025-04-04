import SwiftUI
import RealityKit
import ARKit
import Vision

class WorldViewController: UIViewController, ARSessionDelegate {
    
    var arView: ARView!
    var visionQueue = DispatchQueue(label: "com.example.visionQueue")
    var request: VNClassifyImageRequest!
    
    var lastClassificationDate = Date(timeIntervalSince1970: 0) // placeholder for how the image recognition is triggered
    let classificationInterval: TimeInterval = 3 // sends frame every X seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARView(frame: view.bounds)
        arView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(arView)
        
        let configuration = ARWorldTrackingConfiguration()
        arView.session.delegate = self
        arView.session.run(configuration)
        
        setupVision()
        
        // remove later
        arView.debugOptions = [.showAnchorOrigins, .showAnchorGeometry]
        
        let anchor = createAnchor()
        arView.scene.addAnchor(anchor)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let now = Date()
        if now.timeIntervalSince(lastClassificationDate) > classificationInterval {
            lastClassificationDate = now
            classifyCurrentFrame(pixelBuffer: frame.capturedImage)
        }
    }
        
    
    func classifyCurrentFrame(pixelBuffer: CVPixelBuffer) {
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:])
        visionQueue.async {
            do {
                try handler.perform([self.request])
            } catch {
                print("Vision error: \(error)")
            }
        }
    }
    
    func setupVision() {
        request = VNClassifyImageRequest { request, error in
            guard let results = request.results as? [VNClassificationObservation] else { return }
            
            // confidence above 40% is recognized
            if let topResult = results.first, topResult.confidence > 0.4 {
                DispatchQueue.main.async {
                    self.handleClassification(result: topResult)
                }
            }
        }
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
