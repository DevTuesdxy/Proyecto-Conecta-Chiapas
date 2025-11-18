//
//  LoginCandidatoView.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 17/11/25.
//

import SwiftUI
import SwiftData

struct LoginCandidatoView: View {
    @Environment(SessionManager.self) var session
    @Environment(\.modelContext) private var context

    @Query private var usuarios: [Usuario]

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var loginError: String?
    @State private var navegarAlMenu: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        HStack(alignment: .center, spacing: 12) {
                            ZStack {
                                Circle().fill(Color(.systemGreen)).frame(width: 44, height: 44)
                                Image(systemName: "leaf.fill")
                                    .foregroundStyle(.white)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Conecta")
                                    .font(.title2).bold()
                                Text("Chiapas")
                                    .font(.subheadline)
                                    .foregroundStyle(.green)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        VStack(alignment: .leading, spacing: 20) {
                            Button(action: { }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                    Text("Volver al inicio")
                                }
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(.secondary)

                            VStack(spacing: 6) {
                                Text("Iniciar Sesión")
                                    .font(.title2).bold()
                                    .foregroundStyle(.primary)
                                Text("Accede a tu cuenta de candidato")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email")
                                    .font(.subheadline).bold()
                                    .foregroundStyle(.primary)
                                HStack(spacing: 8) {
                                    TextField("tu@email.com", text: $email)
                                        .textContentType(.emailAddress)
                                        .keyboardType(.emailAddress)
                                        .textInputAutocapitalization(.never)
                                        .autocorrectionDisabled(true)
                                }
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            }

                            VStack(alignment: .leading, spacing: 8) {
                                Text("Contraseña")
                                    .font(.subheadline).bold()
                                    .foregroundStyle(.primary)
                                HStack(spacing: 8) {
                                    Group {
                                        if isPasswordVisible {
                                            TextField("Tu contraseña", text: $password)
                                        } else {
                                            SecureField("Tu contraseña", text: $password)
                                        }
                                    }
                                    Button(action: { isPasswordVisible.toggle() }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding(14)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            }

                            Button(action: iniciarSesionCandidato) {
                                Text("Iniciar Sesión")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.plain)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color(.systemGreen))
                            )
                            .foregroundStyle(.white)
                            .shadow(color: Color(.systemGreen).opacity(0.25), radius: 6, y: 2)
                            
                            if let loginError {
                                Text(loginError)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }

                            NavigationLink(destination: MenuView(),
                                           isActive: $navegarAlMenu) {
                                EmptyView()
                            }
                            .hidden()
                            
                            Button(action: { }) {
                                Text("¿Olvidaste tu contraseña?")
                                    .font(.subheadline)
                            }
                            .buttonStyle(.plain)
                            .foregroundStyle(Color(.systemGreen))
                            .frame(maxWidth: .infinity)

                            HStack(spacing: 12) {
                                Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                                Text("o")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Rectangle().fill(Color.secondary.opacity(0.2)).frame(height: 1)
                            }

                            HStack(spacing: 4) {
                                Text("¿No tienes cuenta?")
                                    .foregroundStyle(.secondary)
                                NavigationLink(destination: FormularioCandidatoView()) {
                                    Text("Regístrate aquí")
                                        .bold()
                                }
                                .buttonStyle(.plain)
                                .foregroundStyle(Color(.systemGreen))
                            }
                            .font(.subheadline)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.background)
                                .shadow(color: .black.opacity(0.06), radius: 16, x: 0, y: 8)
                        )
                        .padding(.horizontal)

                        Spacer(minLength: 20)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
        
    private func iniciarSesionCandidato() {
        let correo = email.lowercased().trimmingCharacters(in: .whitespaces)
        
        guard let usuario = usuarios.first(where: { $0.correo == correo }) else {
            loginError = "No existe una cuenta de candidato con este email."
            return
        }
        
        guard usuario.tipo == .candidato else {
            loginError = "Este usuario no es candidato. Usa el acceso de empresa."
            return
        }

        guard usuario.contrasenia == password else {
            loginError = "La contraseña es incorrecta."
            return
        }

        session.guardarSesion(usuario)
        loginError = nil
        navegarAlMenu = true
    }
}


//#Preview {
//    LoginCandidatoView()
//}
