//
//  validEmail.swift
//  Conecta_chiapas
//
//  Created by Alan Cervantes on 17/11/25.
//

import Foundation

public func isValidEmail(_ email: String) -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

public func isValidCurp(_ curp: String) -> Bool {
    let curpRegex = "^[A-Z]{4}[0-9]{6}[HM][A-Z]{2}[B-DF-HJ-NP-TV-Z]{3}[0-9A-Z]{1}[0-9]{1}$"
    let curpPredicate = NSPredicate(format:"SELF MATCHES %@", curpRegex)
    return curpPredicate.evaluate(with: curp)
}
