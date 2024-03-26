//
//  CalendarJeuxView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 23/03/2024.
//

import Foundation
import SwiftUI

class ContentCalendarJeuViewModel: ObservableObject {
    @Published var selectedDay = "Samedi"
    @Published var selectedMoment = "Journée"
    @Published var selectedActivity: String = "Toutes"
    @Published var isNextButtonEnabled = false
    @Published var espaces: [Zonebenevole] = []
    @Published var horaires : [Creneau] = []
    @Published var tabEspaceHoraire = [Int: [[DemanderActivite]]]()
    @Published var tabEspaceNbMax = [Int: [Int: Int]]()
    
    
    @State private var selectedSlot = [(Int, Int)]()
    @State private var chooseJeuZone = false
    @State private var i = 0
    
    var columns: [GridItem] = []

    var body: some View {
        VStack {
            // Contenu de votre vue ici
        }
        .onAppear {
            self.fetchPosts()
            self.fetchHoraires()
            self.fetchData()
            self.fetchData1()
        }
    }
    
    func fetchPosts() {
        guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/zonebenevole/post/2") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.espaces = try decoder.decode([Zonebenevole].self, from: data)
                print("Espaceeees" ,self.espaces)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    func fetchHoraires() {
        guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/creneaux") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.horaires = try decoder.decode([Creneau].self, from: data)
                print("CREEENEAU", self.horaires)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    func fetchData() {
        var updatedTabEH = [Int: [[DemanderActivite]]]()
        

        // Boucle à travers chaque post pour récupérer les données de demande
        for zone in espaces {
            var tabH = [[DemanderActivite]]() // Déclaration de tabH à l'extérieur de la boucle horaire
            // Boucle à travers chaque horaire pour récupérer les données de demande
            for horaire in horaires {

                let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/demanderactivtie/zoneCreneau/\(zone.id)/\(horaire.id)")!
                URLSession.shared.dataTask(with: url) { data, _, error in
                    do {
                        // Vérifiez s'il y a une erreur lors de la récupération des données
                        if let error = error {
                            throw error
                        }

                        // Vérifiez si des données ont été reçues
                        guard let data = data else {
                            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        }

                        // Décodez les données en utilisant la structure DemanderActivite
                        do {
                            let decodedData = try JSONDecoder().decode([DemanderActivite].self, from: data)
                            tabH.append(decodedData)
                        } catch {
                            print("Error fetching or decoding data:", error)
                        }
                    } catch {
                        // Gérez les erreurs de décodage ou de récupération des données
                        print("Error fetching or decoding data:", error)
                    }
                }.resume()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                updatedTabEH[zone.id] = tabH
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tabEspaceHoraire = updatedTabEH
            print(self.tabEspaceHoraire)
        }

    }

    func fetchData1() {
        var updatedTabEH = [Int: [Int: Int]]()

        // Boucle à travers chaque post pour récupérer les données de demande
        for zone in espaces {
            var tabNbMax = [Int: Int]() // Déclaration de tabH à l'extérieur de la boucle horaire
            // Boucle à travers chaque horaire pour récupérer les données de demande
            for horaire in horaires {
                tabNbMax[horaire.id] = 0
                let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/creneauespace/\(horaire.id)/\(zone.id)")!
                URLSession.shared.dataTask(with: url) { data, _, error in
                    do {
                        // Vérifiez s'il y a une erreur lors de la récupération des données
                        if let error = error {
                            throw error
                        }

                        // Vérifiez si des données ont été reçues
                        guard let data = data else {
                            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        }

                        // Décodez les données en utilisant la structure DemanderActivite
                        do {
                            let decodedData = try JSONDecoder().decode(CreneauEspace.self, from: data)
                            if (decodedData.nb_benevoles_max != nil) {
                                tabNbMax[horaire.id] = decodedData.nb_benevoles_max
                                print ("::::::::", decodedData)
                            }

                        } catch {
                            print("Error fetching or decoding data:", error)
                        }
                    } catch {
                        // Gérez les erreurs de décodage ou de récupération des données
                        print("Error fetching or decoding data:", error)
                    }
                }.resume()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                updatedTabEH[zone.id] = tabNbMax
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tabEspaceNbMax = updatedTabEH
            print(updatedTabEH)
        }

    }

    func getColorForPercentage(_ percentage: Double) -> Color {
        return Color.red
    }

    func handleSlotClick(postId: Int, slotIndex: Int) {
        // Logique pour gérer le clic sur un créneau
        // Mettre à jour la sélection de créneaux
    }

    func handleSendDemande() {
        // Logique pour envoyer la demande
        // Naviguer vers une autre vue si nécessaire
    }
    
    init() {
        // Initialisez les colonnes en fonction de vos besoins
        // Ici, nous utilisons des colonnes flexibles avec une largeur égale
        columns = Array(repeating: .init(.flexible()), count: horaires.count)
    }
}

struct CalendarJeuView: View {
    @StateObject var viewModel = ContentCalendarJeuViewModel()
    @State private var selectedZoneId: Int? // Stocker l'ID de la zone sélectionnée
    @State private var selectedCreneauId: Int? // Stocker l'ID de la zone sélectionnée
    @State private var selectedCreneauDetails: String = ""// Stocker l'ID de la zone sélectionnée
    @State private var selectedZoneDetails: String = ""// Stocker l'ID de la zone sélectionnée
    @State private var isRegistered = false // État pour suivre le statut d'inscription
    @State private var selectedCreneau: Creneau? // Stocker le créneau sélectionné


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Titre")
                ForEach(viewModel.horaires, id: \.self) { creneau in
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Button(action: {
                            selectedCreneau = creneau == selectedCreneau ? nil : creneau
                        }) {
                            Text("\(creneau.date == "2024-03-23" ? "Samedi" : "Dimanche") : \(String(creneau.horaire_debut.prefix(5)))-\(String(creneau.horaire_fin.prefix(5)))")
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        // Afficher les détails de chaque espace dans le créneau sélectionné
                        if selectedCreneau == creneau {
                            ForEach(viewModel.espaces, id: \.self) { zone in
                                Text("\(zone.nom_zb)")
                                let zoneId = zone.id
                                let horaireId = creneau.id
                                let demandeCount = viewModel.tabEspaceHoraire[zoneId]?[horaireId-1].count ?? 0
                                let maxCount = viewModel.tabEspaceNbMax[zoneId]?[horaireId] ?? 0
                                let ratio = maxCount > 0 ? Double(demandeCount) / Double(maxCount) : 0.0
                                let fillColor: Color = ratio > 0.75 ? .red : (ratio > 0.5 ? .orange : .green)

                                Button (action: {
                                    selectedZoneId = zoneId
                                    selectedCreneauId = horaireId
                                    selectedZoneDetails = zone.nom_zb
                                    selectedCreneauDetails = "\(creneau.date == "2024-03-23" ? "Samedi" : "Dimanche") : \(String(creneau.horaire_debut.prefix(5)))-\(String(creneau.horaire_fin.prefix(5)))"
                                    isRegistered = true
                                }) {
                                    Text("\(demandeCount)/\(maxCount)")
                                        .frame(maxWidth: .infinity)
                                        .padding(8)
                                        .background(fillColor.opacity(0.5))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $isRegistered) {
            // Afficher la feuille modale pour le détail de l'inscription
            NextPageView(creneauId: selectedCreneauId ?? 1, zoneId: selectedZoneId, activite: "Animation jeu", creneauDetails: selectedCreneauDetails , zoneDetails: selectedZoneDetails)
        }
        .onAppear {
            viewModel.fetchPosts()
            viewModel.fetchHoraires()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.fetchData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                viewModel.fetchData1()
            }
        }
    }
}


#Preview {
    CalendarJeuView()
}


