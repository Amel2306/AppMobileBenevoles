//
//  CalendarView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation
import SwiftUI

    extension Color {
        init(hex: String) {
            var hex = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if hex.hasPrefix("#") {
                hex.remove(at: hex.startIndex)
            }
            
            var rgb: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&rgb)
            
            self.init(red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                      green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                      blue: Double(rgb & 0x0000FF) / 255.0)
        }
    }

    struct ActivityRegistration {
        var activity: String
        var timeSlot: String
        var numberOfRegistrations: Int
        var maxNumberOfRegistrations: Int
    }

    // Classe ViewModel
    class ContentViewModel: ObservableObject {
        @Published var selectedDay = "Samedi"
        @Published var selectedMoment = "Journée"
        @Published var selectedActivity: String = "Toutes"
        @Published var isNextButtonEnabled = false
        
        @State private var posts : [Post] = []
        @State private var horaires = [Creneau]()
        @State private var tabPostHoraire = [Int: [[DemanderActivite]]]()
        @State private var tabPostNbMax = [Int: [Int: Int]]()
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
                self.fetchData2()
            }
        }
        
        func fetchPosts() {
                guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/post") else {
                    print("Invalid URL")
                    return
                }

                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error: \(error)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        print("Server error")
                        return
                    }

                    if let data = data {
                        do {
                            let decodedData = try JSONDecoder().decode([Post].self, from: data)
                            DispatchQueue.main.async {
                                print(data)
                                print(decodedData)
                                self.posts = decodedData
                                print("////" , self.posts)
                            }
                            
                        } catch {
                            print("Error decoding JSON: \(error)")
                        }
                    }
                }
                task.resume()
            }

        func fetchHoraires() {
            // Appeler votre API pour récupérer les créneaux horaires
            // Mettre à jour la variable 'horaires' avec les données récupérées
        }

        func fetchData() {
            // Logique pour récupérer les données de demande par horaire et post
        }

        func fetchData2() {
            // Logique pour récupérer les informations de demande par horaire et post
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
        
        
        
        let saturdayActivities = ["Jeux en plein air", "Petit déjeuner","Déjeuner","Concours de dessin"]
        let sundayActivities = ["Randonnée pédestre", "Brunch", "Dîner en famille", "Cinéma"]
        let moments = ["Journée","Matin","Midi","Après-midi"]
        let days = ["Samedi","Dimanche"]
        
        let registrations: [ActivityRegistration] = [
            ActivityRegistration(activity: "Jeux en plein air", timeSlot: "9h-11h", numberOfRegistrations: Int.random(in: 1...20), maxNumberOfRegistrations: 20),
            ActivityRegistration(activity: "Jeux en plein air", timeSlot: "11h-12h", numberOfRegistrations: Int.random(in: 1...10), maxNumberOfRegistrations: 10),
            ActivityRegistration(activity: "Petit déjeuner", timeSlot: "9h-11h", numberOfRegistrations: Int.random(in: 1...15), maxNumberOfRegistrations: 15),
            ActivityRegistration(activity: "Déjeuner", timeSlot: "12h-14h", numberOfRegistrations: Int.random(in: 1...2), maxNumberOfRegistrations: 2),
            ActivityRegistration(activity: "Concours de dessin", timeSlot: "14h-16h", numberOfRegistrations: Int.random(in: 1...10), maxNumberOfRegistrations: 10),
            ActivityRegistration(activity: "Randonnée pédestre", timeSlot: "9h-11h", numberOfRegistrations: Int.random(in: 1...5), maxNumberOfRegistrations: 5),
            ActivityRegistration(activity: "Randonnée pédestre", timeSlot: "11h-12h", numberOfRegistrations: Int.random(in: 1...8), maxNumberOfRegistrations: 8),
            ActivityRegistration(activity: "Brunch", timeSlot: "9h-11h", numberOfRegistrations: Int.random(in: 1...15), maxNumberOfRegistrations: 15),
            ActivityRegistration(activity: "Dîner en famille", timeSlot: "12h-14h", numberOfRegistrations: Int.random(in: 1...20), maxNumberOfRegistrations: 20),
            ActivityRegistration(activity: "Cinéma", timeSlot: "14h-16h", numberOfRegistrations: Int.random(in: 1...30), maxNumberOfRegistrations: 30),
        ]
        
        var selectedDayActivities: [String] {
            selectedDay == "Samedi" ? saturdayActivities : sundayActivities
        }
        
        var timeSlots: [String] {
            var slots = [""]
            switch selectedMoment {
            case "Matin":
                slots += ["9h-11h", "11h-12h"]
            case "Midi":
                slots += ["12h-14h"]
            case "Après-midi":
                slots += ["14h-16h", "16h-18h"]
            case "Journée":
                slots += ["9h-11h", "11h-12h", "14h-16h", "16h-18h"]
            default:
                slots += ["9h-11h", "11h-12h", "14h-16h", "16h-18h"]
            }
            return slots
        }
    }


struct CalendarView: View {
    @StateObject var viewModel = ContentViewModel()
    @State private var choixActivite: String?
    @State private var choixCreneau: String?
    @State private var shouldNavigate = false // Variable pour contrôler la navigation
    
    func resetSelection(activity: String, timeSlot: String) {
        if choixActivite == activity && choixCreneau == timeSlot {
            choixActivite = nil
            choixCreneau = nil
        } else {
            choixActivite = activity
            choixCreneau = timeSlot
        }
    }

    
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5) // Initialisation avec 5 colonnes
    
    var body: some View {
        ScrollView {
            VStack(alignment: .trailing) {
                VStack(alignment: .trailing) {
                    HStack{
                        // Sélection du jour
                        Text("Jour")
                        Spacer()
                        Picker("Jour", selection: $viewModel.selectedDay) {
                            ForEach(viewModel.days, id: \.self) { day in
                                Text(day)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading) // Ajout de padding à gauche$
                    }
                    Divider()
                    HStack{
                        Text("Moment de la journée")
                        Spacer()
                        
                        // Sélection du moment de la journée
                        Picker("Moment de la journée", selection: $viewModel.selectedMoment) {
                            ForEach(viewModel.moments, id: \.self) { moment in
                                Text(moment)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading) // Ajout de padding à gauche
                    }
                    Divider()
                    
                    
                    // Sélection de l'activité
                    HStack{
                        Text("Activité")
                        Spacer()
                        
                        Picker("Activité", selection: $viewModel.selectedActivity) {
                            ForEach(["Toutes"] + viewModel.selectedDayActivities, id: \.self) { activity in
                                Text(activity)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.leading) // Ajout de padding à gauche
                    }
                    
                }
                
                Divider() // Ajout d'une ligne de séparation
                    .padding(.bottom)
                VStack{
                    ScrollView {
                        
                        // Affichage des plages horaires
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.timeSlots, id: \.self) { timeSlot in
                                Text(timeSlot)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Affichage des activités
                        ForEach(viewModel.selectedDayActivities.indices, id: \.self) { rowIndex in
                            HStack {
                                ForEach(viewModel.timeSlots.indices, id: \.self) { columnIndex in
                                    let activity = viewModel.selectedDayActivities[rowIndex]
                                    let timeSlot = viewModel.timeSlots[columnIndex]
                                    
                                    if columnIndex == 0 {
                                        Text(activity)
                                            .font(.subheadline) // Diminuer la taille de la police d'écriture
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    } else {
                                        let registration = viewModel.registrations.first { $0.activity == activity && $0.timeSlot == timeSlot }
                                        let numberOfRegistrations = registration?.numberOfRegistrations ?? 0
                                        let maxNumberOfRegistrations = registration?.maxNumberOfRegistrations ?? 20
                                        
                                        let fillPercentage = Double(numberOfRegistrations) / Double(maxNumberOfRegistrations)
                                        
                                        let colors: Color = {
                                            switch fillPercentage {
                                            case ..<0.25:
                                                return Color(hex: "#C37EC9")
                                            case 0.25..<0.50:
                                                return Color(hex: "#4A4BA8")
                                            case 0.50..<0.75:
                                                return Color(hex: "#8EA668")
                                            case 0.75...:
                                                return Color(hex: "#7BC42F")
                                            default:
                                                return Color(red: 243/255, green: 244/255, blue: 246/255)
                                            }
                                        }()
                                        
                                        let isSelected = choixActivite == activity && choixCreneau == timeSlot
                                        let backgroundColor: Color = isSelected ? Color.blue.opacity(0.5) : colors
                                        
                                        if viewModel.selectedActivity == "Toutes" || activity == viewModel.selectedActivity {
                                            Text("\(numberOfRegistrations)/\(maxNumberOfRegistrations)")
                                                .frame(maxWidth: .infinity)
                                                .background(
                                                    ZStack {
                                                        if isSelected {
                                                            backgroundColor
                                                                .brightness(0.2)
                                                        } else {
                                                            backgroundColor
                                                        }
                                                    }
                                                )
                                                .cornerRadius(8)
                                                .transition(.opacity)
                                                .onTapGesture {
                                                    resetSelection(activity: activity, timeSlot: timeSlot)
                                                }
                                        } else {
                                            Color.clear
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Button(action: {
                        if choixActivite != nil && choixCreneau != nil {
                            shouldNavigate = true
                        }                }) {
                            Text("Suivant")
                                .padding()
                                .foregroundColor(.white)
                                .background((choixActivite != nil && choixCreneau != nil) ? Color.green : Color.white)
                                .clipShape(Capsule())
                                .scaleEffect(shouldNavigate ? 1.2 : 1) // Animation si la navigation est activée
                                .animation(.easeOut(duration: 0.2)) // Animation de l'échelle
                            
                        }
                        .shadow(radius: (choixActivite != nil && choixCreneau != nil) ? 3 : 0)

                        .background(
                            NavigationLink(
                                destination: NextPageView(activity: choixActivite ?? "", timeSlot: choixCreneau ?? ""),
                                isActive: $shouldNavigate // Utilisation de la variable booléenne pour contrôler l'activation de la navigation
                            ) {
                                EmptyView()
                            }
                        )
                    
                }
            }
            .padding(.horizontal)
            .navigationBarTitle("Calendrier")
            .onChange(of: viewModel.selectedMoment) { newValue in
                switch newValue {
                case "Matin":
                    columns = Array(repeating: .init(.flexible()), count: 3)
                case "Midi":
                    columns = Array(repeating: .init(.flexible()), count: 2)
                case "Après-midi":
                    columns = Array(repeating: .init(.flexible()), count: 3)
                case "Journée":
                    columns = Array(repeating: .init(.flexible()), count: 5)
                default:
                    columns = Array(repeating: .init(.flexible()), count: 5)
                }
            }
        }
        .onAppear{
            viewModel.fetchPosts()
        }
    }
}


#Preview {
    CalendarView()
}
