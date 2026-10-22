//
//  DetailView.swift
//  Desafio HarryPotter
//
//  Created by Turma01-2 on 22/10/26.
//

import SwiftUI

struct DetailView: View {
    let personagem: HaPo
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: personagem.image ?? "")) { image in
                    image.resizable()
                         .scaledToFill()
                         .frame(width: 200, height: 280)
                         .cornerRadius(15)
                         .shadow(radius: 10)
                } placeholder: {
                    ProgressView()
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Casa", value: personagem.house)
                    DetailRow(label: "Nascimento", value: personagem.dateOfBirth)
                    DetailRow(label: "Ancestralidade", value: personagem.ancestry)
                    DetailRow(label: "Patrono", value: personagem.patronus)
                    DetailRow(label: "Ator", value: personagem.actor)
                    
                    if personagem.hogwartsStudent == true {
                        DetailRow(label: "Ocupação", value: "Aluno de Hogwarts")
                    } else if personagem.hogwartsStaff == true {
                        DetailRow(label: "Ocupação", value: "Funcionário de Hogwarts")
                    }
                    
                    if let wood = personagem.wand.wood, !wood.isEmpty {
                        let core = personagem.wand.core ?? "Desconhecido"
                        let length = personagem.wand.length != nil ? "\(personagem.wand.length!) polegadas" : "Tamanho desconhecido"
                        DetailRow(label: "Varinha", value: "\(wood), \(core), \(length)")
                    }
                }
                .padding()
                // Efeito de Vidro na aba de detalhes
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                .padding(.horizontal)
            }
        }
        .background(
            Group {
                if let house = personagem.house, !house.isEmpty {
                    Image(house.lowercased())
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                        .opacity(0.5)
                } else {
                    Color.black.opacity(0.8).ignoresSafeArea()
                }
            }
        )
        .navigationTitle(personagem.name ?? "Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Subview auxiliar para manter o código visual organizado
struct DetailRow: View {
    let label: String
    let value: String?
    
    var body: some View {
        if let value = value, !value.isEmpty {
            HStack(alignment: .top) {
                Text("\(label):")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(value.capitalized)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}
