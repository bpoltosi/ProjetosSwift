//
//  DetailView.swift
//  Desafio HarryPotter
//

import SwiftUI

struct DetailView: View {
    let personagem: HaPo

    private var corDaCasa: Color {
        switch personagem.house?.lowercased() {
        case "gryffindor": return Color(red: 0.55, green: 0.08, blue: 0.10)
        case "slytherin": return Color(red: 0.06, green: 0.30, blue: 0.20)
        case "hufflepuff": return Color(red: 0.62, green: 0.43, blue: 0.05)
        case "ravenclaw": return Color(red: 0.08, green: 0.22, blue: 0.45)
        default: return Color(red: 0.16, green: 0.17, blue: 0.21)
        }
    }

    var body: some View {
        ZStack {
            Image("hogwards")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.66))
                .accessibilityHidden(true)

            ScrollView {
                VStack(spacing: 20) {
                    cabecalhoPersonagem
                    informacoesPersonagem
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
                .padding(.bottom, 28)
            }
            .scrollIndicators(.hidden)
        }
        .navigationTitle(personagem.name ?? "Detalhes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private var cabecalhoPersonagem: some View {
        VStack(spacing: 14) {
            AsyncImage(url: URL(string: personagem.image ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .empty:
                    ProgressView()
                        .tint(.yellow)
                case .failure:
                    Image(systemName: "person.crop.square")
                        .resizable()
                        .scaledToFit()
                        .padding(42)
                        .foregroundStyle(.white.opacity(0.55))
                @unknown default:
                    Image(systemName: "person.crop.square")
                        .resizable()
                        .scaledToFit()
                        .padding(42)
                        .foregroundStyle(.white.opacity(0.55))
                }
            }
            .frame(width: 190, height: 245)
            .background(Color.white.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 22))
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.white.opacity(0.28), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.35), radius: 18, x: 0, y: 10)

            VStack(spacing: 6) {
                Text(personagem.name ?? "Personagem desconhecido")
                    .font(.title2.weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text(personagem.house?.isEmpty == false ? personagem.house! : "Casa não informada")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(corDaCasa, in: Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        }
    }

    private var informacoesPersonagem: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Informações")
                .font(.headline)
                .foregroundStyle(.yellow)
                .padding(.bottom, 8)

            DetailRow(label: "Nascimento", value: personagem.dateOfBirth)
            DetailRow(label: "Ancestralidade", value: personagem.ancestry)
            DetailRow(label: "Patrono", value: personagem.patronus)
            DetailRow(label: "Ator", value: personagem.actor)
            DetailRow(label: "Espécie", value: personagem.species)
            DetailRow(label: "Gênero", value: personagem.gender)
            DetailRow(label: "Olhos", value: personagem.eyeColour)
            DetailRow(label: "Cabelo", value: personagem.hairColour)

            if personagem.hogwartsStudent == true {
                DetailRow(label: "Ocupação", value: "Aluno de Hogwarts")
            } else if personagem.hogwartsStaff == true {
                DetailRow(label: "Ocupação", value: "Funcionário de Hogwarts")
            }

            if let wood = personagem.wand.wood, !wood.isEmpty {
                let core = personagem.wand.core?.isEmpty == false ? personagem.wand.core! : "Não informado"
                let length = personagem.wand.length.map { String(format: "%.1f polegadas", $0) } ?? "Tamanho não informado"
                DetailRow(label: "Varinha", value: "\(wood), \(core), \(length)")
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.14), lineWidth: 1)
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String?

    var body: some View {
        if let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            HStack(alignment: .top, spacing: 8) {
                Text(label)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: 112, alignment: .leading)

                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            }
            .padding(.vertical, 9)

            Divider()
                .overlay(.white.opacity(0.12))
        }
    }
}
