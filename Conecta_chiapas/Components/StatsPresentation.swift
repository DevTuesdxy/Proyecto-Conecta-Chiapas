//
//  StatsPresentation.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 20/10/25.
//  Ajustado para ser más compacto y adaptable en HStacks
//

import SwiftUI

struct StatsPresentation: View {
    let numero: String
    let textStat: String
    var compact: Bool = true            // hace la tarjeta un poco más baja
    var fill: Color = Color(.colorVerdeMuyClaro) // respeta tu paleta

    @ScaledMetric(relativeTo: .body) private var basePad: CGFloat = 10
    @ScaledMetric(relativeTo: .body) private var corner: CGFloat = 12

    var body: some View {
        // Ajuste dinámico de padding para modo compacto
        let vPad = compact ? max(6, basePad - 2) : basePad
        let hPad = compact ? max(8, basePad - 2) : basePad

        VStack(spacing: compact ? 2 : 4) {
            Text(numero)
                .font(.title2.weight(.semibold)) // un toque más bajo que .title
                .foregroundStyle(.colorVerde)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            Text(textStat)
                .font(.callout)
                .foregroundStyle(.colorGray600)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.vertical, vPad)
        .padding(.horizontal, hPad)
        .frame(maxWidth: .infinity) // para que en HStack ocupen el mismo ancho
        .background(
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .fill(fill)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(textStat): \(numero)")
    }
}

#Preview {
    HStack(spacing: 12) {
        StatsPresentation(numero: "25k+", textStat: "Profesionales")
        StatsPresentation(numero: "1,543+", textStat: "Empresas")
        StatsPresentation(numero: "98%", textStat: "Satisfacción")
        StatsPresentation(numero: "72", textStat: "Vacantes")
    }

}
