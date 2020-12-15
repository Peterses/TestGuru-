//
//  ErrorsDescription.swift
//  TestGuru!
//
//  Created by Piotr Tocicki on 08/10/2020.
//

import Foundation

struct ErrorsDescription {
    
    static let error = "Błąd"
    static let emailInvalid = "Format Email jest nieprawidłowy"
    static let unknownError = "Nieznany błąd"
    static let emailAlreadyInUse = "Email jest już w użyciu."
    static let emailEmpty = "Puste pole Email."
    static let weakPassword = "Hasło jest za słabe - powinno mieć minimum 6 znaków."
    static let emailOrPasswordMissing = "Email lub hasło puste."
    static let wrongPassword = "Błędne hasło."
    static let userNotFound = "Nie znaleziono użytkownika."
    static let logoutError = "Błąd podczas wylogowywania."
    static let missingData = "Brakujące dane. Sprawdź czy pola wymagane nie są puste."
    static let testWithoutQuestions = "Nie możesz rozpocząć testu, który nie zawiera żadnych pytań."
}
