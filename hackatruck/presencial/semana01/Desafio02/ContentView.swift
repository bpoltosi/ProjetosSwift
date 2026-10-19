import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            HStack(alignment: .center, spacing: 24) {
                Image ("hackatruck")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                            .shadow(radius: 3))
                
                //Textos empilhados
                VStack(alignment: .leading, spacing: 10) {
                    Text("HackaTruck")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.red)
                    Text("77 Universidades")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.blue)
                    Text("5 regiões do Brasil")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .foregroundColor(Color.yellow)
                }
                .padding()
            }
        }
    }
}
#Preview {
    ContentView()
}
