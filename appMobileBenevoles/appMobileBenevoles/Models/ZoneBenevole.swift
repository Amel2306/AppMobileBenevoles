//
//  ZoneBenevole.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation

struct Zonebenevole: Identifiable , Codable{
    let id: Int
    let nom_zb: String
    let zone_plan_id: Int?
    let festivale_id: Int
    let post_id: Int?

    // Relation avec ZonePlan
    let zonePlan: Zoneplan?

    // Relation avec Festivale
    let festivale: Festivale

    // Relation avec Post
    let post: Post?
}
