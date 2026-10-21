//
//  Location.swift
//  Desafio 04
//
//  Created by Turma01-2 on 21/10/26.
//

import Foundation
import MapKit

struct Location: Hashable, Identifiable {
    let id = UUID()
    let nome, foto, descricao: String
    let emoji: String // Nova propriedade adicionada
    let latitude, longitude: Double
}

let maravilhas = [
    Location(nome: "Cristo Redentor - Brasil",
             foto: "https://upload.wikimedia.org/wikipedia/commons/9/98/Cidade_Maravilhosa.jpg",
             descricao: "Localizado no topo do morro do Corcovado, a 709 metros acima do nível do mar, no Parque Nacional da Tijuca, Rio de Janeiro. Inaugurado em 1931, o monumento no estilo Art Déco possui 30 metros de altura sobre um pedestal de 8 metros, com envergadura de braços de 28 metros. Construído em concreto armado e revestido por milhares de triângulos de pedra-sabão.",
             emoji: "🗿",
             latitude: -22.951916,
             longitude: -43.210487),
    
    Location(nome: "Machu Picchu - Peru",
             foto: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Machu_Picchu%2C_Peru.jpg",
             descricao: "Cidadela inca do século XV situada a 2.430 metros de altitude na cordilheira dos Andes, sobre o vale do rio Urubamba. Erguida com blocos de pedra polida encaixados sem o uso de argamassa (técnica ashlar), a cidade é dividida em zona agrícola (terraços) e zona urbana (templos, praças e residências). Acredita-se que funcionou como santuário religioso e residência do imperador Pachacuti.",
             emoji: "🦙",
             latitude: -13.163141,
             longitude: -72.544963),
    
    Location(nome: "Chichén Itzá - México",
             foto: "https://upload.wikimedia.org/wikipedia/commons/5/51/Chichen_Itza_3.jpg",
             descricao: "Centro urbano e cerimonial da civilização maia localizado na península de Iucatã. O destaque do sítio é o templo de Kukulcán (El Castillo), uma pirâmide de 30 metros de altura projetada com precisão astronômica: somando os degraus dos quatro lados mais a plataforma topo, obtêm-se 365 degraus (dias do ano). Durante os equinócios de primavera e outono, a luz do sol cria a ilusão de uma serpente de sombras descendo pela escadaria.",
             emoji: "🛕",
             latitude: 20.684285,
             longitude: -88.567783),
    
    Location(nome: "Coliseu - Itália",
             foto: "https://upload.wikimedia.org/wikipedia/commons/d/d8/Colosseum_in_Rome-April_2007-1-_copie_2B.jpg",
             descricao: "O Anfiteatro Flaviano, construído no século I d.C. no centro de Roma, é o maior anfiteatro do mundo antigo. Com capacidade para abrigar entre 50.000 e 80.000 espectadores, sua estrutura de arcos de travertino e concreto era utilizada para combates de gladiadores, caças de animais e simulações de batalhas navais. Possuía o hipogeu, um complexo sistema subterrâneo de túneis e elevadores operados por polias.",
             emoji: "🏟️",
             latitude: 41.890210,
             longitude: 12.492231),
    
    Location(nome: "Petra - Jordânia",
             foto: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Treasury_petra_crop.jpeg",
             descricao: "Cidade histórica esculpida nas rochas de arenito rosado no deserto jordano, fundada pelos nabateus por volta do século IV a.C. Prosperou devido ao seu domínio sobre as rotas comerciais de especiarias e ao seu avançado sistema de engenharia hidráulica para captação e armazenamento de água. Seu monumento mais famoso é Al-Khazneh (O Tesouro), cuja fachada de 40 metros foi entalhada diretamente na rocha.",
             emoji: "🏛️",
             latitude: 30.328454,
             longitude: 35.444362),
    
    Location(nome: "Taj Mahal - Índia",
             foto: "https://upload.wikimedia.org/wikipedia/commons/c/c8/Taj_Mahal_in_March_2004.jpg",
             descricao: "Mausoléu de mármore branco situado na cidade de Agra, às margens do rio Yamuna. Foi construído entre 1631 e 1648 pelo imperador mogol Shah Jahan em memória de sua esposa Mumtaz Mahal. O monumento destaca-se pela simetria rigorosa, cúpula central de 35 metros de altura, incrustações minuciosas de pedras semipreciosas (pietra dura) e jardins com espelhos d'água.",
             emoji: "🕌",
             latitude: 27.175145,
             longitude: 78.042142),
    
    Location(nome: "Grande Muralha da China - China",
             foto: "https://upload.wikimedia.org/wikipedia/commons/2/23/The_Great_Wall_of_China_at_Jinshanling-edit.jpg",
             descricao: "Vasta rede de fortificações de pedra, tijolo e terra batida que se estende por mais de 21.000 quilômetros no norte da China. Construída e reconstruída ao longo de várias dinastias — com a maior parte preservada pertencendo à dinastia Ming (1368–1644) —, tinha a função de proteger o império contra incursões de povos nômades das estepes, além de controlar o comércio ao longo da Rota da Seda.",
             emoji: "🧱",
             latitude: 40.431908,
             longitude: 116.570374)
]
