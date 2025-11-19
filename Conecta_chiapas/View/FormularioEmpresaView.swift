//
//  FormularioEmpresaView.swift
//  Conecta_chiapas
//


import SwiftUI
import SwiftData

struct FormularioEmpresaView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Environment(SessionManager.self) var session
    
    // MARK: - Campos
    @State private var nombreEmpresa = ""
    @State private var contacto = ""
    @State private var emailEmpresa = ""
    @State private var telefonoEmpresa = ""
    @State private var sector = ""
    @State private var tamano = ""
    @State private var descripcion = ""
    @State private var contrasenaEmpresa = ""
    @State private var ubicacion = "Tuxtla Gutiérrez"
   
    @State private var navegarAlMenu: Bool = false
    
    private var formularioValido: Bool {
        !nombreEmpresa.isEmpty &&
        isValidEmail(emailEmpresa) &&
        contrasenaEmpresa.count >= 6 &&
        !telefonoEmpresa.isEmpty &&
        telefonoEmpresa.count >= 10 &&
        !ubicacion.isEmpty &&
        !sector.isEmpty &&
        !tamano.isEmpty &&
        !descripcion.isEmpty
    }
    
    let municipios: [String] = [
        "Tuxtla Gutiérrez",
        "San Cristóbal de las Casas",
        "Tapachula",
        "Comitán",
        "Palenque",
        "Arriaga",
        "Tonalá"
    ]
    
    private func registrarEmpresa() {
        let id = Int.random(in: 1000...9999)
        
        let usuario = Usuario.comoEmpresa(
            idUsuario: id,
            correo: emailEmpresa.lowercased(),
            nombre: nombreEmpresa,
            contrasenia: contrasenaEmpresa,
            idEmpresa: nil,
            nombreEmpresa: nombreEmpresa
        )
        
        usuario.telefono = telefonoEmpresa
        usuario.empresa?.razonSocial = "\(nombreEmpresa) S.A. de C.V."
        usuario.empresa?.sectorComercial = sector.isEmpty ? "General" : sector
        usuario.empresa?.direccion = ubicacion
        usuario.empresa?.contacto = contacto.isEmpty ? telefonoEmpresa : contacto
        
        context.insert(usuario)
        
        do {
            try context.save()
            session.guardarSesion(usuario)
            let fetch = FetchDescriptor<EmpresaPerfil>()
            let empresas = try? context.fetch(fetch)
            print("✅ Empresa registrada correctamente. Total empresas: \(empresas?.count ?? 0)")
            navegarAlMenu = true
        } catch {
            print("💥 Error al guardar empresa: \(error)")
        }
        

    }
    
    var body: some View {
        NavigationStack {
            
            Text("Registro de Empresa")
                .font(.largeTitle.bold())
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            ScrollView {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        Group {
                            CustomInput(label: "Nombre de la Empresa", placeholder: "Nombre de tu empresa", text: $nombreEmpresa)
                            CustomInput(label: "Nombre de Contacto", placeholder: "Nombre de la persona de contacto", text: $contacto)
                            CustomInput(label: "Email", placeholder: "contacto@empresa.com", text: $emailEmpresa, keyboardType: .emailAddress)
                            CustomInput(label: "Teléfono", placeholder: "961 123 4567", text: $telefonoEmpresa, keyboardType: .phonePad)

                            VStack(alignment: .leading, spacing: 6){
                                Text("Ubicación")
                                    .font(.subheadline)
                                    .foregroundStyle(Color(.colorGray900))
                                
                                Picker("Selecciona el municipio", selection: $ubicacion){
                                    ForEach(municipios, id: \.self){
                                        municipio in
                                        Text(municipio).tag(municipio)
                                    }
                                }
                                .pickerStyle(.menu)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            CustomInput(label: "Sector", placeholder: "Selecciona el sector", text: $sector)
                            CustomInput(label: "Tamaño de Empresa", placeholder: "Selecciona el tamaño", text: $tamano)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Descripción de la Empresa")
                                    .font(.subheadline)
                                    .foregroundColor(.colorGray900)
                                TextField("Describe brevemente tu empresa y lo que hacen...", text: $descripcion, axis: .vertical)
                                    .lineLimit(3, reservesSpace: true)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                            
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Contraseña")
                                    .font(.subheadline)
                                    .foregroundColor(.colorGray900)
                                SecureField("Mínimo 6 caracteres", text: $contrasenaEmpresa)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        }
                        
                        Button(action: registrarEmpresa) {
                            Text("Crear Cuenta de Empresa")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(formularioValido ? Color.green : Color.gray.opacity(0.4))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(!formularioValido)
                        .padding(.top, 10)
                        
                        NavigationLink(destination: MenuView(), isActive: $navegarAlMenu) {
                            EmptyView()
                        }
                        .hidden()
                        
                        VStack(spacing: 4) {
                            Text("Al crear una cuenta, aceptas nuestros")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack(spacing: 3) {
                                Text("Términos de Servicio")
                                    .underline()
                                    .foregroundColor(.blue)
                                Text("y")
                                    .foregroundColor(.secondary)
                                Text("Política de Privacidad")
                                    .underline()
                                    .foregroundColor(.blue)
                            }
                            .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)
                    }
                    .padding(20)
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CustomInput: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.colorGray900)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer.makeMercadoLaboralContainer(inMemory: true)
        let sessionManager = SessionManager()
        
        return FormularioEmpresaView()
            .modelContainer(container)
            .environment(sessionManager)
    } catch {
        fatalError("Error al crear contenedor SwiftData: \(error)")
    }
}
