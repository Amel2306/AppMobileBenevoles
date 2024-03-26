//
//  GameDetailsView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 26/03/2024.
//

import Foundation
import SwiftUI
// Vue pour afficher les détails d'un jeu
struct GameDetailView: View {
    let game: Game
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Affichage de toutes les informations sur le jeu
                AsyncImage(url: URL(string: game.image), width: 200, height: 200) {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                .cornerRadius(8)
                
                Group {
                    Text("Description: \(game.description)")
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.green]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.15)
                )
                .cornerRadius(10)
                .shadow(radius: 3)
                
                Group{
                        Text("Auteur: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        Text(game.auteur)

                        Text("Editeur: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        Text(game.editeur)
                    Text("Type: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.type)
                    
                    Group{
                        Text("Tags : \(game.tags)")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                        Divider()
                        Text("Nombre de joueurs: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        Text(game.nb_joueurs)

                    
                }
                
                Group {
                        Text("Age minimum des joueurs: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                             Text(game.checkbox_joueur_age_min)
                    Text("Durée: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.duree)
                    Divider()


                    Text("Présent: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.present)

                }
                
                Group {
                    Text("Reçu: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.recu ? "Oui" : "Non")

                    Text("A animer: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.a_animer)

                }
                
            }
            .padding()
            .navigationTitle(game.nom_du_jeu)
        }
            
    }
}
