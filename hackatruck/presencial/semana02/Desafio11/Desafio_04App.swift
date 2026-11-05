//
//  Desafio_04App.swift
//  Desafio 04
//
//  Created by Turma01-2 on 21/10/26.
//

import SwiftUI
import Firebase // O material usa import Firebase em vez de FirebaseCore[cite: 21]

@main
struct Desafio_04App: App {
    
    init() {
        // Configuração do provedor de depuração do AppCheck conforme o PDF[cite: 21]
        let provider = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(provider)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
