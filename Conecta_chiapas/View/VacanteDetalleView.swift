//
//  VacanteDetalleView.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 17/11/25.
//

import SwiftUI
import SwiftData

struct VacanteDetalleView: View {
    @Environment(SessionManager.self) var session
    @Environment(\.modelContext) private var context

    let vacante: Vacante
    let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

    @State private var mensaje = ""
    @State private var yaPostulado = false
    @State private var mostrandoAlerta = false
    @State private var textoAlerta = ""

    private var esCandidato: Bool {
        session.usuarioActual?.tipo == .candidato
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    Text(vacante.puesto)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.secondary)
                        Text(vacante.ubicacion ?? "Ubicación no especificada")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                CardView(
                    title: "Descripción del Puesto",
                    icon: "text.justify.left",
                    content: vacante.descripcion ?? "Sin descripción disponible."
                )
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity, alignment: .center)

                CardView(
                    title: "Requisitos",
                    icon: "checkmark.seal.fill",
                    content: vacante.requisitos ?? "Sin requisitos especificados."
                )
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity, alignment: .center)

                CardView(
                    title: "Salario",
                    icon: "dollarsign.circle.fill",
                    content: vacante.salario ?? "No especificado"
                )
                .frame(maxWidth: 500)
                .frame(maxWidth: .infinity, alignment: .center)

                if esCandidato {
                    VStack(alignment: .leading, spacing: 12) {
                        Divider().padding(.vertical, 4)

                        Text("Postularme a esta vacante")
                            .font(.headline)

                        if yaPostulado {
                            Label("Ya te postulaste a esta vacante",
                                  systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                        } else {
                            Text("Mensaje para la empresa (opcional)")
                                .font(.subheadline)

                            TextField(
                                "Cuéntales brevemente por qué eres buen candidato",
                                text: $mensaje,
                                axis: .vertical
                            )
                            .lineLimit(3...5)
                            .textFieldStyle(.roundedBorder)

                            Button {
                                postularme()
                            } label: {
                                Text("Postularme")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(brandingGreen)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Detalle de Vacante")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: revisarSiYaPostulado)
        .alert("Postulación", isPresented: $mostrandoAlerta) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(textoAlerta)
        }
    }


    private func revisarSiYaPostulado() {
        guard let candidato = session.usuarioActual?.candidato else { return }
        yaPostulado = vacante.postulaciones.contains { $0.candidato === candidato }
    }

    private func postularme() {
        guard let candidato = session.usuarioActual?.candidato else {
            textoAlerta = "Error: no se encontró tu perfil de candidato."
            mostrandoAlerta = true
            return
        }

        do {
            try candidato.postularA(
                vacante: vacante,
                descripcion: mensaje.isEmpty ? nil : mensaje,
                context: context
            )
            yaPostulado = true
            textoAlerta = "✅ Te postulaste correctamente."
        } catch {
            textoAlerta = "Ocurrió un error al postularte: \(error.localizedDescription)"
        }

        mostrandoAlerta = true
    }
}

struct CardView: View {
    let title: String
    let icon: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack(spacing: 10) {
                ZStack{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(red: 0.25, green: 0.75, blue: 0.35))
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Text(content)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
        .padding(.horizontal)
    }
}


#Preview {
    VacanteDetalleView_Preview()
}

private func VacanteDetalleView_Preview() -> some View {
    do {
        let container = try ModelContainer.makeMercadoLaboralContainer(inMemory: true)
        let context = container.mainContext

        let empresaUsuario = Usuario.comoEmpresa(
            idUsuario: 1,
            correo: "empresa@chiapas.com",
            nombre: "Empresa Chiapas",
            contrasenia: "123456",
            idEmpresa: 101,
            nombreEmpresa: "Empresa Chiapas S.A."
        )
        context.insert(empresaUsuario)

        let vacanteEjemplo = Vacante(
            idVacante: 100,
            puesto: "Front end Developer",
            ubicacion: "San Cristóbal de las Casas",
            vacanteStatusTexto: "Activa",
            empresa: empresaUsuario.empresa,
            descripcion: "Desarrollo de interfaces en SwiftUI.",
            salario: "10000 Mensual",
            requisitos: "1+ año de experiencia en iOS."
        )
        context.insert(vacanteEjemplo)

        let candidatoUsuario = Usuario(
            idUsuario: 2,
            nombre: "Juan Pérez",
            correo: "candidato@chiapas.com",
            telefono: "9611234567",
            contrasenia: "123456",
            tipo: .candidato
        )
        let candidatoPerfil = CandidatoPerfil(
            usuario: candidatoUsuario,
            nombre: "Juan",
            apPaterno: "Pérez",
            nacionalidad: "Mexicana"
        )
        candidatoUsuario.candidato = candidatoPerfil
        context.insert(candidatoUsuario)

        let session = SessionManager()
        session.usuarioActual = candidatoUsuario

        return AnyView(
            VacanteDetalleView(vacante: vacanteEjemplo)
                .modelContainer(container)
                .environment(session)
        )

    } catch {
        return AnyView(
            Text("Error al crear el contenedor de vista previa: \(error.localizedDescription)")
                .padding()
        )
    }
}

