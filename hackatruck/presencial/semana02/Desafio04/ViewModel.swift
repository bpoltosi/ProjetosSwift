//
//  ViewModel.swift
//  Desafio HarryPotter
//
//  Created by Turma01-2 on 22/10/26.
//

import Foundation
import Observation

@Observable
class ViewModel {
    var personagens: [HaPo] = []
    private let service = Service()
    
    func fetch() async {
        let url = "https://hp-api.onrender.com/api/characters"
        do {
            let todosPersonagens = try await service.fetchPersonagens(url: url)
            
            // Filtra apenas espécies "human" e que possuam uma string de imagem válida
            personagens = todosPersonagens.filter { personagem in
                let isHuman = personagem.species == "human"
                let hasImage = !(personagem.image?.isEmpty ?? true)
                return isHuman && hasImage
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
