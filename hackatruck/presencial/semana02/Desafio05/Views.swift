//
//  Views.swift
//  Jogos Tabuleiro
//
//  Created by Turma01-2 on 23/10/26.
//

import SwiftUI

// MARK: - Views (Lista Principal)
struct ListaJogosView: View {
    @StateObject var viewModel = JogosViewModel()
    @State private var mostrarNovoJogo = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CabecalhoView(titulo: "Jogos de Tabuleiro")
                
                List(viewModel.jogos) { jogo in
                    NavigationLink(destination: DetalheJogoView(jogo: jogo)) {
                        HStack {
                            Text(jogo.nome).font(.headline)
                            Spacer()
                            Text("\(jogo.tempoJogo) min").font(.subheadline)
                            Text("\(jogo.qtdJogadores) Jogadores").font(.subheadline)
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color.red.opacity(0.8))
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
                
                Button("Adicionar Novo Jogo") {
                    mostrarNovoJogo = true
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.red)
                .cornerRadius(20)
                .padding()
                .background(Color.black)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $mostrarNovoJogo) {
                NovoJogoView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchJogos()
            }
        }
    }
}

// MARK: - View (Detalhes do Jogo)
struct DetalheJogoView: View {
    var jogo: JogoTabuleiro
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            CabecalhoView(titulo: "Jogos de Tabuleiro")
            
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(jogo.nome).font(.title2)
                Spacer()
            }
            .foregroundColor(.red)
            .padding(.horizontal)
            
            HStack {
                Text("\(jogo.qtdJogadores) Jogadores")
                Text("\(jogo.tempoJogo) minutos")
            }
            .foregroundColor(.red)
            
            Text(jogo.descricao)
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
                .padding()
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

// MARK: - View (Criar Novo Jogo)
struct NovoJogoView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: JogosViewModel
    
    @State private var nome = ""
    @State private var qtdJogadores = ""
    @State private var tempoJogo = ""
    @State private var descricao = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Novo Jogo").font(.largeTitle).foregroundColor(.red).padding(.top)
            
            Form {
                HStack { Text("Nome:"); TextField("Ex: Jogo da Vida", text: $nome) }
                HStack { Text("Qtd Jogadores:"); TextField("Ex: 4", text: $qtdJogadores).keyboardType(.numberPad) }
                HStack { Text("Tempo:"); TextField("Ex: 30", text: $tempoJogo).keyboardType(.numberPad) }
                HStack { Text("Descrição:"); TextField("Ex: Sobre o jogo...", text: $descricao) }
            }
            
            Button("Criar Novo Jogo") {
                let novo = JogoTabuleiro(
                    nome: nome,
                    qtdJogadores: Int(qtdJogadores) ?? 0,
                    tempoJogo: Int(tempoJogo) ?? 0,
                    descricao: descricao
                )
                viewModel.adicionarJogo(jogo: novo)
                presentationMode.wrappedValue.dismiss()
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(20)
            .padding()
        }
    }
}

// MARK: - Componente Reutilizável
struct CabecalhoView: View {
    var titulo: String
    var body: some View {
        VStack(spacing: 0) {
            Image("boardgames_banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipped()
            
            Text(titulo)
                .font(.title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
        }
    }
}
