//
//  StudyCastView.swift
//  Projeto Visao Computacional
//
//  Created by Turma01-2 on 05/11/26.
//

import SwiftUI
import PhotosUI

struct StudyCastView: View {
    @StateObject private var viewModel = StudyCastViewModel()
    @State private var photoPicked: PhotosPickerItem?
    
    // Lista com os nomes exatos das imagens que você colocou no Assets
    let imagensDeExemplo = ["exemplo1", "exemplo2","exemplo3"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("StudyCast")
                .font(.headline)
                .padding(.top)
            
            if let image = viewModel.imageToAnalise {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
            } else {
                Spacer()
                Text("Nenhuma foto para analisar")
                    .foregroundColor(.gray)
                Spacer()
            }
            
            if viewModel.imageToAnalise != nil {
                Button(action: {
                    Task { await viewModel.analisarTexto() }
                }) {
                    Text("Analisar Texto")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.8))
                        .foregroundStyle(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                
                Button(action: { viewModel.escutarTexto() }) {
                    Text("Escutar Texto")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.8))
                        .foregroundStyle(.white)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                
                if !viewModel.detectedText.isEmpty {
                    ScrollView {
                        Text(viewModel.detectedText)
                            .font(.body)
                            .padding()
                            .multilineTextAlignment(.leading)
                    }
                } else {
                    Spacer()
                }
            }
            
            // --- NOVA SEÇÃO DE EXEMPLOS ---
            VStack(alignment: .leading) {
                Text("Exemplos rápidos:")
                    .font(.subheadline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(imagensDeExemplo, id: \.self) { nomeDaImagem in
                            Button(action: {
                                // Carrega a imagem direto do Assets
                                if let image = UIImage(named: nomeDaImagem) {
                                    viewModel.imageToAnalise = image
                                    viewModel.detectedText = ""
                                }
                            }) {
                                Image(nomeDaImagem)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 10)
            // ------------------------------
            
            PhotosPicker(selection: $photoPicked,
                         matching: .images,
                         photoLibrary: .shared()) {
                Text("Pegar da Galeria")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.indigo)
                    .foregroundStyle(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
            }
            .padding(.bottom)
            .onChange(of: photoPicked) { _, newValue in
                if let newPhoto = newValue {
                    Task {
                        if let data = try? await newPhoto.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            viewModel.imageToAnalise = image
                            viewModel.detectedText = ""
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
