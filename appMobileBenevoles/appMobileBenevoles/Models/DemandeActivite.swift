//
//  DemandeActivite.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation

struct DemanderActivite: Identifiable {
    var id: Int
    var accepte: Int
    var archive: Int
    var user: User
    var zonebenevole: Zonebenevole
    var creneau: Creneau
}
