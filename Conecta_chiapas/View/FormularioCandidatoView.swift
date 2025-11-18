import SwiftUI
import SwiftData

struct FormularioCandidatoView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) var session

    @State private var nombreUsuario = ""
    @State private var apellidoUsuario = ""
    @State private var emailUsuario = ""
    @State private var telefonoUsuario = ""
    @State private var contrasenaUsuario = ""
    @State private var ubicacionUsuario = ""
    
    @State private var nacionalidad = ""
    @State private var curp = ""
    @State private var fechaNacimiento = Date()
    
    @State private var navegarAlMenu: Bool = false
    
    private var formularioValido: Bool {
        !nombreUsuario.isEmpty &&
        !apellidoUsuario.isEmpty &&
        isValidEmail(emailUsuario) &&
        contrasenaUsuario.count >= 6 &&
        !ubicacionUsuario.isEmpty &&
        isValidCurp(curp) &&
        !nacionalidad.isEmpty
    }
    
    private func registrarCandidato() {
        let id = Int.random(in: 1000...9999)

        let usuario = Usuario(
            idUsuario: id,
            nombre: "\(nombreUsuario) \(apellidoUsuario)",
            correo: emailUsuario.lowercased(),
            telefono: telefonoUsuario,
            contrasenia: contrasenaUsuario,
            tipo: .candidato
        )
        
        let perfil = CandidatoPerfil(
            usuario: usuario,
            nombre: nombreUsuario,
            apPaterno: apellidoUsuario,
            curp: curp,
            nacionalidad: nacionalidad.isEmpty ? "Mexicana" : nacionalidad,
            fechaNacimiento: fechaNacimiento
        )
         
        usuario.candidato = perfil
        context.insert(usuario)
        
        do {
            try context.save()
            session.guardarSesion(usuario)
            print("Candidato registrado correctamente")

            session.usuarioActual = usuario
            print("SessionManager tipo usuario:", session.usuarioActual?.tipo?.rawValue ?? "nil")

            navegarAlMenu = true
        } catch {
            print("Error al guardar candidato: \(error)")
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                FormularioComponet(
                    titulo: "Registro de Candidato",
                    contenido: "Completa tu perfil para comenzar a buscar oportunidades en Chiapas",
                    nombre: "Nombre",
                    tuNombreInput: $nombreUsuario,
                    apellido: "Apellidos",
                    tuApellidoInput: $apellidoUsuario,
                    email: "Correo electrónico",
                    tuEmailInput: $emailUsuario,
                    telefono: "Teléfono",
                    tuTelefonoInput: $telefonoUsuario,
                    contraseña: "Contraseña",
                    tuContraseñaInput: $contrasenaUsuario,
                    ubicacion: "Ubicación",
                    tuUbicacion: $ubicacionUsuario,
                    curp: $curp,
                    nacionalidad: $nacionalidad,
                    fechaNacimiento: $fechaNacimiento
                )
                
                Button("Registrar Candidato") {
                    registrarCandidato()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(!formularioValido)
                .padding(.horizontal)
                .padding(.bottom)
                
                NavigationLink(destination: MenuView(),
                               isActive: $navegarAlMenu) {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("Registro de Candidato")
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer.makeMercadoLaboralContainer(inMemory: true)
        let sessionManager = SessionManager()
        
        return FormularioCandidatoView()
            .modelContainer(container)
            .environment(sessionManager)
    } catch {
        fatalError("Error al crear contenedor de SwiftData: \(error)")
    }
}
