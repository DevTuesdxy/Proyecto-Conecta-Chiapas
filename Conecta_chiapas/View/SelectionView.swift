//
//  SelectionView.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 27/10/25.
//  Actualizado para replicar el estilo del Figma: Header + OnboardingRoleCard reusable
//

import SwiftUI

private extension Color {
    static let ccGreen = Color(hex: "#19A15E")
    static let ccBlue = Color(hex: "#2D7FF9")
    static let ccTextPrimary = Color(hex: "#111111")
    static let ccTextSecondary = Color(hex: "#666A6E")
    static let ccCardBorder = Color(hex: "#E6E6E6")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct BenefitItem: Identifiable, Hashable, Equatable {
    let id: UUID
    let systemIcon: String
    let text: String

    init(id: UUID = UUID(), systemIcon: String, text: String) {
        self.id = id
        self.systemIcon = systemIcon
        self.text = text
    }

    static func == (lhs: BenefitItem, rhs: BenefitItem) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CTAButton: Identifiable, Hashable, Equatable {
    enum Style {
        case prominent, bordered
    }
    let id: UUID
    let title: String
    let style: Style
    let action: () -> Void

    init(id: UUID = UUID(), title: String, style: Style, action: @escaping () -> Void) {
        self.id = id
        self.title = title
        self.style = style
        self.action = action
    }

    static func == (lhs: CTAButton, rhs: CTAButton) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct OnboardingRoleCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconTint: Color
    let benefits: [BenefitItem]
    var statLabel: String? = nil
    var statValue: String? = nil
    var ctas: [CTAButton] = []
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconTint.opacity(0.12))
                    .frame(width: 64, height: 64)
                Image(systemName: iconName)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(iconTint)
            }
            .accessibilityHidden(true)
            
            VStack(spacing: 6) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.ccTextPrimary)
                    .multilineTextAlignment(.center)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Color.ccTextSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            benefitsSection
            
            if let statLabel, let statValue {
                VStack(spacing: 2) {
                    Text(statLabel)
                        .font(.caption)
                        .foregroundStyle(Color.ccTextSecondary)
                    Text(statValue)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color.ccBlue)
                }
                .padding(.top, 4)
            }
            
            ctaSection
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.ccCardBorder, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
    
    @ViewBuilder
    private var benefitsSection: some View {
        if !benefits.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(benefits, id: \.id) { b in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: b.systemIcon)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(iconTint)
                            .frame(width: 18)
                            .padding(.top, 1)
                        Text(b.text)
                            .font(.footnote)
                            .foregroundStyle(Color.ccTextPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var ctaSection: some View {
        if !ctas.isEmpty {
            VStack(spacing: 10) {
                ForEach(ctas, id: \.id) { cta in
                    if cta.style == .prominent {
                        Button(cta.title, action: cta.action)
                            .buttonStyle(BorderedProminentButtonStyle())
                    } else {
                        Button(cta.title, action: cta.action)
                            .buttonStyle(BorderedButtonStyle())
                    }
                }
            }
            .padding(.top, 2)
        }
    }
}

struct ConectaHeader: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.ccGreen.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: "globe.americas.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.ccGreen)
            }
            VStack(alignment: .leading, spacing: -2) {
                Text("Conecta")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Color.ccTextPrimary)
                Text("Chiapas")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(Color.ccGreen)
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

struct SelectionView: View {
    private enum Route: Hashable {
        case login
    }
    
    @State private var goToLoginCandidato: Bool = false
    @State private var goToLoginEmpresa: Bool = false
    @State private var goToFormularioCandidato: Bool = false
    @State private var goToFormularioEmpresa: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ConectaHeader()
                    
                    VStack(spacing: 6) {
                        Text("¿Cómo quieres usar Conecta Chiapas?")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(Color.ccTextPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 4)
                    
                    VStack(spacing: 16) {
                    
                        OnboardingRoleCard(
                            title: "Busco empleo",
                            subtitle: "Conectamos a profesionales con oportunidades en Chiapas.",
                            iconName: "briefcase.fill",
                            iconTint: .ccGreen,
                            benefits: [
                                BenefitItem(systemIcon: "list.bullet.rectangle.fill", text: "Acceso a oportunidades laborales locales"),
                                BenefitItem(systemIcon: "person.2.fill", text: "Conexión con empresas chiapanecas"),
                                BenefitItem(systemIcon: "person.text.rectangle.fill", text: "Perfil profesional visible y verificable")
                            ],
                            statLabel: nil,
                            statValue: nil,
                            ctas: [
                                CTAButton(title: "Crear mi perfil", style: .prominent, action: { navigateToFormularioCandidato() }),
                                CTAButton(title: "Ya tengo cuenta", style: .bordered, action: { navigateToLoginCandidato() })
                            ]
                        )
                        
                        OnboardingRoleCard(
                            title: "Busco talento",
                            subtitle: "Encuentra y conecta con el mejor talento profesional de Chiapas.",
                            iconName: "person.3.fill",
                            iconTint: .ccBlue,
                            benefits: [
                                BenefitItem(systemIcon: "checkmark.seal.fill", text: "Talento verificado con credenciales"),
                                BenefitItem(systemIcon: "briefcase.fill", text: "Vacantes y aplicaciones en un solo lugar"),
                                BenefitItem(systemIcon: "chart.line.uptrend.xyaxis", text: "Atrae perfiles alineados a tu empresa")
                            ],
                            statLabel: "Profesionales activos",
                            statValue: "25,643+",
                            ctas: [
                                CTAButton(title: "Crear cuenta empresa", style: .prominent, action: {navigateToFormularioEmpresa() }),
                                CTAButton(title: "Ya tengo cuenta", style: .bordered, action: { navigateToLoginEmpresa() })
                            ]
                        )
                    }
                
                    .padding(.horizontal)
                    Spacer(minLength: 16)
                }
                .padding(.vertical, 12)
                .background(Color(.systemGroupedBackground))
            }
            .navigationDestination(isPresented: $goToLoginCandidato) {
                LoginCandidatoView()
            }
            .navigationDestination(isPresented: $goToLoginEmpresa){
                LoginView()
            }
            .navigationDestination(isPresented: $goToFormularioCandidato) {
                FormularioCandidatoView()
            }
            .navigationDestination(isPresented: $goToFormularioEmpresa){
                FormularioEmpresaView()
            }
        }
    }
    
    private func navigateToLoginCandidato() {
        goToLoginCandidato = true
    }

    private func navigateToLoginEmpresa() {
        goToLoginEmpresa = true
    }

    private func navigateToFormularioCandidato() {
        goToFormularioCandidato = true
    }

    private func navigateToFormularioEmpresa() {
        goToFormularioEmpresa = true
    }
}

#Preview {
    SelectionView()
}

