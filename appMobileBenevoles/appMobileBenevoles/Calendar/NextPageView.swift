import SwiftUI

struct NextPageView: View {
    
    let creneauId: Int
    let zoneId: Int
    let activite: String
    let creneauDetails: String
    let zoneDetails: String
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var errorMessage: Bool = false
    @State private var isConfirmationAlertPresented = false
    @State private var isRegistered = false
    @State private var isProfilSelected = false

    @Environment(\.presentationMode) var presentationMode

    init(creneauId: Int, zoneId: Int?, activite: String, creneauDetails: String, zoneDetails: String) {
        self.creneauId = creneauId
        self.activite = activite
        self.creneauDetails = creneauDetails
        self.zoneDetails = zoneDetails

        if let providedZoneId = zoneId {
            self.zoneId = providedZoneId
        } else {
            switch activite {
            case "Accueil":
                self.zoneId =  9
            case "Vente restauration":
                self.zoneId =  10
            case "Cuisine":
                self.zoneId =  11
            case "Tombola":
                self.zoneId =  12
            case "Forum associations":
                self.zoneId =  13
            default:
                self.zoneId =  1
            }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Activité sélectionnée : \(activite)\nCréneau horaire : \(creneauDetails) \nZone : \(zoneDetails)")
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(15)
                    .navigationBarTitle("Confirmation", displayMode: .inline)
            }
            
            if isRegistered {
                if errorMessage {
                    Text("Vous êtes déjà inscrit dans cette activité")
                        .foregroundColor(.red)
                        .padding()
                }
                else {
                    HStack {
                        Text("Vous avez bien été inscrits")
                            .foregroundColor(.green)
                            .font(.headline)
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
                Button(action: {
                    // Action à exécuter lors du clic sur le bouton
                    isProfilSelected = true
                }) {
                    Text("Voir mes inscriptions")
                        .padding()
                        .background(Color(hex: "#4A4BA8"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .buttonStyle(PlainButtonStyle())
                .shadow(radius: 3)
                .padding(.top, 20)

            } else {
                Button(action: {
                    // Afficher l'alerte de confirmation
                    isConfirmationAlertPresented = true
                }) {
                    Text("S'inscrire")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .alert(isPresented: $isConfirmationAlertPresented) {
                    let presentationMode = self.presentationMode // Capturer self dans une variable locale
                    return Alert(
                        title: Text("Confirmation"),
                        message: Text("Voulez-vous vous engager dans cette activité pour ce créneau horaire ?"),
                        primaryButton: .default(Text("Oui")) {
                            // Envoyer la requête d'inscription
                            self.registerActivity()
                        },
                        secondaryButton: .cancel(Text("Non")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
            }
        }
        .sheet(isPresented: $isProfilSelected) {
            UserDetailsView()
        }
    }
    
    func registerActivity() {
        let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/demanderactivtie")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create the request body
        let requestBody: [String: Any] = {
            var body: [String: Any] = [
                "creneau_id": creneauId,
                "zonebenevole_id": zoneId,
                "user_id" : 1,
                "accepte": 1,
                "archive": 0
            ]
            
            if let user = userSettings.user {
                body["user_id"] = user.id
            }
            return body
        }()
                
        // Convert the request body to JSON data
        let jsonData = try! JSONSerialization.data(withJSONObject: requestBody)
        
        // Attach the JSON data to the request
        request.httpBody = jsonData
        
        // Create a URLSession data task to send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response or error here
            if let error = error {
                errorMessage = true
                print("Error: \(error)")
            }
            else if let data = data {
                // Handle the response data if needed
                let reponse = (String(data: data, encoding: .utf8))
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
                if reponse == "{\"message\":\"Erreur lors de la création de demander_activite dans le contrôleur\"}" {
                    errorMessage = true
                }
                DispatchQueue.main.async {
                    self.isRegistered = true
                }
                print (errorMessage)
            }
        }
        
        // Resume the data task
        task.resume()
    }
}

