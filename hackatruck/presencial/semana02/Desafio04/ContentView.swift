//
//  ContentView.swift
//  Desafio HarryPotter
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var casaSelecionada = "Todas"

    private let casas = ["Todas", "Gryffindor", "Slytherin", "Hufflepuff", "Ravenclaw"]

    private var personagensFiltrados: [HaPo] {
        guard casaSelecionada != "Todas" else { return viewModel.personagens }
        return viewModel.personagens.filter { $0.house == casaSelecionada }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("hogwards")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay(Color.black.opacity(0.58))
                    .accessibilityHidden(true)

                VStack(spacing: 12) {
                    filtroDeCasa

                    if viewModel.isLoading && viewModel.personagens.isEmpty {
                        estadoCarregando
                    } else if let mensagem = viewModel.errorMessage, viewModel.personagens.isEmpty {
                        estadoErro(mensagem)
                    } else if personagensFiltrados.isEmpty {
                        estadoVazio
                    } else {
                        List(personagensFiltrados) { personagem in
                            NavigationLink {
                                DetailView(personagem: personagem)
                            } label: {
                                linhaPersonagem(personagem)
                            }
                            .listRowBackground(Color.black.opacity(0.48))
                            .listRowSeparatorTint(.white.opacity(0.18))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
            }
            .navigationTitle("Mundo Bruxo")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .task {
                if viewModel.personagens.isEmpty {
                    await viewModel.fetch()
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var filtroDeCasa: some View {
        HStack(spacing: 10) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .font(.title3)
                .foregroundStyle(.yellow)

            Text("Casa")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white.opacity(0.9))

            Spacer()

            Picker("Filtrar por casa", selection: $casaSelecionada) {
                ForEach(casas, id: \.self) { casa in
                    Text(casa).tag(casa)
                }
            }
            .tint(.yellow)
            .labelsHidden()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.16), lineWidth: 1)
        }
    }

    private func linhaPersonagem(_ personagem: HaPo) -> some View {
        HStack(spacing: 14) {
            AsyncImage(url: URL(string: personagem.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    imagemReserva
                case .empty:
                    ProgressView()
                        .tint(.yellow)
                @unknown default:
                    imagemReserva
                }
            }
            .frame(width: 68, height: 88)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(personagem.name ?? "Personagem desconhecido")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Text(personagem.house?.isEmpty == false ? personagem.house! : "Casa não informada")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.72))
                    .lineLimit(1)

                if personagem.actor?.isEmpty == false {
                    Text(personagem.actor!)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                        .lineLimit(1)
                }
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.yellow.opacity(0.9))
        }
        .padding(.vertical, 7)
        .contentShape(Rectangle())
    }

    private var imagemReserva: some View {
        Image(systemName: "person.crop.square")
            .resizable()
            .scaledToFit()
            .padding(18)
            .foregroundStyle(.white.opacity(0.5))
    }

    private var estadoCarregando: some View {
        VStack(spacing: 14) {
            ProgressView()
                .tint(.yellow)
                .scaleEffect(1.2)
            Text("Buscando personagens...")
                .foregroundStyle(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func estadoErro(_ mensagem: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 38))
                .foregroundStyle(.yellow)
            Text("Não foi possível carregar")
                .font(.headline)
                .foregroundStyle(.white)
            Text(mensagem)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
            Button("Tentar novamente") {
                Task { await viewModel.fetch() }
            }
            .buttonStyle(.borderedProminent)
            .tint(.yellow)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private var estadoVazio: some View {
        ContentUnavailableView(
            "Nenhum personagem encontrado",
            systemImage: "person.crop.circle.badge.questionmark",
            description: Text("Tente selecionar outra casa.")
        )
        .foregroundStyle(.white)
    }
}

#Preview {
    ContentView()
}
