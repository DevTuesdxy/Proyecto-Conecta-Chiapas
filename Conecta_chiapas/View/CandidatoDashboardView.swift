//
//  CandidatoDashboardView.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 17/11/25.
//

import SwiftUI
import SwiftData

struct CandidateDashboardView: View {
    @Environment(SessionManager.self) var session

    private var usuario: Usuario? { session.usuarioActual }
    private var candidato: CandidatoPerfil? { session.usuarioActual?.candidato }

    private var initials: String {
        let name = usuario?.nombre ?? ""
        let comps = name.split(separator: " ")
        let first = comps.first?.first.map(String.init) ?? ""
        let last = comps.dropFirst().first?.first.map(String.init) ?? ""
        return (first + last).uppercased()
    }

    private var firstName: String {
        let name = usuario?.nombre ?? ""
        return name.split(separator: " ").first.map(String.init) ?? "Usuario"
    }

    private let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            ProfileCard(
                initials: initials,
                name: usuario?.nombre ?? "Candidato",
                subtitle: "Profesional en Chiapas",
                location: "Tuxtla Gutiérrez, Chiapas",
                views: 127,
                connections: 84,
                impressions: 1250
            )
            .padding(.horizontal)

            ComposerCard(
                initials: initials,
                promptName: firstName,
                brandingGreen: brandingGreen
            )
            .padding(.horizontal)

            CandidateFeedPlaceholder()
                .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 8)
    }
}

struct ProfileCard: View {
    let initials: String
    let name: String
    let subtitle: String
    let location: String
    let views: Int
    let connections: Int
    let impressions: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(initials)
                            .font(.headline)
                            .foregroundColor(.green)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button {
                } label: {
                    Image(systemName: "square.and.pencil")
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color(.systemGray6))
                        )
                }
            }

            Divider()

            HStack {
                StatColumn(value: views, label: "Vistas")
                Spacer()
                StatColumn(value: connections, label: "Conexiones")
                Spacer()
                StatColumn(value: impressions, label: "Impresiones")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
}

struct StatColumn: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}


struct ComposerCard: View {
    let initials: String
    let promptName: String
    let brandingGreen: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Circle()
                    .fill(brandingGreen.opacity(0.12))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(initials)
                            .font(.subheadline)
                            .foregroundColor(brandingGreen)
                    )

                Text("¿Qué quieres compartir, \(promptName)?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(
                        Capsule()
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
            }

            Divider()

            HStack(spacing: 32) {
                ComposerIcon(systemName: "photo", color: .blue)
                ComposerIcon(systemName: "video.fill", color: .green)
                ComposerIcon(systemName: "calendar", color: .orange)
                ComposerIcon(systemName: "doc.text.fill", color: .purple)
            }
            .font(.title3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
        )
    }
}

struct ComposerIcon: View {
    let systemName: String
    let color: Color

    var body: some View {
        Image(systemName: systemName)
            .foregroundColor(color)
    }
}

struct CandidateFeedPlaceholder: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Actividad reciente")
                .font(.headline)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
                .frame(height: 80)
                .overlay(
                    Text("Aquí podrías mostrar publicaciones de tu red,\nrecomendaciones o noticias de empleo.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                )
        }
    }
}

struct CandidateJobsHint: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Empleos para ti")
                .font(.headline)
            Text("Ve a la pestaña *Empleos* del menú inferior para ver todas las vacantes disponibles.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct CandidateNetworkHint: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tu red profesional")
                .font(.headline)
            Text("En futuras versiones, aquí podrás ver tus conexiones, invitaciones y sugerencias de contacto.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
