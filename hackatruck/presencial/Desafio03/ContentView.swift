import SwiftUI

struct ContentView: View {
    @State private var nome: String = ""
    @State private var exibirAlerta: Bool = false

    var body: some View {
        ZStack {
            Image("Fundo")
                .resizable()
                .scaledToFill()
                .blur(radius: 6)
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 10) {
                    Text("Bem-vindo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    TextField("Digite o seu nome aqui",text: $nome)
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
                .padding(.top, 30)

                Spacer()

                Image("Frente")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 220)

                Spacer()

                Button("Entrar") {
                    exibirAlerta = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .controlSize(.large)
                .padding(.bottom, 40)
            }
        }
        .alert(
            "Voce ira iniciar o desafio da aula agora!",
            isPresented: $exibirAlerta
        ) {
            Button("Vamos lá", role: .cancel) { }
        }
    }
}

#Preview {
    ContentView()
}
