//
//  GastroBarView.swift
//  Desafio Cardapio
//
//  Created by Turma01-2 on 29/10/26.
//

import SwiftUI

struct GastroBarView: View {
    @StateObject private var viewModel = CardapioViewModel()
    @State private var mostrandoCadastro = false
    
    let categorias = ["Entrada", "Principal", "Sobremesa", "Bebida"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categorias, id: \.self) { categoria in
                    let pratosDaCategoria = viewModel.pratos.filter { $0.categoria == categoria }
                    
                    if !pratosDaCategoria.isEmpty {
                        Section(header: Text(categoria).fontWeight(.bold).foregroundColor(.black)) {
                            ForEach(pratosDaCategoria) { prato in
                                PratoRowView(prato: prato)
                                    .listRowBackground(Color(red: 0.6, green: 0.8, blue: 1.0))
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 1.0, green: 0.95, blue: 0.6))
            .navigationTitle("HackaTruck GastroBar v2")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: EditarCardapioView(viewModel: viewModel)) {
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {mostrandoCadastro = true}
                        label: {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                    }
                }
            }
            .sheet(isPresented: $mostrandoCadastro) {
                AdicionarPratoView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.fetchPratos()
            }
        }
    }
}
