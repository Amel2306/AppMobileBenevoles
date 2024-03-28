import SwiftUI

struct PlaceholderTextFieldStyle: TextFieldStyle {
    var placeholder: String
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .overlay(
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.leading, 8),
                alignment: .leading
            )
            .cornerRadius(8)
    }
}




struct UserEditView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    @State private var user = UserDetailsView.emptyUser
    @State private var newName = ""
    @State private var newPrenom = ""
    @State private var newPseudo = ""
    
    @State private var isTextFieldActive = false

    var body: some View {
        Form {
            Section(header: Text("Entrez vos modifications")) {
                TextField("", text: $newName)
                    .textFieldStyle(PlaceholderTextFieldStyle(placeholder: userSettings.user?.nom ?? ""))
                    .onChange(of: newName) { value in
                        newName = value
                    }
                HStack {
                    TextField("Nom", text: $user.nom)
                    Button(action: {
                        withAnimation {
                            saveChangesIfModified(field: \.nom, newValue: newName)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(user.nom.isEmpty)
                }
                
                TextField("", text: $newPrenom)
                    .textFieldStyle(PlaceholderTextFieldStyle(placeholder: userSettings.user?.prenom ?? ""))
                    .onChange(of: newPrenom) { value in
                        newPrenom = value
                    }
                HStack {
                    TextField("Prénom", text: $user.prenom)
                    Button(action: {
                        withAnimation {
                            saveChangesIfModified(field: \.prenom, newValue: newPrenom)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(user.prenom.isEmpty)
                }
                
                TextField("", text: $newPseudo)
                    .textFieldStyle(PlaceholderTextFieldStyle(placeholder: userSettings.user?.pseudo ?? ""))
                    .onChange(of: newPseudo) { value in
                        newPseudo = value
                    }
                HStack {
                    TextField("Pseudo", text: $user.pseudo)
                    Button(action: {
                        withAnimation {
                            saveChangesIfModified(field: \.pseudo, newValue: newPseudo)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(user.pseudo.isEmpty)
                }
            }
        }
    }
    
    func saveChangesIfModified<Value: Equatable>(field: WritableKeyPath<User, Value>, newValue: Value) {
        if user[keyPath: field] != newValue {
            var modifiedUser = user
            modifiedUser[keyPath: field] = newValue
            print(";;;;;;;;", modifiedUser)

            updateUser(user: modifiedUser)
        }
    }

    func updateUser(user: User) {
        let userId = 1
        let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/users/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            print(user)
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user data: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating user data: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 200 {
                    print("User data updated successfully")
                } else {
                    print("Unexpected status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}
