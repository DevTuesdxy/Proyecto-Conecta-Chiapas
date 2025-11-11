
import SwiftUI

struct FormularioComponet: View {
    @Environment(\.dismiss) private var dismiss
    
    let titulo: String
    let contenido: String
    let nombre: String
    @Binding var tuNombreInput: String
    let apellido: String
    @Binding var tuApellidoInput: String
    let email: String
    @Binding var tuEmailInput: String
    let telefono: String
    @Binding var tuTelefonoInput: String
    let contraseña: String
    @Binding var tuContraseñaInput: String
    let ubicacion: String
    @Binding var tuUbicacion: String
    @Binding var curp: String
    @Binding var nacionalidad: String
    @Binding var fechaNacimiento: Date
    
    let municipios: [String] = [
        "Tuxtla Gutiérrez",
        "San Cristóbal de las Casas",
        "Tapachula",
        "Comitán",
        "Palenque",
        "Arriaga",
        "Tonalá"
    ]
    
    var body: some View {
        Form {
            Text(contenido)
                .font(.title3)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 6)
                .listRowSeparator(.hidden)
            
            LabeledInput(label: nombre, placeholder: "Tu nombre", text: $tuNombreInput)
                .listRowSeparator(.hidden)
            
            LabeledInput(label: apellido, placeholder: "Tu apellido", text: $tuApellidoInput)
                .listRowSeparator(.hidden)
            
            LabeledInput(label: email, placeholder: "Tu @email", text: $tuEmailInput)
                .listRowSeparator(.hidden)
            
            LabeledInput(label: telefono, placeholder: "962 123 4567", text: $tuTelefonoInput)
                .listRowSeparator(.hidden)
            
            SecureLabeledInput(label: contraseña, placeholder: "Mínimo 6 caracteres", text: $tuContraseñaInput)
                .listRowSeparator(.hidden)
            
            ComboboxViewLabeledInput(label: ubicacion, placeholder: "Selecciona tu municipio", text: $tuUbicacion, options: municipios)
                .listRowSeparator(.hidden)
            LabeledInput(label: "CURP", placeholder: "C", text: $curp)
            LabeledInput(label: "Nacionalidad", placeholder: "Mexicana", text: $nacionalidad)
                .listRowSeparator(.hidden)
            DatePicker("Fecha de nacimiento", selection: $fechaNacimiento, displayedComponents: .date)
            
        }
        .scrollContentBackground(.hidden)
        .background(Color.white)
        .navigationTitle(titulo)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HeaderButton { dismiss() }
            }
        }
    }
}

private struct SecureLabeledInput: View {
    let label: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.title3)
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            SecureField(placeholder, text: $text)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.leading)
                .padding(.trailing)
        }
    }
}

private struct ComboboxViewLabeledInput: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var options: [String] = []
    
    @State private var isOtherSelected: Bool = false
    @State private var otherText: String = ""

    private var displayText: String {
        if isOtherSelected {
            return otherText.isEmpty ? placeholder : otherText
        } else {
            return text.isEmpty ? placeholder : text
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.title3)
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            HStack {
                Text(displayText)
                    .foregroundStyle((isOtherSelected ? otherText.isEmpty : text.isEmpty) ? .secondary : .primary)
                Spacer()
                Image(systemName: "chevron.up.chevron.down")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .padding(.horizontal)
            .overlay(alignment: .trailing) {
                Menu {
                    let list = options.isEmpty ? [
                        "Tuxtla Gutiérrez",
                        "San Cristóbal de las Casas",
                        "Tapachula",
                        "Comitán",
                        "Palenque"
                    ] : options

                    ForEach(list, id: \.self) { option in
                        Button(option) {
                            text = option
                            isOtherSelected = false
                            otherText = ""
                        }
                    }

                    Divider()

                    Button("Otro") {
                        isOtherSelected = true
                        if text != otherText { otherText = "" }
                        text = otherText
                    }
                } label: {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                        .accessibilityLabel("Abrir lista de municipios")
                }
                .padding(.trailing, 8)
            }
            if isOtherSelected {
                TextField("Escribe tu municipio", text: Binding(
                    get: { otherText },
                    set: { newValue in
                        otherText = newValue
                        text = newValue
                    }
                ))
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                .transition(.opacity)
            }
        }
    }
}

private struct HeaderButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(8)
                .background(.ultraThinMaterial, in: Capsule())
        }
        .buttonStyle(.plain)
        .contentShape(Capsule())
        .accessibilityLabel("Volver al inicio")
    }
}

struct LabeledInput: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.title3)
                .fontWeight(.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            TextField(placeholder, text: $text)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.leading)
                .padding(.trailing)
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var nombreUsuario = ""
        @State private var apellidoUsuario = ""
        @State private var emailUsuario = ""
        @State private var telefonoUsuario = ""
        @State private var contrasenaUsuario = ""
        @State private var ubicacionUsuario = ""
        @State private var curp = ""
        @State private var nacionalidad = ""
        @State private var fechaNacimiento = Date()
        
        var body: some View {
            NavigationStack {
                VStack{
                    FormularioComponet(
                        titulo: "Registro de Candidato",
                        contenido: "Completa tu perfil para comenzar a buscar oportunidades en Chiapas",
                        nombre: "Nombre",
                        tuNombreInput: $nombreUsuario,
                        apellido: "Apellidos",
                        tuApellidoInput: $apellidoUsuario,
                        email: "Email",
                        tuEmailInput: $emailUsuario,
                        telefono: "Telefono",
                        tuTelefonoInput: $telefonoUsuario,
                        // Falta el de profesion/area
                        // Nivel de Experiencia
                        contraseña: "Contraseña",
                        tuContraseñaInput: $contrasenaUsuario,
                        ubicacion: "Ubicación",
                        tuUbicacion: $ubicacionUsuario,
                        curp: $curp,
                        nacionalidad: $nacionalidad,
                        fechaNacimiento: $fechaNacimiento
                    )
                }
            }
        }
    }
    
    return PreviewWrapper()
}
