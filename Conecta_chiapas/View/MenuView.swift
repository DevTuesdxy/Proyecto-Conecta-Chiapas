import SwiftUI
import SwiftData

struct MenuView: View {
    @Environment(\.modelContext) private var context
    @State private var selectedTab: Tab = .dashboard
    
    @State private var isShowingPublishSheet = false
    
    @Query private var empresas: [EmpresaPerfil]
    
    @Query(sort: \Vacante.fecha, order: .reverse) private var vacantes: [Vacante]

    enum Tab: Hashable { case dashboard, jobs, publish, notifications, candidates }
    
    let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

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
                    Text("Chiapas").font(.caption).foregroundStyle(brandingGreen)
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
                            RoundedRectangle(cornerRadius: 16).fill(.thinMaterial).frame(height: 140).overlay(Text("Contenido principal").foregroundStyle(.secondary))
                            RoundedRectangle(cornerRadius: 16).fill(.thinMaterial).frame(height: 140).overlay(Text("Tarjeta destacada").foregroundStyle(.secondary))
                        }.padding()
                    }
                    .navigationTitle("Dashboard")
                }
                .tabItem { Image(systemName: selectedTab == .dashboard ? "house.fill" : "house"); Text("Dashboard") }
                .tag(Tab.dashboard)

                NavigationStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("Resumen de Empleos")
                                .font(.title2).bold()

                            HStack(spacing: 16) {
                                StatCard(title: "Empleos activos", value: "\(vacantes.count)", systemImage: "briefcase.fill")
                                StatCard(title: "Aplicaciones", value: "156", systemImage: "doc.plaintext")
                            }
                            
                            Divider()

                            Text("Vacantes Publicadas (\(vacantes.count))")
                                .font(.headline)
                            
                            if vacantes.isEmpty {
                                Text("Aún no has publicado ninguna vacante.")
                                    .foregroundStyle(.secondary)
                                    .padding()
                            } else {
                                ForEach(vacantes, id: \.idVacante) { vacante in
                                    VacanteRow(vacante: vacante)
                                }
                            }
                        }
                        .padding()
                    }
                    .navigationTitle("Empleos")
                }
                .tabItem { Image(systemName: selectedTab == .jobs ? "chart.bar.fill" : "chart.bar"); Text("Empleos") }
                .tag(Tab.jobs)

                NavigationStack {
                    Color.clear
                        .navigationTitle("Publicar")
                }
                .tabItem { Image(systemName: selectedTab == .publish ? "plus.rectangle.fill" : "plus.rectangle"); Text("Publicar") }
                .tag(Tab.publish)

                NavigationStack {
                    List {
                        Section("Hoy") { Label("Nuevo mensaje de soporte", systemImage: "bell"); Label("Actualización de sistema", systemImage: "bell") }
                        Section("Ayer") { Label("Pedido confirmado", systemImage: "bell"); Label("Recordatorio de tarea", systemImage: "bell") }
                    }
                    .navigationTitle("Notificaciones")
                }
                .tabItem { Image(systemName: selectedTab == .notifications ? "bell.fill" : "bell"); Text("Alertas") }
                .tag(Tab.notifications)

                NavigationStack {
                    ScrollView {
                        VStack(spacing: 12) {
                            CandidateCard(name: "María García López", role: "Desarrollador Frontend", location: "San Cristóbal de las Casas", skills: ["React", "JavaScript"])
                            CandidateCard(name: "Carlos Mendoza", role: "Diseñador UX/UI", location: "Tuxtla Gutiérrez", skills: ["Figma", "Sketch"])
                            CandidateCard(name: "Ana Ruiz", role: "Ingeniera de Datos", location: "Tapachula", skills: ["Python", "SQL"])
                        }.padding()
                    }
                    .navigationTitle("Candidatos")
                }
                .tabItem { Image(systemName: selectedTab == .candidates ? "person.2.fill" : "person.2"); Text("Candidatos") }
                .tag(Tab.candidates)
            }
            .tint(brandingGreen)
            
            .onChange(of: selectedTab) { newValue in
                if newValue == .publish {
                    if !empresas.isEmpty {
                         isShowingPublishSheet = true
                    } else {
                        selectedTab = .dashboard
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if empresas.isEmpty {
                let usuarioEmpresa = Usuario.comoEmpresa(
                    idUsuario: 99,
                    correo: "mock@chiapas.com",
                    nombre: "Empresa Mock S.A.",
                    idEmpresa: 999,
                    nombreEmpresa: "Empresa Mock S.A."
                )
                context.insert(usuarioEmpresa)
                try? context.save()
            }
        }
        .sheet(isPresented: $isShowingPublishSheet, onDismiss: {
            selectedTab = .dashboard 
        }) {
            if let empresa = empresas.first {
                PublicarVacanteView(empresa: empresa)
            } else {
                Text("Error: Perfil de empresa no encontrado en la base de datos.")
            }
        }
    }
}

struct VacanteRow: View {
    let vacante: Vacante
    let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vacante.puesto).font(.headline).foregroundStyle(.primary)
                Text(vacante.ubicacion ?? "Ubicación no definida").font(.subheadline).foregroundStyle(.secondary)
                Text("Salario: \(vacante.salario ?? "No especificado")").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "circle.fill").resizable().frame(width: 8, height: 8).foregroundColor(brandingGreen).offset(y: 4)
        }
        .padding().background(.thinMaterial).cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let systemImage: String
    let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage).font(.title2).foregroundColor(brandingGreen)
            Text(value).font(.title3).bold()
            Text(title).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding().background(.thinMaterial).cornerRadius(12)
    }
}

struct CandidateCard: View {
    let name: String
    let role: String
    let location: String
    let skills: [String]
    let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            Text(name).font(.headline)
            Text(role).font(.subheadline).foregroundStyle(.secondary)
            Text(location).font(.caption).foregroundStyle(.secondary)
            HStack {
                ForEach(skills, id: \.self) { skill in
                    Text(skill).font(.caption2).padding(.horizontal, 6).padding(.vertical, 4)
                        .background(brandingGreen.opacity(0.15))
                        .cornerRadius(6)
                }
            }
        }.padding().background(.ultraThinMaterial).cornerRadius(12)
    }
}

#Preview {
    do {
        let container = try ModelContainer.makeMercadoLaboralContainer(inMemory: true)
        
        let usuarioEmpresa = Usuario.comoEmpresa(
            idUsuario: 1,
            correo: "empresa@chiapas.com",
            nombre: "Empresa Chiapas S.A.",
            idEmpresa: 101,
            nombreEmpresa: "Empresa Chiapas S.A."
        )
        
        container.mainContext.insert(usuarioEmpresa)
        
        let vacanteEjemplo = Vacante(
            idVacante: 100,
            puesto: "Desarrollador Swift Senior",
            ubicacion: "Tuxtla Gutiérrez",
            vacanteStatusTexto: "Activa",
            empresa: usuarioEmpresa.empresa,
            descripcion: "Desarrollo de apps.",
            salario: "$30,000 Mensual",
            requisitos: "5 años experiencia."
        )
        container.mainContext.insert(vacanteEjemplo)
        
        return MenuView()
            .modelContainer(container)
        
    } catch {
        return Text("Error al crear el contenedor de vista previa: \(error.localizedDescription)")
    }
}
