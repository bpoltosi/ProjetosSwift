//
//  AITipsViewModel.swift
//  Desafio 04
//
//  Created by Turma01-2 on 03/11/26.
//

import SwiftUI
import Combine // Resolve os erros de ObservableObject e @Published
import FirebaseAI
import FirebaseAILogic // Resolve o erro de escopo do googleAI()

@MainActor
class AITipsViewModel: ObservableObject {
    @Published var responseText: String = ""
    @Published var isLoading: Bool = false
    
    // Inicialização do modelo
    let model = FirebaseAI.firebaseAI(backend: .googleAI()).generativeModel(modelName: "gemini-3.8-flash")
    
    func fetchTips(for locationName: String) async {
        isLoading = true
        self.responseText = ""
        
        let prompt = "Atue como um guia de turismo. Crie um roteiro curto de 1 dia e dê 3 dicas práticas para visitar: \(locationName)."
        
        do {
            let response = try await model.generateContent(prompt)
            self.responseText = response.text ?? "Sem resposta..."
        } catch {
            self.responseText = "Erro: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
