
import Foundation
import SwiftUI
// Vue pour afficher les détails d'un post
struct PostDetailsView: View {
    let post: Post

    var body: some View {
        ScrollView {
            Text(post.description)
                .padding()
            Spacer()
        }
        .navigationTitle("Informations \(post.nom_post)")
    }
}
