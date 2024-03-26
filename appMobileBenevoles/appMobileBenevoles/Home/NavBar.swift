//
//  NavBar.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation
import SwiftUI
struct NavBar: View {
    @State private var isLoggedIn = false
    
    
    var body: some View {
        TabView {
            // Premier onglet avec LoginView
            
            NavigationView {
                WelcomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
            }
            
            NavigationView {
                CalendarView()
            }
            .navigationTitle("Calendrier Bénévole")
            .tabItem {
                Image(systemName: "calendar")
            }
            
            NavigationView {
                JeuxView()
            }
            .tabItem {
                Image(systemName: "die.face.5")
            }

            if (isLoggedIn == false){
                NavigationView {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
                .tabItem {
                    Image(systemName: "ipad.and.arrow.forward")
                }
                
                // Deuxième onglet avec SignUpView
                NavigationView {
                    SignUpView(isLoggedIn: $isLoggedIn)
                }
                .tabItem {
                    Image(systemName: "person.badge.plus")
                }
            }else {
                NavigationView {
                    UserDetailsView()
                }
                .tabItem {
                    Image(systemName: "person")
                }
            }
        }
        .edgesIgnoringSafeArea(.top) // Pour éviter que la barre de statut ne chevauche les onglets
    }
}

