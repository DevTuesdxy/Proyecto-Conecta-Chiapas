//
//  VacanteDetalleCandidatoView.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 17/11/25.
//

import SwiftUI
import SwiftData

struct VacanteDetalleCandidatoView: View {
    @Environment(SessionManager.self) var session
    @Environment(\.modelContext) private var context
    
    let vacante: Vacante
    
    @State private var mensaje = ""
    @State private var yaPostulado = false
    @State private var mostrandoAlerta = false
    @State private var textoAlerta = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16){
                Text(vacante.puesto)
            }
        }
    }
}

//#Preview {
//    VacanteDetalleCandidatoView()
//}
