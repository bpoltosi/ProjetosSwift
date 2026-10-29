//
//  AdicionarPrato.swift
//  Desafio Cardapio
//
//  Created by Turma01-2 on 29/10/26.
//

import SwiftUI

struct AdicionarPratoView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CardapioViewModel
    
    @State private var nome = ""
    @State private var preco = ""
    @State private var imagemUrl = ""
    @State private var categoria = "Entrada"
    
    let categorias = ["Entrada", "Principal", "Sobremesa", "Bebida"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalhes do Prato")) {
                    TextField("Nome", text: $nome)
                    TextField("Preço (ex: 35.0)", text: $preco)
                        .keyboardType(.decimalPad)
                    TextField("URL da Imagem", text: $imagemUrl)
                        .autocapitalization(.none)
                    
                    Picker("Categoria", selection: $categoria) {
                        ForEach(categorias, id: \.self) { cat in
                            Text(cat).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Novo Prato")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        if let precoDouble = Double(preco.replacingOccurrences(of: ",", with: ".")) {
                            viewModel.adicionarPrato(nome: nome, preco: precoDouble, imagemUrl: imagemUrl, categoria: categoria)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}
