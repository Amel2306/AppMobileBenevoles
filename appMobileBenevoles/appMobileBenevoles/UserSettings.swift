//
//  UserSettings.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation
import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var user: User?
    
    init() {
    }
}
