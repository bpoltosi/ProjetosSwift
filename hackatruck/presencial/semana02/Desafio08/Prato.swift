//
//  Prato.swift
//  Desafio Cardapio
//
//  Created by Turma01-2 on 29/10/26.
//

import Foundation

struct Prato: Identifiable, Codable, Hashable {
    var id: String { _id ?? UUID().uuidString }
    let _id: String?
    let _rev: String?
    let nome: String
    let preco: Double
    let imagemUrl: String
    let categoria: String
}
