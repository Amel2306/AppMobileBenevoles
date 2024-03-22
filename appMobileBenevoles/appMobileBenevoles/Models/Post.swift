//
//  Post.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation

struct Post : Decodable {
    var id: Int
    var nom_post: String
    var description: String
    var createdAt : String
    var updatedAt : String
}
