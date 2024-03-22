//
//  NextPageView.swift
//  appMobileBenevoles
//
//  Created by Amel  on 19/03/2024.
//

import Foundation
import SwiftUI

struct NextPageView: View {
    let activity: String
    let timeSlot: String
    @State private var isConfirmationAlertPresented = false
    @State private var isRegistered = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Text("Activité sélectionnée : \(activity)")
                Text("Créneau horaire : \(timeSlot)")
            }
            
            if isRegistered {
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
                    Alert(
                        title: Text("Confirmation"),
                        message: Text("Voulez-vous vous engager dans cette activité pour ce créneau horaire ?"),
                        primaryButton: .default(Text("Oui")) {
                            //TO DO : envoyer la requête d'inscription
                            isRegistered = true
                        },
                        secondaryButton: .cancel(Text("Non")){
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                }
                .shadow(radius: 3)
            }

            if isRegistered {
                Button(action: {
                    //TO DO : Aller sur la page profil
                }) {
                    Text("Voir mes inscriptions")
                        .padding()
                        .background(Color(hex: "#4A4BA8"))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .shadow(radius: 3)
            }
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(15)
        .navigationBarTitle("Confirmation", displayMode: .inline)
    }
}
