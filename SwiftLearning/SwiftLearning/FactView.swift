import SwiftUI

struct FactViewContainer : View {
    var body: some View {
        VStack {
            Text("VStack")
                .font(.largeTitle)
            
            HStack { // horizontal stack
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

#Preview {
    FactViewContainer()
}
