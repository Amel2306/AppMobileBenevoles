//
//  DemandeActivite.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//


struct DemanderActivite: Codable {
    let id: Int
    let creneau_id: Int
    let zonebenevole_id: Int
    let user_id: Int
    let accepte: Int
    let archive: Int
}
