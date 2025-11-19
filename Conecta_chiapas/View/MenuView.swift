import SwiftUI
import SwiftData

struct MenuView: View {
    @Environment(SessionManager.self) var session
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTab: Tab = .dashboard
    @State private var isShowingPublishSheet = false
    
    @Query(sort: \Vacante.fecha, order: .reverse) private var vacantes: [Vacante]
    @Query private var postulaciones: [DetalleVacantePostulacion]
    
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

                //Btn Cerrar sesion
                Button {
                    dismiss()
                } label: {
                    Text("Cerrar Sesión")
                        .font(.callout)
                        .foregroundStyle(brandingGreen)
                        .padding(8)
                        .background(Color(.systemGray5))
                        .cornerRadius(12)
                }

            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)

            Divider()

            TabView(selection: $selectedTab) {

                //DASHBOARD
                NavigationStack {
                    ScrollView {
                        if session.usuarioActual?.tipo == .candidato {
                            CandidateDashboardView()
                        } else {
//                            EmpresaDashboardView()
                        }
                    }
                    .navigationTitle("Dashboard")
                }
                .tabItem {
                    Image(systemName: selectedTab == .dashboard ? "house.fill" : "house")
                    Text("Dashboard")
                }
                .tag(Tab.dashboard)

                //Empleos
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
                                    NavigationLink(destination: VacanteDetalleView(vacante: vacante)) {
                                        VacanteRow(vacante: vacante)
                                    }
                                }
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


                //Publicar Solo empresas
                if session.usuarioActual?.tipo == .empresa {
                    NavigationStack {
                        Color.clear
                    }
                    .tabItem {
                        Image(systemName: selectedTab == .publish ? "plus.rectangle.fill" : "plus.rectangle")
                        Text("Publicar")
                    }
                    .tag(Tab.publish)
                }


                //Alertas
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


                //Candidatos
                // Vista para empresa
                if session.usuarioActual?.tipo == .empresa {
                    NavigationStack {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 16) {

                                Text("Candidatos postulados")
                                    .font(.title2).bold()
                                    .padding(.horizontal)

                                if candidatosDeMisVacantes.isEmpty {
                                    Text("Aún no tienes candidatos postulados a tus vacantes.")
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal)
                                } else {
                                    ForEach(candidatosDeMisVacantes) { candidato in
                                        let nombre = nombreCompleto(de: candidato)
                                        let conteo = postulacionesDe(candidato)

                                        CandidateCard(
                                            name: nombre.isEmpty ? "Candidato sin nombre" : nombre,
                                            role: conteo == 1
                                                ? "Postulado a 1 vacante tuya"
                                                : "Postulado a \(conteo) vacantes tuyas",
                                            location: candidato.nacionalidad ?? "Ubicación no especificada",
                                            skills: ["Ver perfil"]
                                        )
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                        .navigationTitle("Candidatos")
                    }
                    .tabItem {
                        Image(systemName: selectedTab == .candidates ? "person.2.fill" : "person.2")
                        Text("Candidatos")
                    }
                    .tag(Tab.candidates)
                }
            }
            .tint(brandingGreen)
        }
        .onAppear {
            print("Usuario actual:", session.usuarioActual?.nombre ?? "N/A")
            print("Empresa:", session.usuarioActual?.empresa?.nombreEmpresa ?? "N/A")
        }

        .sheet(isPresented: $isShowingPublishSheet, onDismiss: {
            selectedTab = .dashboard
        }) {
            if let empresa = session.usuarioActual?.empresa {
                PublicarVacanteView(empresa: empresa)
            } else {
                Text("Error: Empresa no encontrada")
            }
        }

        .onChange(of: selectedTab) { newValue in
            if newValue == .publish {
                if session.usuarioActual?.empresa != nil {
                    isShowingPublishSheet = true
                } else {
                    selectedTab = .dashboard
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var candidatosDeMisVacantes: [CandidatoPerfil]{
        guard let empresa = session.usuarioActual?.empresa else { return [] }
        
        var vistos = Set<ObjectIdentifier>()
        var resultado: [CandidatoPerfil] = []
        
        for p in postulaciones{
            guard let vacante = p.vacante,
                  vacante.empresa === empresa,
                  let candidato = p.candidato
            else { continue }
            
            let id = ObjectIdentifier(candidato)
            if !vistos.contains(id) {
                vistos.insert(id)
                resultado.append(candidato)
            }
            
        }
        return resultado
    }
    
    private func nombreCompleto(de candidato: CandidatoPerfil) -> String {
        [candidato.nombre, candidato.apPaterno, candidato.apMaterno]
            .compactMap { $0 }
            .joined(separator: " ")
    }

    private func postulacionesDe(_ candidato: CandidatoPerfil) -> Int {
        guard let empresa = session.usuarioActual?.empresa else { return 0 }
        return postulaciones.filter { p in
            p.candidato === candidato && p.vacante?.empresa === empresa
        }.count
    }
    
}


struct VacanteRow: View {
    let vacante: Vacante
    let brandingGreen = Color(red: 0.25, green: 0.75, blue: 0.35)

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            VStack(alignment: .leading, spacing: 6) {
                Text(vacante.puesto)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(vacante.ubicacion ?? "Ubicación no definida")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Salario: \(vacante.salario ?? "No especificado")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Circle()
                .fill(brandingGreen)
                .frame(width: 10, height: 10)
                .padding(.top, 4)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
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
    MenuView_Preview()
}

private func MenuView_Preview() -> some View {
    do {
        let container = try ModelContainer.makeMercadoLaboralContainer(inMemory: true)

        let session = SessionManager()

        let usuarioEmpresa = Usuario.comoEmpresa(
            idUsuario: 1,
            correo: "empresa@chiapas.com",
            nombre: "Empresa Chiapas S.A.",
            contrasenia: "123456",
            idEmpresa: 101,
            nombreEmpresa: "Empresa Chiapas S.A."
        )

        session.usuarioActual = usuarioEmpresa

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

        return AnyView(
            MenuView()
                .modelContainer(container)
                .environment(session)
        )

    } catch {
        return AnyView(
            Text("Error al crear el contenedor de vista previa: \(error.localizedDescription)")
        )
    }
}

