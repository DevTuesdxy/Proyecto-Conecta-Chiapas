//
//  ModelData.swift
//  Conecta_chiapas
//
//  Created by Martín Emmanuel Erants Solórzano on 20/10/25.
//
// Conecta Chiapas - Mercado Laboral (SwiftData con especialización de Usuario)

import Foundation
import SwiftData

// MARK: - Catálogos

@Model
final class UsuarioEstatus {
    @Attribute(.unique) var idUsuarioEstatus: Int
    var descripcion: String

    @Relationship(inverse: \Usuario.estatus)
    var usuarios: [Usuario] = []

    init(idUsuarioEstatus: Int, descripcion: String) {
        self.idUsuarioEstatus = idUsuarioEstatus
        self.descripcion = descripcion
    }
}

@Model
final class VacanteStatus {
    @Attribute(.unique) var idVacanteStatus: Int
    var descripcion: String   // D_VACANTE

    @Relationship(inverse: \Vacante.statusCatalogo)
    var vacantes: [Vacante] = []

    init(idVacanteStatus: Int, descripcion: String) {
        self.idVacanteStatus = idVacanteStatus
        self.descripcion = descripcion
    }
}

// MARK: - Usuario (base) + Especializaciones 1:1

enum UsuarioTipo: String, Codable, CaseIterable {
    case candidato, empresa
}

@Model
final class Usuario {
    @Attribute(.unique) var idUsuario: Int
    var nombre: String
    @Attribute(.unique) var correo: String
    var telefono: String?
    var contrasenia: String
    var fechaRegistro: Date
    var tipo: UsuarioTipo?         // ayuda para UI/validación (opcional)

    // Estatus catálogo
    @Relationship(deleteRule: .nullify) var estatus: UsuarioEstatus?

    // Especializaciones (1:1)
    @Relationship(deleteRule: .cascade, inverse: \CandidatoPerfil.usuario)
    var candidato: CandidatoPerfil?
    @Relationship(deleteRule: .cascade, inverse: \EmpresaPerfil.usuario)
    var empresa: EmpresaPerfil?

    // Notificaciones (1:N)
    @Relationship(deleteRule: .cascade, inverse: \Notificacion.usuario)
    var notificaciones: [Notificacion] = []

    init(idUsuario: Int,
         nombre: String,
         correo: String,
         telefono: String? = nil,
         contrasenia: String,
         fechaRegistro: Date = .now,
         tipo: UsuarioTipo? = nil,
         estatus: UsuarioEstatus? = nil) {
        self.idUsuario = idUsuario
        self.nombre = nombre
        self.correo = correo.lowercased()
        self.telefono = telefono
        self.contrasenia = contrasenia
        self.fechaRegistro = fechaRegistro
        self.tipo = tipo
        self.estatus = estatus
    }
}

// PERFIL Candidato (especialización de Usuario)
@Model
final class CandidatoPerfil {
    // Clave legada del SQL (opcional) para interoperar
    @Attribute(.unique) var idCandidato: Int?

    // 1:1 con Usuario
    @Relationship(deleteRule: .nullify) var usuario: Usuario?

    // Campos del SQL CANDIDATO
    var nombre: String?
    var apPaterno: String?
    var apMaterno: String?
    var rfc: String?
    var curp: String?
    var nacionalidad: String?
    var fechaNacimiento: Date?

    // Postulaciones (1:N)
    @Relationship(deleteRule: .cascade, inverse: \DetalleVacantePostulacion.candidato)
    var postulaciones: [DetalleVacantePostulacion] = []

    init(idCandidato: Int? = nil,
         usuario: Usuario? = nil,
         nombre: String? = nil,
         apPaterno: String? = nil,
         apMaterno: String? = nil,
         rfc: String? = nil,
         curp: String? = nil,
         nacionalidad: String? = nil,
         fechaNacimiento: Date? = nil) {
        self.idCandidato = idCandidato
        self.usuario = usuario
        self.nombre = nombre
        self.apPaterno = apPaterno
        self.apMaterno = apMaterno
        self.rfc = rfc
        self.curp = curp
        self.nacionalidad = nacionalidad
        self.fechaNacimiento = fechaNacimiento
    }
}

// PERFIL Empresa (especialización de Usuario)
@Model
final class EmpresaPerfil {
    // Clave legada del SQL (opcional)
    @Attribute(.unique) var idEmpresa: Int?

    // 1:1 con Usuario
    @Relationship(deleteRule: .nullify) var usuario: Usuario?

    // Campos del SQL EMPRESA
    var nombreEmpresa: String?
    var razonSocial: String?
    var sectorComercial: String?
    var direccion: String?
    var rfc: String?
    var contacto: String?

    // Vacantes (1:N)
    @Relationship(deleteRule: .cascade, inverse: \Vacante.empresa)
    var vacantes: [Vacante] = []

    init(idEmpresa: Int? = nil,
         usuario: Usuario? = nil,
         nombreEmpresa: String? = nil,
         razonSocial: String? = nil,
         sectorComercial: String? = nil,
         direccion: String? = nil,
         rfc: String? = nil,
         contacto: String? = nil) {
        self.idEmpresa = idEmpresa
        self.usuario = usuario
        self.nombreEmpresa = nombreEmpresa
        self.razonSocial = razonSocial
        self.sectorComercial = sectorComercial
        self.direccion = direccion
        self.rfc = rfc
        self.contacto = contacto
    }
}

// MARK: - Notificación

@Model
final class Notificacion {
    @Attribute(.unique) var idNotificacion: Int
    @Relationship(deleteRule: .nullify) var usuario: Usuario?
    var mensaje: String
    var fecha: Date
    var notificacionEstatus: String

    init(idNotificacion: Int,
         usuario: Usuario? = nil,
         mensaje: String,
         fecha: Date = .now,
         notificacionEstatus: String) {
        self.idNotificacion = idNotificacion
        self.usuario = usuario
        self.mensaje = mensaje
        self.fecha = fecha
        self.notificacionEstatus = notificacionEstatus
    }
}

// MARK: - Vacantes y Postulaciones

@Model
final class Vacante {
    @Attribute(.unique) var idVacante: Int
    var puesto: String
    var fecha: Date
    var ubicacion: String?
    var vacanteStatusTexto: String?   // compat. con SQL (texto libre)
    var descripcion: String?
    var salario: String?
    var requisitos: String?

    // Dueño: EmpresaPerfil
    @Relationship(deleteRule: .nullify) var empresa: EmpresaPerfil?

    // Catálogo status
    @Relationship(deleteRule: .nullify) var statusCatalogo: VacanteStatus?

    // Postulaciones (1:N)
    @Relationship(deleteRule: .cascade, inverse: \DetalleVacantePostulacion.vacante)
    var postulaciones: [DetalleVacantePostulacion] = []

    init(idVacante: Int,
         puesto: String,
         fecha: Date = .now,
         ubicacion: String? = nil,
         vacanteStatusTexto: String? = nil,
         empresa: EmpresaPerfil? = nil,
         descripcion: String? = nil,
         salario: String? = nil,
         requisitos: String? = nil,
         statusCatalogo: VacanteStatus? = nil) {
        self.idVacante = idVacante
        self.puesto = puesto
        self.fecha = fecha
        self.ubicacion = ubicacion
        self.vacanteStatusTexto = vacanteStatusTexto
        self.empresa = empresa
        self.descripcion = descripcion
        self.salario = salario
        self.requisitos = requisitos
        self.statusCatalogo = statusCatalogo
    }
}

@Model
final class DetalleVacantePostulacion {
    @Attribute(.unique) var idDetallePostulacion: Int
    @Relationship(deleteRule: .nullify) var vacante: Vacante?
    @Relationship(deleteRule: .nullify) var candidato: CandidatoPerfil?
    var descripcionPostulacion: String?

    init(idDetallePostulacion: Int,
         vacante: Vacante? = nil,
         candidato: CandidatoPerfil? = nil,
         descripcionPostulacion: String? = nil) {
        self.idDetallePostulacion = idDetallePostulacion
        self.vacante = vacante
        self.candidato = candidato
        self.descripcionPostulacion = descripcionPostulacion
    }
}

// MARK: - Helpers opcionales

extension Schema {
    static var mercadoLaboral: Schema {
        Schema([
            UsuarioEstatus.self,
            VacanteStatus.self,
            Usuario.self,
            CandidatoPerfil.self,
            EmpresaPerfil.self,
            Notificacion.self,
            Vacante.self,
            DetalleVacantePostulacion.self
        ])
    }
}

extension ModelContainer {
    static func makeMercadoLaboralContainer(inMemory: Bool = false) throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(for: .mercadoLaboral, configurations: config)
    }
}

// MARK: - Fábricas para asegurar la especialización 1:1

extension Usuario {
    static func comoCandidato(idUsuario: Int,
                              correo: String,
                              nombre: String,
                              idCandidato: Int? = nil) -> Usuario {
        let u = Usuario(idUsuario: idUsuario,
                        nombre: nombre,
                        correo: correo,
                        contrasenia: "hash",
                        tipo: .candidato)
        let perfil = CandidatoPerfil(idCandidato: idCandidato, usuario: u, nombre: nombre)
        u.candidato = perfil
        return u
    }

    static func comoEmpresa(idUsuario: Int,
                            correo: String,
                            nombre: String,
                            idEmpresa: Int? = nil,
                            nombreEmpresa: String? = nil) -> Usuario {
        let u = Usuario(idUsuario: idUsuario,
                        nombre: nombre,
                        correo: correo,
                        contrasenia: "hash",
                        tipo: .empresa)
        let perfil = EmpresaPerfil(idEmpresa: idEmpresa, usuario: u, nombreEmpresa: nombreEmpresa ?? nombre)
        u.empresa = perfil
        return u
    }
}
