import Foundation
import SwiftUI
import Combine

// Vue pour afficher la liste des posts
struct PostsListView: View {
    @StateObject private var viewModel = PostsListViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.posts) { post in
                NavigationLink(destination: PostDetailsView(post: post)) {
                    Text(post.nom_post)
                }
            }
            .navigationTitle("Liste des Posts")
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
