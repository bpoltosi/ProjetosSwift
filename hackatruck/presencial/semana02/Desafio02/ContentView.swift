import SwiftUI

struct ContentView: View {
    @State private var textoUsuario: String = ""
    @State private var corSelecionada: Color = .blue
    @State private var iconeSelecionado: String = "paintbrush" // Guarda o ícone da cor escolhida
    @State private var navegarParaProximaTela: Bool = false
    
    // Lista com as 4 cores para os quadrados
    let coresDisponiveis: [Color] = [.red, .blue, .gray, .purple]
    
    // Lista correspondente com os nomes dos ícones (SF Symbols)
    let iconesDisponiveis: [String] = ["paintbrush", "paintbrush.pointed", "paintpalette", "line.3.horizontal"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                // Input de Texto
                TextField("escreva seu texto aqui...", text: $textoUsuario)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 50)
                    .font(.body)
                
                // Instrução para as cores
                Text("Selecione uma cor de fundo:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // 4 Quadrados de Cores no Centro
                LazyVGrid(columns: [GridItem(.fixed(150)), GridItem(.fixed(150))], spacing: 20) {
                    ForEach(0..<coresDisponiveis.count, id: \.self) { index in
                        let cor = coresDisponiveis[index]
                        let icone = iconesDisponiveis[index]
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(cor)
                            .frame(width: 140, height: 140)
                            .overlay(
                                Image(systemName: icone)
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )
                            .shadow(radius: 4)
                            .onTapGesture {
                                corSelecionada = cor
                                iconeSelecionado = icone
                                navegarParaProximaTela = true
                            }
                    }
                }
                .padding()
                
                // NavigationLink invisível acionado pelo estado
                NavigationLink(
                    destination: TelaResultadoView(texto: textoUsuario, corFundo: corSelecionada, iconeFundo: iconeSelecionado),
                    isActive: $navegarParaProximaTela,
                    label: { EmptyView() }
                )
                
                Spacer()
            }
            .padding()
            .navigationTitle("Menu de Cores")
        }
    }
}

// MARK: - Tela de Destino
struct TelaResultadoView: View {
    let texto: String
    let corFundo: Color
    let iconeFundo: String
    
    var body: some View {
        ZStack {
            // Fundo com a cor selecionada preenchendo toda a tela
            corFundo
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Ícone selecionado dentro de um círculo preto (moldura)
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 150, height: 150)
                        .shadow(radius: 6)
                    
                    Image(systemName: iconeFundo)
                        .font(.system(size: 80))
                        .foregroundColor(corFundo)
                }
                
                // Texto digitado pelo usuário re-adicionado abaixo do ícone
                Text(texto)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
