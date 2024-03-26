
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
                PostAndJeuxView() // Utilisation de la vue personnalisée pour les jeux et les informations sur les postes
            }
            .tabItem {
                Image(systemName: "info.circle")
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
            } else {
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

struct SelectedTab: Identifiable {
    let id = UUID()
    let item: String
}

struct PostAndJeuxView: View {
    @State private var showInfos = false
    @State private var selectedTab: SelectedTab? // Stocker l'élément sélectionné

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                showInfos = true
                selectedTab = SelectedTab(item: "infos")
            }) {
                Text("Information Post")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            Button(action: {
                showInfos = false // Assurez-vous de réinitialiser la variable lorsque vous changez d'onglet
                selectedTab = SelectedTab(item: "jeux")
            }) {
                Text("Jeux")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .sheet(item: $selectedTab) { selected in
            NavigationView { // Utilisez NavigationView pour obtenir un bouton de retour automatique
                if selected.item == "infos" {
                    PostsListView()
                } else {
                    JeuxView()
                }
            }
        }
    }
}
