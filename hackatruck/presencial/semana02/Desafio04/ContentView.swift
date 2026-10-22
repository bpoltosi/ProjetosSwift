//
//  ContentView.swift
//  Desafio HarryPotter
//
//  Created by Turma01-2 on 22/10/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var casaSelecionada = "Todas"
    
    let casas = ["Todas", "Gryffindor", "Slytherin", "Hufflepuff", "Ravenclaw",]
    
    var personagensFiltrados: [HaPo] {
        if casaSelecionada == "Todas" {
            return viewModel.personagens
        }
        return viewModel.personagens.filter { $0.house == casaSelecionada }}
        
        var body: some View {
            NavigationStack {
                ZStack {
                    // Imagem de fundo do filme para a tela inteira
                    Image("hogwards") // Adicione esta imagem nos Assets
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .opacity(0.85)
                    
                    VStack(spacing: 0) {
                        Picker("Casa", selection: $casaSelecionada) {
                            ForEach(casas, id: \.self) { casa in
                                Text(casa).tag(casa)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        
                        List(personagensFiltrados) { personagem in
                            NavigationLink(destination: DetailView(personagem: personagem)) {
                                HStack(spacing: 15) {
                                    AsyncImage(url: URL(string: personagem.image ?? "")) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 70, height: 100)
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 70, height: 100)
                                    }
                                    
                                    Text(personagem.name ?? "Desconhecido")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .shadow(color: .black, radius: 2, x: 1, y: 1)
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(
                                Group {
                                    if let house = personagem.house, !house.isEmpty {
                                        Image(house.lowercased())
                                            .resizable()
                                            .scaledToFill()
                                    } else {
                                        Color.gray.opacity(0)
                                    }
                                })
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle("Personagens")
                .navigationBarTitleDisplayMode(.automatic)
                .task {
                    await viewModel.fetch()
                }
            }
        }
    }


#Preview {
    ContentView()
}
