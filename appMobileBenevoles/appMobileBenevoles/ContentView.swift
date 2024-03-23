
//
//  ContentView.swift
//  LoginScreen
//
//  Created by Federico on 13/11/2021.
//

import SwiftUI


struct ContentView: View {
    @StateObject var userSettings = UserSettings()
    
    var body: some View {
        NavBar()
        .environmentObject(userSettings) // Injecter l'objet dans l'environnement
    }
   
    
}

#Preview {
    ContentView()
}
