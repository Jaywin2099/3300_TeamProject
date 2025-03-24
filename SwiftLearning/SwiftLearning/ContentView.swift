import SwiftUI
import RealityKit

struct ContentView : View {
    
    @State private var view = "AR"
    
    func onRightSwipe () -> Void {
        if (self.view == "AR") {
            self.view = "UI"
        }
    }
    
    func onLeftSwipe () -> Void {
        if (self.view == "UI") {
            self.view = "AR"
        }
    }
    
    var body: some View {
        ZStack {
            // behind everything is a cyan background
            Rectangle()
                .fill(Color.cyan)
            
            Text("ZStack")
            
            // Either AR or UI
            if self.view == "AR" {
                var camera: Bool = false
                
                RealityView { content in
                    
                    // Create a cube model
                    let model = Entity()
                    let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
                    let material = SimpleMaterial(color: .blue, roughness: 0.15, isMetallic: true)
                    model.components.set(ModelComponent(mesh: mesh, materials: [material]))
                    model.position = [0, 0.05, 0]
                    
                    // Create horizontal plane anchor for the content
                    let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
                    anchor.addChild(model)
                    
                    // Add the horizontal plane anchor to the scene
                    content.add(anchor)
                    
                    content.camera = .spatialTracking
                }
                
            } else if self.view == "UI" {
                VStack {
                    Text("VStack")
                        .font(.largeTitle)
                    HStack {
                        Text("HStack")
                            .contentShape(Rectangle())
                            .padding()
                        
                        Rectangle()
                            .frame(height: 200)
                            .foregroundColor(.red)
                    }
                }
                .background(Rectangle().fill(Color.mint))
                .frame(alignment: .top)
            }
        }
        
        .edgesIgnoringSafeArea(.all)
        
        // applies gesture to ZStack
        .gesture(DragGesture(minimumDistance: 10, coordinateSpace: .global).onEnded { value in
            let horizontalAmount = value.translation.width
            let verticalAmount = value.translation.height
            
            if abs(horizontalAmount) > abs(verticalAmount) {
                
                if (horizontalAmount < 0) {
                    onLeftSwipe()
                } else {
                    onRightSwipe()
                }
            } else {
                if (verticalAmount < 0) {
                    print("up swipe")
                } else {
                    print("down swipe")
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
