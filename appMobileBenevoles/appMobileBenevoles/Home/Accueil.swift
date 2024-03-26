import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        ScrollView {
            VStack {
                Image("accueilew")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200) // Ajustez la hauteur selon vos besoins
                
                Text("Sortons Jouer !")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ScrollView {
                    Text("Bienvenue sur l'application de gestion de bénévoles pour le Festival du Jeu de Montpellier !")
                        .padding()
                        .background(Color.white.opacity(0.5)) // Ajoute un fond blanc semi-transparent
                        .cornerRadius(10) // Arrondit les coins du cadre
                        .padding(5)
                    
                    Text("Chaque année, Montpellier célèbre le Festival du Jeu au Corum, offrant deux journées exceptionnelles dédiées aux jeux de société. Plongez dans une atmosphère ludique et conviviale où les joueurs de tous âges se retrouvent pour des moments inoubliables.")
                        .padding()
                        .background(Color.white.opacity(0.5)) // Ajoute un fond blanc semi-transparent
                        .cornerRadius(10) // Arrondit les coins du cadre
                        .padding(5)

                    Text("Le Festival du Jeu de Montpellier est l'occasion parfaite pour les bénévoles de participer à un événement festif et animé. Notre application facilite votre engagement en vous permettant de choisir parmi une multitude de postes, tels que l'animation de jeux, la cuisine, la vente et la restauration.")
                        .padding()
                        .background(Color.white.opacity(0.5)) // Ajoute un fond blanc semi-transparent
                        .cornerRadius(10) // Arrondit les coins du cadre
                        .padding(5)

                    Text("Mais ce n'est pas tout ! Notre plateforme vous offre également la possibilité de rechercher un hébergement pendant le festival. Vous pouvez effectuer des demandes d'hébergement aux autres bénévoles qui proposent des logements, créant ainsi une communauté solidaire et chaleureuse.")
                        .padding()
                        .background(Color.white.opacity(0.5)) // Ajoute un fond blanc semi-transparent
                        .cornerRadius(10) // Arrondit les coins du cadre
                        .padding(5)

                    Text("Rejoignez-nous pour une expérience unique au Festival du Jeu de Montpellier, où le plaisir du jeu et le partage sont au cœur de chaque instant. Inscrivez-vous dès maintenant et faites partie de cette aventure extraordinaire !")
                        .padding()
                        .background(Color.white.opacity(0.5)) // Ajoute un fond blanc semi-transparent
                        .cornerRadius(10) // Arrondit les coins du cadre
                        .padding(5)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true) // Empêche le bouton de retour
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



