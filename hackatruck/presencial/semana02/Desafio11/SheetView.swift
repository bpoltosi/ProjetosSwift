//
//  SheetView.swift
//  Desafio 04
//
//  Created by Turma01-2 on 21/10/26.
//

import SwiftUI

struct SheetView: View {
    @Binding var objeto: Location
    @StateObject private var aiViewModel = AITipsViewModel()
    
    var body: some View {
        ZStack {
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
                    
                    Text(objeto.descricao)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(12)
                    
                    // Botão da IA
                    Button(action: {
                        Task {
                            await aiViewModel.fetchTips(for: objeto.nome)
                        }
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Gerar Roteiro com IA")
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                    }
                    
                    // Resultados da IA
                    if aiViewModel.isLoading {
                        ProgressView("Consultando o Gemini...")
                            .padding()
                            .tint(.white)
                    } else if !aiViewModel.responseText.isEmpty {
                        Text(aiViewModel.responseText)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
        }
    }
}
