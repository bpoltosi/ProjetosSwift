//
//  SensorViewModel.swift
//  Desafio Sensor
//
//  Created by Turma01-2 on 27/10/26.
//

import Foundation
import Combine

struct RegistroUmidade: Identifiable {
    let id = UUID()
    let tempo: Int
    let valor: Int
}

class SensorViewModel: ObservableObject {
    @Published var umidadePercentual: Int = 0
    @Published var valorBruto: Int = 1024
    @Published var historico: [RegistroUmidade] = []
    
    private var contadorLeituras = 0
    private var webSocketTask: URLSessionWebSocketTask?
    
    func conectar() {
        // Substitua pelo IP impresso no Monitor Série
        let url = URL(string: "ws://192.168.128.179:81")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receber()
    }
    
    private func receber() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                if case .string(let texto) = message,
                   let data = texto.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    DispatchQueue.main.async {
                        // O NodeMCU envia a leitura bruta do A0 (0 a 1024)
                        let adcValor = json["umidade"] as? Double ?? 1024.0
                        self?.valorBruto = Int(adcValor)
                        
                        // Lógica de conversão: 1024 = 0% (Seco), 0 = 100% (Molhado)
                        var percentual = 100.0 * ((1024.0 - adcValor) / 1024.0)
                        
                        // Limita os valores entre 0% e 100%
                        percentual = max(0.0, min(100.0, percentual))
                        let valorFinal = Int(percentual)
                        
                        self?.umidadePercentual = valorFinal
                        
                        // Atualização do gráfico
                        let registro = RegistroUmidade(tempo: self?.contadorLeituras ?? 0, valor: valorFinal)
                        self?.historico.append(registro)
                        self?.contadorLeituras += 1
                        
                        if (self?.historico.count ?? 0) > 30 {
                            self?.historico.removeFirst()
                        }
                    }
                }
            case .failure(let erro):
                print("Erro no WebSocket: \(erro)")
            }
            
            self?.receber()
        }
    }
}
