//
//  StudyCastViewModel.swift
//  Projeto Visao Computacional
//
//  Created by Turma01-2 on 05/11/26.
//

import SwiftUI
import Vision
import AVFoundation
import Combine

@MainActor
class StudyCastViewModel: ObservableObject {
    @Published var imageToAnalise: UIImage?
    @Published var detectedText: String = ""
    
    let sintetizador = AVSpeechSynthesizer()
    
    func analisarTexto() async {
        guard let image = imageToAnalise else { return }
        guard let cgImage = image.cgImage else { return }
        
        let request = RecognizeTextRequest()
        
        do {
            let result = try await request.perform(on: cgImage)
            let text = result.compactMap { $0.transcript }.joined(separator: "\n")
            self.detectedText = text
        } catch {
            print("Erro ao analisar a imagem: \(error.localizedDescription)")
        }
    }
    
    func escutarTexto() {
        guard !detectedText.isEmpty else { return }
        
        let enunciado = AVSpeechUtterance(string: detectedText)
        enunciado.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        enunciado.rate = 0.3
        
        sintetizador.speak(enunciado)
    }
}
