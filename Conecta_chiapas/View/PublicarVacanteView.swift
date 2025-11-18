//
//  PublicarVacanteView.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 12/11/25.
//

import SwiftUI
import SwiftData

struct PublicarVacanteView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var puesto: String = ""
    @State private var ubicacion: String = ""
    @State private var tipoEmpleo: String = "Tiempo Completo"
    @State private var departamento: String = ""
    @State private var salario: String = ""
    @State private var periodoSalario: String = "Mensual"
    @State private var descripcion: String = ""
    @State private var requisitos: String = ""
    var empresa: EmpresaPerfil
    
    let tiposEmpleo = ["Tiempo Completo", "Medio Tiempo", "Por Proyecto", "Prácticas"]
    let periodosSalario = ["Mensual", "Semanal", "Anual"]
    let ubicacionesChiapas = ["Selecciona una ubicación", "Tuxtla Gutiérrez", "Tapachula", "San Cristóbal de las Casas", "Comitán de Domínguez", "Chiapas sin especificar"]
    
    private var formularioValido: Bool {
        !puesto.isEmpty &&
        !ubicacion.isEmpty && ubicacion != ubicacionesChiapas.first! &&
        !descripcion.isEmpty &&
        !requisitos.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
                    fieldWithLabel(label: "Puesto", isRequired: true) {
                        TextField("ej. Desarrollador Frontend Senior", text: $puesto)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Ubicación", isRequired: true)
                        
                        Picker("", selection: $ubicacion) {
                            ForEach(ubicacionesChiapas, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .accentColor(Color(red: 0.25, green: 0.75, blue: 0.35))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Nombre de la Empresa")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(empresa.nombreEmpresa ?? "Empresa Chiapas S.A.")
                            .font(.body)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    .background(RoundedRectangle(cornerRadius: 6).fill(Color(.systemGray6)))
                            )
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tipo de Empleo")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Picker("", selection: $tipoEmpleo) {
                                ForEach(tiposEmpleo, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .accentColor(Color(red: 0.25, green: 0.75, blue: 0.35))
                        }
                        
                        fieldWithLabel(label: "Departamento", isRequired: false) {
                            TextField("Selecciona departamento", text: $departamento)
                        }
                    }
                    
                    HStack {
                        fieldWithLabel(label: "Salario", isRequired: false) {
                            TextField("ej. $15,000 - $20,000", text: $salario)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Mensual")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Picker("", selection: $periodoSalario) {
                                ForEach(periodosSalario, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 8)
                            .frame(maxWidth: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .accentColor(Color(red: 0.25, green: 0.75, blue: 0.35))
                        }
                        .frame(width: 100)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Descripción del Empleo", isRequired: true)
                        TextEditor(text: $descripcion)
                            .frame(minHeight: 120)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                            .padding(.bottom, 4)
                        
                        Text("Describe las responsabilidades, actividades diarias y objetivos del puesto...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        fieldLabel("Requisitos para el Empleo", isRequired: true)
                        TextEditor(text: $requisitos)
                            .frame(minHeight: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    }
                    
                    Button(action: publicarVacante) {
                        HStack {
                            Spacer()
                            Text("Publicar Vacante")
                                .bold()
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding()
                        .background(formularioValido ? Color(red: 0.25, green: 0.75, blue: 0.35) : Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(!formularioValido)
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Publicar Vacante de Empleo")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                ubicacion = ubicacionesChiapas.first! 
            }
        }
    }
    
    private func publicarVacante() {
        let nuevaVacante = Vacante(
            idVacante: Int.random(in: 1000...9999),
            puesto: puesto,
            ubicacion: ubicacion,
            vacanteStatusTexto: "Activa",
            empresa: empresa,
            descripcion: descripcion,
            salario: salario.isEmpty ? "No especificado" : "\(salario) \(periodoSalario)",
            requisitos: requisitos
        )
        
        context.insert(nuevaVacante)
        
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error al guardar la vacante: \(error.localizedDescription)")
        }
    }
    
    
    @ViewBuilder
    private func fieldLabel(_ text: String, isRequired: Bool) -> some View {
        HStack(spacing: 0) {
            Text(text)
                .font(.subheadline).bold()
            if isRequired {
                Text("*")
                    .foregroundStyle(.red)
            }
        }
    }
    
    @ViewBuilder
    private func fieldWithLabel<Content: View>(label: String, isRequired: Bool, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            fieldLabel(label, isRequired: isRequired)
            
            content()
                .padding(.vertical, 12)
                .padding(.horizontal, 10)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
        }
    }
}

#Preview {
    PublicarVacanteView_Preview()
}

private func PublicarVacanteView_Preview() -> some View {
    do {
        let container = try ModelContainer.makeMercadoLaboralContainer(inMemory: true)
        
        let usuario = Usuario.comoEmpresa(
            idUsuario: 1,
            correo: "empresa@chiapas.com",
            nombre: "Empresa Chiapas S.A.",
            contrasenia: "123456",
            idEmpresa: 101,
            nombreEmpresa: "Empresa Chiapas S.A."
        )
        
        container.mainContext.insert(usuario)
        let empresaPerfil = usuario.empresa!
        
        return AnyView(
            PublicarVacanteView(empresa: empresaPerfil)
                .modelContainer(container)
        )

    } catch {
        return AnyView(
            Text("Error al crear contenedor: \(error.localizedDescription)")
        )
    }
}

