//
//  LoginView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 18/03/2024.
//

import Foundation
import SwiftUI

struct UserDataResponse : Decodable {
    let existingUser: User
    let token: String
}


struct LoginView : View {
 @State private var email = ""
 @State private var password = ""
 @State private var wrongUsername: Float = 0
 @State private var wrongPassword: Float  = 0
 @State private var showingLoginScreen = false
 @State private var user: User?
 @State private var isAuthenticated = false
 @State private var userDataResponse : UserDataResponse?
 @Binding var isLoggedIn: Bool
 @EnvironmentObject var userSettings: UserSettings

 
 
 var body: some View {
    ScrollView {
         VStack {
             Text("Connexion")
                 .font(.largeTitle)
                 .bold()
                 .padding()
             
             TextField("Username", text: $email)
                 .padding()
                 .frame(width: 300, height: 50)
                 .background(Color.black.opacity(0.05))
                 .cornerRadius(10)
                 .border(.red, width: CGFloat(wrongUsername))
             
             
             SecureField("Password", text: $password)
                 .padding()
                 .frame(width: 300, height: 50)
                 .background(Color.black.opacity(0.05))
                 .cornerRadius(10)
                 .border(.red, width: CGFloat(wrongPassword))
             
             Button("Login") {
                 let requestBody = ["email": email.lowercased(), "password": password]
                 
                 print(requestBody)
                 
                 authenticateUser(requestBody: requestBody)
             }
             .foregroundColor(.white)
             .frame(width: 300, height: 50)
             .background(Color.green)
             .cornerRadius(10)
             
             NavigationLink(destination: WelcomeView(), isActive: $showingLoginScreen) {
                 EmptyView()
             }
         }
     }
 }
 
 func authenticateUser(requestBody: [String: String]) {
     guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/authentification/login") else {
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
