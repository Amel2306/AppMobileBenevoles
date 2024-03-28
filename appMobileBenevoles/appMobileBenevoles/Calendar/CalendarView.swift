//
//  CalendarJeuxView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 23/03/2024.
//

import Foundation
import SwiftUI

class ContentCalendarViewModel: ObservableObject {
    @Published var isNextButtonEnabled = false
    @Published var posts: [Post] = []
    @Published var horaires : [Creneau] = []
    @Published var horairesSamedi : [Creneau] = []
    @Published var horaireDimanche : [Creneau] = []
    @Published var isPostsFetched = false
    @Published var isHorairesFetched = false
    @Published var tabPostHoraire = [Int: [[DemanderActivite]]]()
    @Published var tabPostNbMax = [Int: [Int: Int]]()
    
    
    @State private var selectedSlot = [(Int, Int)]()
    @State private var chooseJeuZone = false
    @State private var i = 0

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
        guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/post") else {
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
                self.posts = try decoder.decode([Post].self, from: data)
                self.isPostsFetched = true
                print(self.isPostsFetched)
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
                let allHoraires = try decoder.decode([Creneau].self, from: data)
                self.horairesSamedi = allHoraires.filter { $0.date == "2024-03-23" }
                self.horaireDimanche = allHoraires.filter { $0.date != "2024-03-23" }
              
                self.isHorairesFetched = true
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    func fetchData() {
        var updatedTabPH = [Int: [[DemanderActivite]]]()
        
        guard isPostsFetched && isHorairesFetched else {
            print("Posts or horaires data not fetched yet")
            return
        }

        for post in posts {
            var tabH = [[DemanderActivite]]()
            for horaire in horaires {

                let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/demanderactivtie/postCreneau/\(post.id)/\(horaire.id)")!
                URLSession.shared.dataTask(with: url) { data, _, error in
                    do {
                        if let error = error {
                            throw error
                        }

                        guard let data = data else {
                            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                        }

                        do {
                            let decodedData = try JSONDecoder().decode([[DemanderActivite]].self, from: data)
                            tabH.append(contentsOf: decodedData)
                        } catch {
                            print("Error fetching or decoding data:", error)
                        }
                    } catch {
                        print("Error fetching or decoding data:", error)
                    }
                }.resume()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                updatedTabPH[post.id] = tabH
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tabPostHoraire = updatedTabPH
            print(self.tabPostHoraire)
        }

    }

    func fetchData1() {
        var updatedTabPH = [Int: [Int: Int]]()
        
        // Vérifiez si les données des posts et des horaires ont été récupérées avec succès
        guard isPostsFetched && isHorairesFetched else {
            print("Posts or horaires data not fetched yet")
            return
        }

        // Boucle à travers chaque post pour récupérer les données de demande
        for post in posts {
            var tabNbMax = [Int: Int]() // Déclaration de tabH à l'extérieur de la boucle horaire
            // Boucle à travers chaque horaire pour récupérer les données de demande
            for horaire in horaires {
                tabNbMax[horaire.id] = 0
                let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/creneauespace/post/\(post.id)/\(horaire.id)")!
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
                            let decodedData = try JSONDecoder().decode([[CreneauEspace]].self, from: data)
                            for array in decodedData {
                                for element in array {
                                    if (tabNbMax[horaire.id] != nil) {
                                        tabNbMax[horaire.id]! += element.nb_benevoles_max!
                                    }
                                }
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
                updatedTabPH[post.id] = tabNbMax
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.tabPostNbMax = updatedTabPH
        }

    }
    
}

struct CalendarView: View {
    @StateObject var viewModel = ContentCalendarViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                Text("Calendrier inscription")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                VStack(alignment: .leading) {
                    SectionViewCalendar(title: "Samedi", horaires: viewModel.horairesSamedi, viewModel: viewModel)
                    SectionViewCalendar(title: "Dimanche", horaires: viewModel.horaireDimanche, viewModel: viewModel)
                }
                .padding()
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
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.green]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.20)
            )
        }
    }
}

struct SectionViewCalendar: View {
    let title: String
    let horaires: [Creneau]
    @ObservedObject var viewModel: ContentCalendarViewModel // Passer le viewModel partagé

    @State private var selectedCreneau: Creneau? // Stocker le créneau sélectionné
    @State private var selectedPost: Post? // Stocker le post sélectionné
    @State private var selectedCreneauId: Int? // Stocker l'ID du créneau sélectionné
    @State private var selectedCreneauDetails: String = "" // Stocker l'ID du créneau sélectionné
    @State private var selectedZoneId: Int? // Stocker l'ID du créneau sélectionné
    @State private var showAlert : Bool = false;

    
    @State private var selectedSlot = [(Int, Int)]()
    @State private var chooseJeuZone = false
    @State private var i = 0
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 8)

            ForEach(self.horaires, id: \.self) { creneau in
                VStack(alignment: .leading, spacing: 8) {
                    Button(action: {
                        // Changer le créneau sélectionné lorsqu'on appuie sur le bouton
                        selectedCreneau = creneau == selectedCreneau ? nil : creneau
                        selectedCreneauId = selectedCreneau?.id
                        selectedCreneauDetails = "\(creneau.date == "2024-03-23" ? "Samedi" : "Dimanche") : \(String(creneau.horaire_debut.prefix(5)))-\(String(creneau.horaire_fin.prefix(5)))"
                        selectedPost = nil // Réinitialiser le post sélectionné lorsque le créneau est sélectionné
                    }) {
                        Text(" \(String(creneau.horaire_debut.prefix(5)))-\(String(creneau.horaire_fin.prefix(5)))")
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    if selectedCreneau == creneau {
                        ForEach(viewModel.posts, id: \.self) { post in
                            let postId = post.id
                            VStack(alignment: .leading, spacing: 8) {
                                Text(post.nom_post)
                                    .fontWeight(.semibold)
                                let horaireId = creneau.id
                                let zoneId = 0

                                let demandeCount = viewModel.tabPostHoraire[postId]?[horaireId-1].count ?? 0
                                let maxCount = viewModel.tabPostNbMax[postId]?[horaireId] ?? 0
                                let ratio = maxCount > 0 ? Double(demandeCount) / Double(maxCount) : 0.0
                                let colors: Color = {
                                    switch ratio {
                                    case 0.0 :
                                        return Color.white
                                    case ..<0.25:
                                        return Color.green
                                    case 0.25..<0.50:
                                        return Color.yellow
                                    case 0.50..<0.75:
                                        return Color.orange
                                    case 0.75...:
                                        return Color.red
                                    default:
                                        return Color.white

                                    }
                                }()
                                let fillColor: Color = colors

                                if post.nom_post == "Animation jeux" {
                                    Button(action: {
                                        selectedPost = post
                                    }) {
                                        Text("\(demandeCount)/\(maxCount)")
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(fillColor.opacity(0.3))
                                            .cornerRadius(8)
                                            .padding(.horizontal, 30)
                                            .foregroundColor(Color.black)
                                    }
                                }
                                else {
                                    Button(action: {
                                        if (userSettings.user == nil) {
                                            showAlert = true
                                        }
                                        else {
                                            selectedPost = post
                                        }
                                    }) {
                                        Text("\(demandeCount)/\(maxCount)")
                                            .frame(maxWidth: .infinity)
                                            .padding(8)
                                            .background(fillColor.opacity(0.3))
                                            .cornerRadius(8)
                                            .padding(.horizontal, 30)
                                            .foregroundColor(Color.black)
                                    }
                                    .alert(isPresented: $showAlert) {
                                        Alert(title: Text("Connectez-vous"), message: Text("Vous devez être connecté pour vous inscrire."), dismissButton: .default(Text("OK")))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedPost) { post in
            if post.nom_post == "Animation jeux" {
                CalendarJeuView()
            } else {
                NextPageView(creneauId: selectedCreneauId ?? 0, zoneId: nil, activite: post.nom_post, creneauDetails: selectedCreneauDetails, zoneDetails: "Zone \(post.nom_post)")
            }
        }
    }
}



#Preview {
    CalendarView()
}
