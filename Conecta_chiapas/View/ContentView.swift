//
//  ContentView.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 20/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Int = 0
    @State private var goToSelection: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $selection) {
                    CardViewPresentation(
                        style: .presentation,
                        imageStyle: .presentation,
                        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
                        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
                        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
                    )
                    .tag(0)

                    CardViewPresentation(
                        style: .porcent1,
                        imageStyle: .view2,
                        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
                        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
                        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
                    )
                    .tag(1)

                    CardViewPresentation(
                        style: .porcent2,
                        imageStyle: .view3,
                        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
                        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
                        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
                    )
                    .tag(2)

                    CardViewPresentation(
                        style: .porcent3,
                        imageStyle: .view4,
                        Encabezado: Text("¡Bienvenido a Conecta Chiapas!"),
                        Subtitulo: Text("La red profesional que impulsa el desarrollo de nuestra región"),
                        Descripcion: Text("Conecta con talento local, encuentra oportunidades de crecimiento y contribuye al desarrollo económico de Chiapas.")
                    )
                    .tag(3)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .padding(.bottom, 56)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 8) {
                        HStack {
                            Button(action: {
                                withAnimation { selection = max(selection - 1, 0) }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.thickMaterial)
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(.quaternary, lineWidth: 1)
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .frame(width: 44, height: 36)
                                .foregroundStyle(selection == 0 ? .secondary : .primary)
                                .opacity(selection == 0 ? 0.4 : 1.0)
                            }
                            .disabled(selection == 0)

                            Spacer()

                            Button(action: {
                                withAnimation {
                                    if selection < 3 {
                                        selection += 1
                                    } else {
                                        goToSelection = true
                                    }
                                }
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.thickMaterial)
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(.quaternary, lineWidth: 1)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                .frame(width: 44, height: 36)
                                .foregroundStyle(.primary)
                                .opacity(1.0)
                            }

                        }

                        Button("Saltar introducción") {
                            withAnimation { goToSelection = true }
                        }
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .buttonStyle(.plain)
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .padding()
            .navigationDestination(isPresented: $goToSelection) {
                SelectionView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    ContentView()
}
