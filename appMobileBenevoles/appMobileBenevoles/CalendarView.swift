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
        var activity: String?
        var timeSlot: String
        var numberOfRegistrations: Int?
        var maxNumberOfRegistrations: Int
    }

struct TimeSlot : Hashable{
        let id: Int
        let creneau: String
    }


    // Classe ViewModel
    class ContentViewModel: ObservableObject {
        @Published var selectedDay = "2024-03-23"
        @Published var selectedMoment = "Journée"
        @Published var selectedActivity: String = "Toutes"
        @Published var isNextButtonEnabled = false
        @Published var posts: [Post] = []
        @Published var horaires : [Creneau] = []
        @Published var isPostsFetched = false
        @Published var isHorairesFetched = false
        @Published var tabPostHoraire = [Int: [[DemanderActivite]]]()
        
        @State private var tabPostNbMax = [Int: [Int: Int]]()
        @State private var selectedSlot = [(Int, Int)]()
        @State private var chooseJeuZone = false
        @State private var i = 0
        
        
        var processedSlots: [TimeSlot] {
            let filteredHoraires = horaires.filter { $0.date == selectedDay }
            var slots: [TimeSlot] = []
            
            for creneau in filteredHoraires {
                let startTime = String(creneau.horaire_debut.prefix(2))
                let endTime = String(creneau.horaire_fin.prefix(2))
                let timeSlot = "\(startTime)-\(endTime)h"
                let slot = TimeSlot(id: creneau.id, creneau: timeSlot)
                slots.append(slot)
            }
            
            return slots
        }
        
        var uniqueDays: [String] {
            let days = Set(horaires.map { $0.date })
            return Array(days)
        }

        

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
                    print("POOOOOSTS" ,self.posts)
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
                    self.isHorairesFetched = true
                    print("CREEENEAU", self.horaires)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }

        func fetchData() {
            var updatedTabPH = [Int: [[DemanderActivite]]]()
            
            // Vérifiez si les données des posts et des horaires ont été récupérées avec succès
            guard isPostsFetched && isHorairesFetched else {
                print("Posts or horaires data not fetched yet")
                return
            }

            // Boucle à travers chaque post pour récupérer les données de demande
            for post in posts {
                var tabH = [[DemanderActivite]]() // Déclaration de tabH à l'extérieur de la boucle horaire
                // Boucle à travers chaque horaire pour récupérer les données de demande
                for horaire in horaires {

                    let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/demanderactivtie/postCreneau/\(post.id)/\(horaire.id)")!
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
                                let decodedData = try JSONDecoder().decode([[DemanderActivite]].self, from: data)
                                tabH.append(contentsOf: decodedData)
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
                                            tabNbMax[horaire.id]! += element.nb_benevoles_max
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
                print(updatedTabPH)
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
        
        var saturdayActivities: [String] {
            var activities: [String] = []
            for post in posts {
                activities.append(post.nom_post)
            }
            return activities
        }

        var sundayActivities: [String] {
            var activities: [String] = []
            for post in posts {
                activities.append(post.nom_post)
            }
            return activities
        }
        
        //TO DO : moments
        let moments = ["Journée","Matin","Midi","Après-midi","Soir"]
        
        var registrations: [ActivityRegistration] {
            var registrations_temp: [ActivityRegistration] = []
            for postId in 1..<7 {
                for creneau_id in 0..<8 {
                    let timeSlot = "\(creneau_id)"
                    let numberOfRegistrations = tabPostHoraire[postId]?[creneau_id].count ?? 0

                    // TO DO: calculer le nombre maximal d'inscriptions pour ce créneau
                    let maxNumberOfRegistrations = 50
                    
                    let registration = ActivityRegistration(activity: getActivityName(for: postId), timeSlot: timeSlot, numberOfRegistrations: numberOfRegistrations, maxNumberOfRegistrations: maxNumberOfRegistrations)
                    registrations_temp.append(registration)
                    print(registration)
                }
            }
            return registrations_temp
        }
        
        var selectedDayActivities: [String] {
            selectedDay == "2024-03-23" ? saturdayActivities : sundayActivities
        }
        func getActivityName(for id: Int) -> String? {
            let post = posts.first { $0.id == id }
            return post?.nom_post
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
                            ForEach(viewModel.uniqueDays, id: \.self) { day in
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
                            ForEach(viewModel.processedSlots, id: \.self) { timeSlot in
                                Text(timeSlot.creneau)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Affichage des activités
                        ForEach(viewModel.selectedDayActivities.indices, id: \.self) { rowIndex in
                            HStack {
                                ForEach(viewModel.processedSlots, id: \.self) { timeSlot in
                                    let activity = viewModel.selectedDayActivities[rowIndex]
                                    
                                    if viewModel.processedSlots.first == timeSlot {
                                        Text(activity)
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(Color.gray.opacity(0.1))
                                            .cornerRadius(8)
                                    } else {
                                        let registration = viewModel.registrations.first {
                                            $0.activity == activity && $0.timeSlot == timeSlot.creneau
                                        }

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
                                        
                                        let isSelected = choixActivite == activity && choixCreneau == timeSlot.creneau
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
                                                    resetSelection(activity: activity, timeSlot: timeSlot.creneau) // Utilisation de timeSlot.creneau
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
                    columns = Array(repeating: .init(.flexible()), count: 2)
                case "Midi":
                    columns = Array(repeating: .init(.flexible()), count: 2)
                case "Après-midi":
                    columns = Array(repeating: .init(.flexible()), count: 3)
                case "Soir" :
                    columns = Array(repeating: .init(.flexible()), count: 2)
                case "Journée":
                    columns = Array(repeating: .init(.flexible()), count: 6)
                default:
                    columns = Array(repeating: .init(.flexible()), count: 6)
                }
            }
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


 

struct Calendar_Previews: PreviewProvider {
        static var previews: some View {
            CalendarView()
        }
    }
