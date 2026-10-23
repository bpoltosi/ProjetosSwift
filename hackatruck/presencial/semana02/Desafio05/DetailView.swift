//
//  DetailView.swift
//  Jogos Tabuleiro
//
//  Created by Turma01-2 on 23/10/26.
//

import SwiftUI

struct DetalheJogoView: View {
    var jogo: JogoTabuleiro
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Image("boardgames_banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.red)
                }
                Spacer()
                Text(jogo.nome)
                    .font(.title2)
                    .foregroundColor(.red)
                Spacer()
            }
            .padding()
            
            HStack {
                Text("\(jogo.qtdJogadores) Jogadores")
                Text("\(jogo.tempoJogo) minutos")
            }
            .foregroundColor(.red)
            .padding(.top, 20)
            
            Text(jogo.descricao)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}
