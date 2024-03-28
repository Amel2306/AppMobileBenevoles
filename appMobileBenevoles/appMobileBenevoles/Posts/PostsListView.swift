import SwiftUI
import Combine

struct PostsListView: View {
    @StateObject private var viewModel = PostsListViewModel()

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.posts) { post in
                    NavigationLink(destination: PostDetailsView(post: post)) {
                        Text(post.nom_post)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(20)
                            .background(Color.white)
                    }
                }
                /*Button(action: {
                    viewModel.fetchPosts()
                }) {
                    Text("Actualiser")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.green]), startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(8)
                        .shadow(radius: 3)
                }
                .padding()
                 */
            }
            .navigationTitle("Liste des Postes")
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}


// ViewModel pour récupérer les données des posts
class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private var cancellables: Set<AnyCancellable> = []

    func fetchPosts() {
        guard let url = URL(string: "https://appbenevoleamelines.cluster-ig4.igpolytech.fr/api/post") else {
            print ("Invalid URL")
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] posts in
                self?.posts = posts
            })
            .store(in: &cancellables)
    }
}
