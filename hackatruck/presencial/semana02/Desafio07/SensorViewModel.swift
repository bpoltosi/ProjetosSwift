//
//  SensorViewModel.swift
//  Desafio Sensor
//

import Foundation
import Combine

struct DocumentoUmidade: Decodable {
    let id: String?
    let umidade: String? // Suporta a String "0.00" vinda do DB
    let timestamp: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case umidade
        case timestamp
    }
}

struct RegistroUmidade: Identifiable {
    let id = UUID()
    let tempo: Int
    let valor: Int
}

class SensorViewModel: ObservableObject {
    @Published var umidadePercentual: Int = 0
    @Published var valorBruto: Int = 1024
    @Published var historico: [RegistroUmidade] = []
    
    private var timer: Timer?
    
    // URL do endpoint GET do Node-RED
    private let dbURL = "http://192.168.128.181:1880/umidadeGET"
    
    func iniciarMonitoramento() {
        buscarDadosDB()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.buscarDadosDB()
        }
    }
    
    func pararMonitoramento() {
        timer?.invalidate()
        timer = nil
    }
    
    private func buscarDadosDB() {
        guard let url = URL(string: dbURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Erro de conexão: \(error?.localizedDescription ?? "")")
                return
            }
            
            do {
                let resultado = try JSONDecoder().decode([DocumentoUmidade].self, from: data)
                
                DispatchQueue.main.async {
                    var novoHistorico: [RegistroUmidade] = []
                    
                    // Converte todo o histórico do banco de dados para o gráfico
                    for (indice, doc) in resultado.enumerated() {
                        if let umidadeTexto = doc.umidade, let percentualDouble = Double(umidadeTexto) {
                            let valorInt = Int(percentualDouble)
                            let registro = RegistroUmidade(tempo: indice + 1, valor: valorInt)
                            novoHistorico.append(registro)
                        }
                    }
                    
                    // Mantém apenas os últimos 50 registos no gráfico para manter a performance
                    if novoHistorico.count > 50 {
                        novoHistorico = Array(novoHistorico.suffix(50))
                    }
                    
                    self?.historico = novoHistorico
                    
                    // Atualiza o indicador principal com o valor mais recente
                    if let ultimoValor = novoHistorico.last?.valor {
                        self?.umidadePercentual = ultimoValor
                    }
                }
            } catch {
                print("Erro ao decodificar JSON com Struct: \(error)")
            }
        }.resume()
    }
}
