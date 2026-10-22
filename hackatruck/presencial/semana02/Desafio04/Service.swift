//
//  Service.swift
//  Desafio HarryPotter
//
//  Created by Turma01-2 on 22/10/26.
//

import Foundation

struct Service {
    func fetchPersonagens(url: String) async throws -> [HaPo] {
        guard let url = URL(string: url) else { return [] }
        let (data, _) = try await URLSession.shared.data(from: url)
        let values = try JSONDecoder().decode([HaPo].self, from: data)
        return values
    }
}
