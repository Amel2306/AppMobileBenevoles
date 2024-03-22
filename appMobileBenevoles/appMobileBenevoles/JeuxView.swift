import SwiftUI

struct Game :Codable {
        let id: Int
        let nom_du_jeu: String
        let description: String
        let auteur : String
        let editeur : String
        let nb_joueurs : String
        let checkbox_joueur_age_min : String
        let duree : String
        let type : String
        let present : String
        let tags : String
        let recu : Bool
        let a_animer : String
        let image : String
        let logo: String
    }
    
    class GameStore: ObservableObject {
        @Published var games: [Game] = []
        
        func fetchGames() {
            guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/jeu") else {
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
                    self.games = try decoder.decode([Game].self, from: data)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }.resume()
        }
    }

    // Vue pour afficher la liste des jeux
struct GamesListView: View {
    @ObservedObject var gameStore = GameStore()

    
    var body: some View {
            NavigationView {
                List(gameStore.games, id: \.id) { game in
                    NavigationLink(destination: GameDetailView(game: game)) {
                        HStack{
                            AsyncImage(url: URL(string: game.logo), width: 50, height: 50) {
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .frame(width: 50, height: 50)
                                                    }
                                                    .cornerRadius(8)
                                                    
                                                    VStack(alignment: .leading) {
                                                        Text(game.nom_du_jeu)
                                                        Text("\(game.type)")
                                                            .font(.caption)
                                                            .foregroundColor(.secondary)
                                                    }
                        }
                    }
                }
                .navigationTitle("Liste des jeux")
                .onAppear {
                    gameStore.fetchGames()
                }
            }
        }
    }


// Vue pour afficher les détails d'un jeu
struct GameDetailView: View {
    let game: Game
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Affichage de toutes les informations sur le jeu
                AsyncImage(url: URL(string: game.image), width: 200, height: 200) {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: 200, height: 200)
                }
                .cornerRadius(8)
                
                Group {
                    Text("Description: \(game.description)")
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.green]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.15)
                )
                .cornerRadius(10)
                .shadow(radius: 3)
                
                Group{
                        Text("Auteur: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        Text(game.auteur)

                        Text("Editeur: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        Text(game.editeur)
                    Text("Type: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.type)
                    
                    Group{
                        Text("Tags : \(game.tags)")
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                        Divider()
                        Text("Nombre de joueurs: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                        Text(game.nb_joueurs)

                    
                }
                
                Group {
                        Text("Age minimum des joueurs: ")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                             Text(game.checkbox_joueur_age_min)
                    Text("Durée: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.duree)
                    Divider()


                    Text("Présent: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.present)

                }
                
                Group {
                    Text("Reçu: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.recu ? "Oui" : "Non")

                    Text("A animer: ")
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    Text(game.a_animer)

                }
                
            }
            .padding()
            .navigationTitle(game.nom_du_jeu)
        }
            
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Placeholder
    private let width: CGFloat
    private let height: CGFloat
    
    init(url: URL?, width: CGFloat, height: CGFloat, @ViewBuilder placeholder: () -> Placeholder) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder()
        self.width = width
        self.height = height
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: width, height: height)
                .cornerRadius(8)
        } else {
            placeholder
        }
    }
}



    // Affichage de la liste des jeux
    struct JeuxView: View {
        var body: some View {
            GamesListView()
        }
    }

    // Prévisualisation de la liste des jeux
    struct JeuxView_Previews: PreviewProvider {
        static var previews: some View {
            JeuxView()
        }
    }


    // Classe pour charger une image à partir d'une URL de manière asynchrone
    class ImageLoader: ObservableObject {
        @Published var image: UIImage?
        
        init(url: URL?) {
            guard let url = url else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }.resume()
        }
    }
