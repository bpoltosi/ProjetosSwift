//
//  Model.swift
//  Jogos Tabuleiro
//
//  Created by Turma01-2 on 23/10/26.
//

import Foundation

struct JogoTabuleiro: Codable, Identifiable {
    var id: String?
    var nome: String
    var qtdJogadores: Int
    var tempoJogo: Int
    var descricao: String
}
