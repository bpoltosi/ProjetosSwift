//
//  ViewModel.swift
//  Jogos Tabuleiro
//
//  Created by Turma01-2 on 23/10/26.
//

import Foundation
import Combine

// MARK: - ViewModel
class JogosViewModel: ObservableObject {
    @Published var jogos: [JogoTabuleiro] = []
    
    // Substitua pelo IP da sua máquina onde o Node-RED está sendo executado
    private let baseURL = "http://localhost:1880"
    
    func fetchJogos() {
        guard let url = URL(string: "\(baseURL)/jogos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedJogos = try JSONDecoder().decode([JogoTabuleiro].self, from: data)
                    DispatchQueue.main.async {
                        self.jogos = decodedJogos
                    }
                } catch {
                    print("Erro ao decodificar: \(error)")
                }
            }
        }.resume()
    }
    
    func adicionarJogo(jogo: JogoTabuleiro) {
        guard let url = URL(string: "\(baseURL)/postJogos") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            // O Node-RED aguarda um array de objetos para o nó split[cite: 14]
            let jsonData = try JSONEncoder().encode([jogo])
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { _, _, error in
                if let error = error {
                    print("Erro no POST: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.fetchJogos()
                }
            }.resume()
        } catch {
            print("Erro de codificação: \(error)")
        }
    }
}
