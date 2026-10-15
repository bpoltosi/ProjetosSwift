import SwiftUI

struct ContentView: View {
    
    // Tamanho fixo para os quadrados
    let tamanho: CGFloat = 100
    
    var body: some View {
        VStack {
            // Linha Superior
            HStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: tamanho, height: tamanho)
                
                Spacer() // Empurra o próximo quadrado para a direita
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: tamanho, height: tamanho)
            }
            
            Spacer() // Empurra tudo o que está abaixo para o fundo da tela
            
            // Linha Inferior
            HStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: tamanho, height: tamanho)
                
                Spacer() // Empurra o próximo quadrado para a direita
                
                Rectangle()
                    .fill(Color.orange)
                    .frame(width: tamanho, height: tamanho)
            }
        }
        .padding() // Garante que eles não fiquem colados na borda física ou entalhe (Notch) do aparelho
    }
}

#Preview {
    ContentView()
}
