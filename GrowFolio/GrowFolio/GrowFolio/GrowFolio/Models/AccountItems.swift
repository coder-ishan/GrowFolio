//
//  AccountItems.swift
//  GrowFolio
//
//  Created by Ishan Singh on 27/09/25.
//



import Foundation

enum AuthState {
    case idle
    case inProgress
    case success(PayPalUser)
    case failure(String)
}

struct PayPalUser: Codable {
    let name: String?
    let email: String?
    let userId: String?
    let verified: Bool?
}
