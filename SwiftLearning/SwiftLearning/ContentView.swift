import SwiftUI
import RealityKit

struct ContentView : View {
    
    @State private var view = "AR"
    @State private var offsetX: CGFloat = 0
    @State private var arActive: Bool = true // binded to pause/unpause in WorldViewContainer
    
    func onRightSwipe () -> Void {
        if (self.view == "AR") {
            self.view = "UI"
            self.offsetX = UIScreen.main.bounds.width
            self.arActive.toggle()
            
            withAnimation(.easeInOut(duration: 0.5)) {
                
                self.offsetX = 0
            }
        }
    }
    
    func onLeftSwipe () -> Void {
        if (self.view == "UI") {
            self.view = "AR"
            self.arActive.toggle() // unpauses ar view
            self.offsetX = UIScreen.main.bounds.width
            
            withAnimation(.easeInOut(duration: 0.5)) {
                self.offsetX = 0
            }
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.cyan)
                .edgesIgnoringSafeArea(.all)
            
            Text("ZStack")
                .position(x: UIScreen.main.bounds.width / 2, y: 50)
            
            FactViewContainer()
                .offset(x: view == "UI" ? -offsetX : offsetX - UIScreen.main.bounds.width)
            
            WorldViewContainer(isActive: $arActive)
                .offset(x: view == "AR" ? offsetX : -offsetX + UIScreen.main.bounds.width)
                                
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
