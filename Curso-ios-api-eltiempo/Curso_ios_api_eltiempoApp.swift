//
//  Curso_ios_api_eltiempoApp.swift
//  Curso-ios-api-eltiempo
//
//  Created by Equipo 9 on 13/2/26.
//

import SwiftUI
import SwiftData

@main
struct Curso_ios_api_eltiempoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        // crea un contenedor del cual obtenemos un contexto
        // para el uso del SwiftData
        .modelContainer(for: [Persistencia.self, PersistenciaProvincias.self])
    }
}
