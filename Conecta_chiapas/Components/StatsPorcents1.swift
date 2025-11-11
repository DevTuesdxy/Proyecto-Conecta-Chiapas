//
//  StatsPorcents1.swift
//  Conecta_chiapas
//

import SwiftUI

struct StatsPorcents1: View {
    
    let TituloContenedor: String
    let Porcentaje: String
    
    var body: some View {
        
        HStack {
            Text(TituloContenedor)
                .font(.headline)             // ↓ antes: .title2
                .foregroundStyle(.colorGray700)
            
            Spacer()
            
            Text(Porcentaje)
                .font(.headline)             // ↓ antes: .title2
                .foregroundStyle(.colorVerde)
        }
        .padding(10)                          // un pelín menos padding también ayuda a compactar
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.colorGray600, lineWidth: 0.6) // borde más fino
        )

    }
}

#Preview {
    VStack(spacing: 12) {
        StatsPorcents1(TituloContenedor: "Turismo", Porcentaje: "15%")
        StatsPorcents1(TituloContenedor: "Comercio", Porcentaje: "22%")
        StatsPorcents1(TituloContenedor: "Tecnología", Porcentaje: "8%")
    }
    .padding()
}
