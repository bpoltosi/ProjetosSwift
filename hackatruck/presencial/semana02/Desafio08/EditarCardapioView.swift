//
//  EditarCardapioView.swift
//  Desafio Cardapio
//
//  Created by Turma01-2 on 29/10/26.
//

import SwiftUI

struct EditarCardapioView: View {
    @ObservedObject var viewModel: CardapioViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.pratos) { prato in
                EditarPratoRowView(viewModel: viewModel, prato: prato)
            }
        }
        .navigationTitle("Editar Cardápio")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Subview componentizada para gerenciar o TextField individual de cada prato
struct EditarPratoRowView: View {
    @ObservedObject var viewModel: CardapioViewModel
    let prato: Prato
    
    @State private var precoEditado: String
    
    init(viewModel: CardapioViewModel, prato: Prato) {
        self.viewModel = viewModel
        self.prato = prato
        // Inicializa o TextField com o preço atual do banco
        _precoEditado = State(initialValue: String(format: "%.2f", prato.preco))
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(prato.nome)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text(prato.categoria)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("R$")
                .font(.footnote)
            
            TextField("Preço", text: $precoEditado)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 70)
            
            // Botão de Atualizar (PUT)
            Button {
                if let novoPreco = Double(precoEditado.replacingOccurrences(of: ",", with: ".")) {
                    viewModel.atualizarPreco(prato: prato, novoPreco: novoPreco)
                }
            } label: {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            // Botão de Deletar (DELETE)
            Button {
                viewModel.deletarPrato(prato: prato)
            } label: {
                Image(systemName: "trash.fill")
                    .foregroundColor(.red)
            }
            .buttonStyle(BorderlessButtonStyle())
        }
        .padding(.vertical, 4)
    }
}
