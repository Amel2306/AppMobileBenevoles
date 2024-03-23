//
//  Game.swift
//  appMobileBenevoles
//
//  Created by Amel  on 23/03/2024.
//

import Foundation


struct Game :Codable {
        let id: Int
        let nom_du_jeu: String
        let description: String
        let auteur : String
        let editeur : String
        let nb_joueurs : String
        let checkbox_joueur_age_min : String
        let duree : String
        let type : String
        let present : String
        let tags : String
        let recu : Bool
        let a_animer : String
        let image : String
        let logo: String
    }
    
