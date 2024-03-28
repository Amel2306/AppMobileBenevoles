import SwiftUI


struct UserDetailsView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State private var demandesEnAttente: [DemanderActivite] = []
    @State private var demandesAcceptees: [DemanderActivite] = []
    @State private var demandesRefusees: [DemanderActivite] = []
    @State private var nombreDemandesAffichees = 5
    @State private var zoneBenevoleNames: [Int: String] = [:]
    @State private var creneauDate:  [Int: String] = [:]
    @State private var creneauHoraires:  [Int: String] = [:]
    //++
    @State private var isPresentingEditView = false

    
    static var emptyUser: User {
        User(id: 1 , nom: "", prenom : "", email: "", numero_tel: "", pseudo: "",biographie: "", role: "", password: "",cherche_hebergement: 0,propose_hebergement: "",taille: "",association_id:"",createdAt: "",updatedAt: "")
        }

    
    
    var body: some View {
        
        NavigationView {
            ScrollView{
            VStack {
                Group{
                    Text("Bienvenue, \(userSettings.user?.prenom ?? "")")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .padding()
                }
                
                Group {
                    Divider()
                    HStack{
                        Text("Nom ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(userSettings.user?.nom ?? "Entrez votre nom")")
                    }
                    Divider()
                    HStack {
                        Text("Prénom ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(userSettings.user?.prenom ?? "Entrez votre prénom")")
                    }
                    Divider()
                    
                }
                .padding(.horizontal)
                
                
                Group{
                    HStack{
                        Text("Email ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(userSettings.user?.email ?? "")")
                    }
                    
                    Divider()
                    HStack{
                        Text("Pseudo ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(userSettings.user?.pseudo ?? "Entrez votre pseudo")")
                    }
                    Divider()
                }
                .padding(.horizontal)
                
                Group{
                    HStack{
                        Text("Biographie ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(userSettings.user?.biographie ?? "Entrez votre biographie")")
                    }
                    Divider()
                    HStack{
                        Text("Rôle ")
                            .fontWeight(.bold)
                        Spacer()
                        Text(" \(userSettings.user?.role ?? "Bénévole")")
                    }
                    Divider()
                }
                .padding(.horizontal)
                
                
                Group{
                    HStack{
                        Text("Taille ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(userSettings.user?.taille ?? "Entrez votre taille")")
                    }
                    Divider()
                    HStack{
                        Text("Membre depuis le ")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(String(userSettings.user?.createdAt.prefix(10) ?? ""))")
                    }
                    Divider()
                }
                .padding(.horizontal)
                
                
                
                
                
                // Liste des demandes en attente
                if !demandesEnAttente.isEmpty {
                    Section {
                        Text("Mes demandes en attente")
                            .font(.headline)
                        
                        ForEach(demandesEnAttente, id: \.id) { demande in
                            VStack (alignment: .leading){
                                HStack{
                                    Text("Numéro de la demande:  \(demande.id)")
                                        .font(.headline)
                                    Spacer()
                                    Text("En attente")
                                        .italic()
                                }
                                HStack {
                                    Label("\(creneauDate[demande.creneau_id] ?? "")", systemImage: "calendar")
                                    Spacer()
                                    Label("\(creneauHoraires[demande.creneau_id] ?? "")", systemImage: "clock")
                                        .labelStyle(.trailingIcon)
                                }
                                .font(.caption)
                                
                                Label("\(zoneBenevoleNames[demande.zonebenevole_id] ?? "")", systemImage:"mappin.and.ellipse")
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(.black)
                            
                        }
                        .frame(width: 380, height: 60)
                        .background(Color(hex: "4A4BA8").opacity(0.4))
                        .cornerRadius(10)
                        
                    }
                }
                
                // Liste des demandes acceptées
                if !demandesAcceptees.isEmpty {
                    Section {
                        Text("Mes demandes acceptées")
                            .font(.headline)
                        
                        ForEach(demandesAcceptees.prefix(nombreDemandesAffichees), id: \.id) { demande in
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("Numéro de la demande:  \(demande.id)")
                                        .font(.headline)
                                    Spacer()
                                    Text("Acceptée")
                                        .italic()
                                }
                                HStack {
                                    Label("\(creneauDate[demande.creneau_id] ?? "")", systemImage: "calendar")
                                    Spacer()
                                    Label("\(creneauHoraires[demande.creneau_id] ?? "")", systemImage: "clock")
                                        .labelStyle(.trailingIcon)
                                }
                                .font(.caption)
                                
                                Label("\(zoneBenevoleNames[demande.zonebenevole_id] ?? "")", systemImage:"mappin.and.ellipse")
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(.black)
                        }
                        .frame(width: 380, height: 60)
                        .background(Color(hex: "7BC42F").opacity(0.4))
                        .cornerRadius(10)
                        
                        
                    }
                    
                }
                Group{
                    // Boutons pour afficher plus ou moins de demandes acceptées
                    HStack {
                        Spacer()
                        Button(action: {
                            nombreDemandesAffichees += 5
                        }) {
                            Label("",systemImage: "plus.circle")
                        }
                        
                        Button(action: {
                            nombreDemandesAffichees = max(nombreDemandesAffichees - 5, 5)
                        }) {
                            Label("",systemImage:"minus.circle")
                        }
                    }
                }
                
                
                // Liste des demandes refusées
                if (!demandesRefusees.isEmpty) {
                    Section {
                        Text("Mes demandes refusées")
                            .font(.headline)
                        
                        ForEach(demandesRefusees, id: \.id) { demande in
                            VStack(alignment: .leading) {
                                HStack{
                                    Text("Numéro de la demande:  \(demande.id)")
                                        .font(.headline)
                                    Spacer()
                                    Text("Refusée")
                                        .italic()
                                }
                                HStack {
                                    Label("\(creneauDate[demande.creneau_id] ?? "")", systemImage: "calendar")
                                    Spacer()
                                    Label("\(creneauHoraires[demande.creneau_id] ?? "")", systemImage: "clock")
                                        .labelStyle(.trailingIcon)
                                }
                                .font(.caption)
                                
                                Label("\(zoneBenevoleNames[demande.zonebenevole_id] ?? "")", systemImage:"mappin.and.ellipse")
                                    .font(.caption)
                            }
                            .padding()
                            .foregroundColor(.black)
                        }
                        .frame(width: 380, height: 60)
                        .background(Color(hex: "C37EC9").opacity(0.4))
                        .cornerRadius(10)
                        
                    }
                    
                    
                }
                
            }
            .navigationBarTitle("Profil")
            .onAppear {
                fetchDemandesActivite()
                fetchZoneBenevoleNames()
                fetchCreneauDetails()
            }
            .toolbar {
                Button("Modifier") {
                    isPresentingEditView = true
                }
            }
            .sheet(isPresented: $isPresentingEditView) {
                NavigationStack {
                    UserEditView()
                        .navigationTitle("Modifier le profil")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Annuler") {
                                    isPresentingEditView = false
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Valider") {
                                    isPresentingEditView = false
                                }
                            }
                        }

                }
            }
        }
    }
    }

    func fetchDemandesActivite() {
        let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/demanderactivtie/user/1")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                let demandesActivite = try JSONDecoder().decode([DemanderActivite].self, from: data)
                demandesEnAttente = demandesActivite.filter { $0.accepte == 0 && $0.archive == 0 }
                demandesAcceptees = demandesActivite.filter { $0.accepte == 1 }
                demandesRefusees = demandesActivite.filter{ $0.archive == 1 && $0.accepte == 0 }
                fetchZoneBenevoleNames()
                fetchCreneauDetails()

            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }


func fetchZoneBenevoleNames() {
        for demande in demandesAcceptees {
            let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/zonebenevole/\(demande.zonebenevole_id)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data returned")
                    return
                }

                do {
                    let zoneBenevole = try JSONDecoder().decode(Zonebenevole.self, from: data)
                    zoneBenevoleNames[demande.zonebenevole_id] = zoneBenevole.nom_zb
                } catch {
                    print("Error decoding data: \(error)")
                }
            }.resume()
        }
    }
    func fetchCreneauDetails() {
        for demande in demandesAcceptees {
            
            let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/creneaux/\(demande.creneau_id)")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching creneau details: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data returned")
                    return
                }
                
                do {
                    let creneau = try JSONDecoder().decode(Creneau.self, from: data)
                    let startTime = String(creneau.horaire_debut.prefix(2))
                    let endTime = String(creneau.horaire_fin.prefix(2))
                    creneauDate[demande.creneau_id] = creneau.date
                    creneauHoraires[demande.creneau_id] = "\(startTime)-\(endTime)h"
                } catch {
                    print("Error decoding creneau details: \(error)")
                }
            }.resume()
        }
       }
   
}


