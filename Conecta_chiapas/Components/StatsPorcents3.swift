//
//  StatsPorcents3.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 27/10/25.
//

import SwiftUI

struct StatsPorcents3: View {
    
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
                    .foregroundStyle(.colorAzul)
            }
            .padding(10)                          // un pelín menos padding también ayuda a compactar
            .background(
                
                    
                    
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundStyle(.colorAzulLight)
                
            )
        }


    }


#Preview {
    StatsPorcents3(TituloContenedor: "Startups Locales", Porcentaje: "150+")
        .padding()
}
