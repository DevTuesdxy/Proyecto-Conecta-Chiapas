//
//  MenuView.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 23/10/25.
//
import SwiftUI

struct MenuView: View {
    @State private var selectedTab: Tab = .dashboard

    enum Tab: Hashable { case dashboard, jobs, publish, notifications, candidates }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color(.systemGreen)).frame(width: 36, height: 36)
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Conecta").font(.headline).bold()
                    Text("Chiapas").font(.caption).foregroundStyle(.green)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .padding(8)
                        .background(.ultraThinMaterial, in: Circle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)

            Divider()

            TabView(selection: $selectedTab) {
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 16) {
                            Text("Dashboard")
                                .font(.title2).bold()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thinMaterial)
                                .frame(height: 140)
                                .overlay(Text("Contenido principal").foregroundStyle(.secondary))
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thinMaterial)
                                .frame(height: 140)
                                .overlay(Text("Tarjeta destacada").foregroundStyle(.secondary))
                        }
                        .padding()
                    }
                    .navigationTitle("Dashboard")
                }
                .tabItem {
                    Image(systemName: selectedTab == .dashboard ? "house.fill" : "house")
                    Text("Dashboard")
                }
                .tag(Tab.dashboard)

                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Dashboard de Empresa")
                                .font(.title2).bold()

                            HStack(spacing: 16) {
                                StatCard(title: "Empleos activos", value: "8", systemImage: "briefcase.fill")
                                StatCard(title: "Aplicaciones", value: "156", systemImage: "doc.plaintext")
                            }
                            HStack(spacing: 16) {
                                StatCard(title: "Vistas", value: "342", systemImage: "eye.fill")
                                StatCard(title: "Alcance", value: "25,430", systemImage: "antenna.radiowaves.left.and.right")
                            }

                            Divider()

                            Text("Aplicaciones recientes")
                                .font(.headline)

                            VStack(spacing: 12) {
                                CandidateCard(
                                    name: "María García López",
                                    role: "Desarrollador Frontend",
                                    location: "San Cristóbal de las Casas",
                                    skills: ["React", "JavaScript"]
                                )
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Empleos")
                }
                .tabItem {
                    Image(systemName: selectedTab == .jobs ? "chart.bar.fill" : "chart.bar")
                    Text("Empleos")
                }
                .tag(Tab.jobs)

                // Publicar
                NavigationStack {
                    ScrollView {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                            .frame(height: 140)
                            .overlay(Text("Crear publicación").foregroundStyle(.secondary))
                            .padding()
                    }
                    .navigationTitle("Publicar")
                }
                .tabItem {
                    Image(systemName: selectedTab == .publish ? "plus.rectangle.fill" : "plus.rectangle")
                    Text("Publicar")
                }
                .tag(Tab.publish)

                // Notificaciones
                NavigationStack {
                    List {
                        Section("Hoy") {
                            Label("Nuevo mensaje de soporte", systemImage: "bell")
                            Label("Actualización de sistema", systemImage: "bell")
                        }
                        Section("Ayer") {
                            Label("Pedido confirmado", systemImage: "bell")
                            Label("Recordatorio de tarea", systemImage: "bell")
                        }
                    }
                    .navigationTitle("Notificaciones")
                }
                .tabItem {
                    Image(systemName: selectedTab == .notifications ? "bell.fill" : "bell")
                    Text("Alertas")
                }
                .tag(Tab.notifications)

                // Candidatos
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 12) {
                            CandidateCard(
                                name: "María García López",
                                role: "Desarrollador Frontend",
                                location: "San Cristóbal de las Casas",
                                skills: ["React", "JavaScript"]
                            )
                            CandidateCard(
                                name: "Carlos Mendoza",
                                role: "Diseñador UX/UI",
                                location: "Tuxtla Gutiérrez",
                                skills: ["Figma", "Sketch"]
                            )
                            CandidateCard(
                                name: "Ana Ruiz",
                                role: "Ingeniera de Datos",
                                location: "Tapachula",
                                skills: ["Python", "SQL"]
                            )
                        }
                        .padding()
                    }
                    .navigationTitle("Candidatos")
                }
                .tabItem {
                    Image(systemName: selectedTab == .candidates ? "person.2.fill" : "person.2")
                    Text("Candidatos")
                }
                .tag(Tab.candidates)
            }
            .tint(Color(.systemGreen))
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Componente de tarjeta de estadísticas
struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundColor(.green)
            Text(value)
                .font(.title3).bold()
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .cornerRadius(12)
    }
}

struct CandidateCard: View {
    let name: String
    let role: String
    let location: String
    let skills: [String]

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(name).font(.headline)
            Text(role).font(.subheadline).foregroundStyle(.secondary)
            Text(location).font(.caption).foregroundStyle(.secondary)
            HStack {
                ForEach(skills, id: \.self) { skill in
                    Text(skill)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

#Preview {
    MenuView()
}
