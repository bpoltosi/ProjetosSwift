//
//  SheetView.swift
//  Desafio 04
//
//  Created by Turma01-2 on 21/10/26.
//

import SwiftUI

struct SheetView: View {
    @Binding var objeto: Location // Partilha de estado obrigatória
    
    var body: some View {
        ZStack {
            // Aplica a cor de fundo systemBrown preenchendo toda a tela
            Color(UIColor.systemBrown)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    AsyncImage(url: URL(string: objeto.foto)) { image in
                        image.resizable().scaledToFit().cornerRadius(30)
                    } placeholder: {
                        ProgressView().tint(.white)
                    }
                    .shadow(radius: 5)
                    
                    Text(objeto.nome)
                        .font(.largeTitle)
                        .bold()
                    
                    // Caixa de descrição
                    Text(objeto.descricao)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(Color.black.opacity(0.2)) // Fundo semitransparente para destacar do brown
                        .cornerRadius(12)
                }
                .padding()
                .foregroundColor(.white) // Torna os textos brancos para contrastar com o castanho
            }
        }
    }
}
