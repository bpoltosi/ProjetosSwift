//
//  PratoRowView.swift
//  Desafio Cardapio
//
//  Created by Turma01-2 on 29/10/26.
//

import SwiftUI
import Translation

struct PratoRowView: View {
    let prato: Prato
    @State private var showTranslation = false
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: prato.imagemUrl)) { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(prato.nome)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("R$ \(String(format: "%.0f", prato.preco))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                showTranslation = true
            } label: {
                Image(systemName: "captions.bubble")
                    .foregroundColor(.black)
            }
            .buttonStyle(PlainButtonStyle())
            .translationPresentation(isPresented: $showTranslation, text: prato.nome) 
        }
        .padding(.vertical, 4)
    }
}
