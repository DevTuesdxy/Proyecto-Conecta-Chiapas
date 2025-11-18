//
//  Conecta_chiapasApp.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 20/10/25.
//

import SwiftUI
import SwiftData

@main
struct Conecta_chiapasApp: App {
    @State private var session = SessionManager()
    
    private var sharedContainer: ModelContainer = {
        do{
            return try ModelContainer.makeMercadoLaboralContainer(inMemory: false)
        } catch {
            fatalError("Error al crear el modelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedContainer)
                .environment(session)
        }
    }
}
