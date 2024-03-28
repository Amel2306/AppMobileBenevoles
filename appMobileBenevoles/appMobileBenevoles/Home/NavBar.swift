
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
                Text("Informations Activité")
                    .padding()
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .frame(width: 300, height: 50)
                    .background(Color.green
                        .opacity(0.5))
                    .cornerRadius(8)
            }
            Button(action: {
                showInfos = false // Assurez-vous de réinitialiser la variable lorsque vous changez d'onglet
                selectedTab = SelectedTab(item: "jeux")
            }) {
                Text("Informations Jeux")
                    .padding()
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .frame(width: 300, height: 50)
                    .background(Color.purple
                        .opacity(0.5))
                    .cornerRadius(8)
            }
            Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.green]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 400, height: 400)
                        .opacity(0.4)
                        .offset(y: 300)
        }
        .sheet(item: $selectedTab) { selected in
            NavigationView {
                if selected.item == "infos" {
                    PostsListView()
                } else {
                    JeuxView()
                }
            }
        }
    }
}
