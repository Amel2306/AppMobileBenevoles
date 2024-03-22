//
//  UserDetailsView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 13/03/2024.
//

import Foundation
import SwiftUI

struct UserDetailsView: View {
    @EnvironmentObject var userSettings: UserSettings

    var body: some View {
        VStack {
            Text("Bienvenue, \(userSettings.user?.prenom ?? "")")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Image(systemName: "person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding()
            
            Divider()
            
            Group {
                Text("Nom: \(userSettings.user?.nom ?? "")")
                Text("Prénom: \(userSettings.user?.prenom ?? "")")
                Text("Email: \(userSettings.user?.email ?? "")")
            }
            .font(.headline)
            .padding()
            
            Spacer()
        }
        .navigationBarTitle("Profil")
    }
}
