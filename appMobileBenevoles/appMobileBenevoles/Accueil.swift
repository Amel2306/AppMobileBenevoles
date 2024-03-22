import SwiftUI

struct WelcomeView: View {
    var user : User?
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Bienvenue sur notre appli")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ScrollView {
                    Text("""
                        Bienvenue sur l'application de gestion de bénévoles pour le Festival du Jeu de Montpellier !

                        Chaque année, Montpellier célèbre le Festival du Jeu au Corum, offrant deux journées exceptionnelles dédiées aux jeux de société. Plongez dans une atmosphère ludique et conviviale où les joueurs de tous âges se retrouvent pour des moments inoubliables.

                        Le Festival du Jeu de Montpellier est l'occasion parfaite pour les bénévoles de participer à un événement festif et animé. Notre application facilite votre engagement en vous permettant de choisir parmi une multitude de postes, tels que l'animation de jeux, la cuisine, la vente et la restauration.

                        Mais ce n'est pas tout ! Notre plateforme vous offre également la possibilité de rechercher un hébergement pendant le festival. Vous pouvez effectuer des demandes d'hébergement aux autres bénévoles qui proposent des logements, créant ainsi une communauté solidaire et chaleureuse.

                        Rejoignez-nous pour une expérience unique au Festival du Jeu de Montpellier, où le plaisir du jeu et le partage sont au cœur de chaque instant. Inscrivez-vous dès maintenant et faites partie de cette aventure extraordinaire !
                        """)
                        .padding()
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            //.navigationTitle("Accueil")
            .navigationBarBackButtonHidden(true) // Empêche le bouton de retour
        }
    }
}



