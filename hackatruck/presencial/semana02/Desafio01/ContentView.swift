//
//  ContentView.swift
//  Desafio 01
//
//  Created by Turma02-2 on 19/10/26.
//

import SwiftUI

struct ContentView: View {
    // Estrutura de dados para a lista contendo texto e emoji
    struct ItemLista: Identifiable {
        let id = UUID()
        let titulo: String
        let icone: String
    }

    let itensDaLista = [
        ItemLista(titulo: "Pincel - Rosa", icone: "paintbrush"),
        ItemLista(titulo: "Caneta - Azul", icone: "paintbrush.pointed"),
        ItemLista(titulo: "Palheta de Cores - Cinza", icone: "paintpalette"),
        ItemLista(titulo: "Lista", icone: paintpalette")
    ]

    var body: some View {
        TabView {
            // PÁGINA 1: PINCEL (Rosa)
            ZStack {
                Color.pink.opacity(0.75)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 300, height: 300)
                        
                        Image(systemName: "paintbrush")
                            .font(.system(size: 150))
                            .foregroundColor(.pink)
                    }
                    Spacer()
                }
            }
            .tabItem {
                Label("Rosa", systemImage: "paintbrush")
            }
            
            // PÁGINA 2: CANETA (Azul)
            ZStack {
                Color.blue.opacity(0.75)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 300, height: 300)
                        
                        Image(systemName: "paintbrush.pointed")
                            .font(.system(size: 150))
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
            }
            .tabItem {
                Label("Azul", systemImage: "paintbrush.pointed")
            }
            
            // PÁGINA 3: PALHETA DE CORES (Cinza)
            ZStack {
                Color.gray.opacity(0.75)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 300, height: 300)
                        
                        Image(systemName: "paintpalette")
                            .font(.system(size: 150))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            .tabItem {
                Label("Cinza", systemImage: "paintpalette")
            }
            
            // PÁGINA 4: LISTA
                        NavigationView {
                            List(itensDaLista) { item in
                                HStack(spacing: 16) {
                                    // 1º Texto fica à esquerda
                                    Text(item.titulo)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        Circle()
                                            .fill(Color.black)
                                            .frame(width: 40, height: 40)
                                        
                                        Image(systemName: item.icone)
                                            .font(.system(size: 18))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .navigationTitle("Lista de Itens")
                        }
                        .tabItem {
                            Label("Lista", systemImage: "line.3.horizontal")
                        }
                    }
                }
            }

            #Preview {
                ContentView()
            }
