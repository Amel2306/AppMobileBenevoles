import Foundation

import SwiftUI

struct UserDataResponseSing : Decodable {
    let newUser: User
    let token: String
}

struct SignUpView : View {
    @State private var nom = ""
    @State private var prenom = ""
    @State private var email = ""
    @State private var pseudo = ""
    @State private var password = ""
    @State private var showingLoginScreen = false
    @State private var user: User?
    @State private var isAuthenticated = false
    @State private var userDataResponse : UserDataResponseSing?
    @Binding var isLoggedIn: Bool
    @EnvironmentObject var userSettings: UserSettings

 
 
 var body: some View {
     NavigationView {
         ScrollView {
             VStack {
                 Image("logoew")
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .frame(width: 200, height: 200)
                 Text("Inscription")
                     .font(.largeTitle)
                     .bold()
                     .padding()
                 
                 TextField("Nom", text: $nom)
                     .padding()
                     .frame(width: 300, height: 50)
                     .background(Color.black.opacity(0.05))
                     .cornerRadius(10)
                     
                 
                 TextField("Prenom", text: $prenom)
                     .padding()
                     .frame(width: 300, height: 50)
                     .background(Color.black.opacity(0.05))
                     .cornerRadius(10)
                 
                 TextField("Email", text: $email)
                     .padding()
                     .frame(width: 300, height: 50)
                     .background(Color.black.opacity(0.05))
                     .cornerRadius(10)
                 
                 TextField("Pseudo", text: $pseudo)
                     .padding()
                     .frame(width: 300, height: 50)
                     .background(Color.black.opacity(0.05))
                     .cornerRadius(10)
                 
                 SecureField("Mot de passe", text: $password)
                     .padding()
                     .frame(width: 300, height: 50)
                     .background(Color.black.opacity(0.05))
                     .cornerRadius(10)
                 
                 Button {
                     let requestBody = ["nom": nom, "prenom": prenom, "pseudo": pseudo, "email": email.lowercased(), "password": password]
                     
                     print(requestBody)
                     
                     authenticateUser(requestBody: requestBody)
                     }
             label: {
                Text("S'inscrire")
                    .fontWeight(.bold)
            }
                 .foregroundColor(.white)
                 .frame(width: 300, height: 50)
                 .background(LinearGradient(colors: [.purple, .green], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                 
                 NavigationLink(destination: UserDetailsView(), isActive: $showingLoginScreen) {
                     EmptyView()
                 }
                 
                 Circle()
                             .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
                             .frame(width: 400, height: 400)
                             .opacity(0.9)
                             .offset(y: 50)
                 
                 
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
 
    func authenticateUser(requestBody: [String: String]) {
        guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/authentification/signup") else {
            print("Invalid URL")
            return
        }
        
        do {
            // Convertir le corps de la requête en données JSON
            let requestData = try JSONSerialization.data(withJSONObject: requestBody)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = requestData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Gérer les erreurs
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                print("++", data)
                do {
                    // Analyser les données JSON reçues
                    let responseData = try JSONDecoder().decode(UserDataResponse.self, from: data)
                    print("+++" ,responseData)
                    
                    // Stocker existingUser dans la variable user
                    DispatchQueue.main.async {
                        self.user = responseData.existingUser
                        self.showingLoginScreen = true
                        isLoggedIn = true
                        userSettings.user = self.user
                    }
                    
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }.resume()
        } catch {
            print("Error encoding request body: \(error)")
        }
    }
}
