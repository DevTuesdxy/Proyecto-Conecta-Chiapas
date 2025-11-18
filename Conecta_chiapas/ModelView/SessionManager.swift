//
//  SessionManager.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 17/11/25.
//

import Foundation
import SwiftData

@Observable
class SessionManager{
    var usuarioActual: Usuario?
    
    func cargarUsuario(context: ModelContext) {
        let id = UserDefaults.standard.integer(forKey: "usuario_activo_id")
        guard id != 0 else { return }

        let descriptor = FetchDescriptor<Usuario>(
            predicate: #Predicate { $0.idUsuario == id }
        )

        if let resultado = try? context.fetch(descriptor),
            let usuario = resultado.first {
            self.usuarioActual = usuario
        }
    }
    
    func guardarSesion(_ usuario: Usuario){
        UserDefaults.standard.set(usuario.idUsuario, forKey: "usuario_activo_id")
        self.usuarioActual = usuario
    }
    
    func cerrarSesion(){
        UserDefaults.standard.removeObject(forKey: "usuario_activo_id")
        self.usuarioActual = nil
    }
    
}
