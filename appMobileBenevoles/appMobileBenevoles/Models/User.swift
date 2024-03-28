//
//  User.swift
//  appMobileBenevoles
//
//  Created by Amel  on 18/03/2024.
//

import Foundation

struct User: Codable {
    let id: Int
    var nom: String
    var prenom: String
    let email: String
    let numero_tel: String?  // Déclarer comme optionnel
    var pseudo: String
    let biographie: String?
    let role: String?
    let password: String
    let cherche_hebergement: Int
    let propose_hebergement: String?
    let taille: String?
    let association_id: String?
    let createdAt: String
    let updatedAt: String
}
