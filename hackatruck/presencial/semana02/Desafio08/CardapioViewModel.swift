//
//  CardapioViewModel.swift
//  Desafio Cardapio
//
//  Created by Turma01-2 on 29/10/26.
//

import Foundation
import Combine

class CardapioViewModel: ObservableObject {
    @Published var pratos: [Prato] = []
    
    private let baseURL = "http://127.0.0.1:1880"
    
    func fetchPratos() {
        guard let url = URL(string: "\(baseURL)/cardapioGET") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    do {
                        self.pratos = try JSONDecoder().decode([Prato].self, from: data)
                    } catch {
                        print("Erro ao decodificar: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    func adicionarPrato(nome: String, preco: Double, imagemUrl: String, categoria: String) {
        guard let url = URL(string: "\(baseURL)/cardapioPOST") else { return }
        
        let novoPrato = [
            "nome": nome,
            "preco": preco,
            "imagemUrl": imagemUrl,
            "categoria": categoria
        ] as [String : Any]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: novoPrato)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                self.fetchPratos() // Atualiza a lista após inserir
            }
        }.resume()
    }
    
    func atualizarPreco(prato: Prato, novoPreco: Double) {
        guard let id = prato._id, let rev = prato._rev else { return } // Cloudant exige _id e _rev
        guard let url = URL(string: "\(baseURL)/cardapioPUT") else { return }
            
        let pratoAtualizado: [String: Any] = [
                "_id": id,
                "_rev": rev,
                "nome": prato.nome,
                "preco": novoPreco,
                "imagemUrl": prato.imagemUrl,
                "categoria": prato.categoria
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: pratoAtualizado)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    self.fetchPratos() // Recarrega a lista para mostrar o novo preço
                }
            }.resume()
        }
        
        func deletarPrato(prato: Prato) {
            guard let id = prato._id, let rev = prato._rev else { return }
            guard let url = URL(string: "\(baseURL)/cardapioDELETE") else { return }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let deletePayload: [String: Any] = [
                "_id": id,
                "_rev": rev
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: deletePayload)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil {
                    self.fetchPratos() // Recarrega a lista após remover
                }
            }.resume()
        }
}
