//
//  ViewModel.swift
//  Desafio HarryPotter
//

import Foundation
import Observation

@Observable
class ViewModel {
    var personagens: [HaPo] = []
    var isLoading = false
    var errorMessage: String?

    private let service = Service()

    @MainActor
    func fetch() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let url = "https://hp-api.onrender.com/api/characters"

        do {
            let todosPersonagens = try await service.fetchPersonagens(url: url)
            personagens = todosPersonagens.filter { personagem in
                let isHuman = personagem.species?.lowercased() == "human"
                let hasImage = !(personagem.image?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
                return isHuman && hasImage
            }
        } catch {
            errorMessage = "Verifique sua conexão e tente novamente."
            print("Erro ao carregar personagens: \(error.localizedDescription)")
        }
    }
}
