import Foundation
import SwiftUI

    
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
