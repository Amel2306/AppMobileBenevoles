
import Foundation
import SwiftUI
// Vue pour afficher les détails d'un post
struct PostDetailsView: View {
    let post: Post

    var body: some View {
        VStack {
            Text(post.description)
                .padding()
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.green]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .opacity(0.20)
                    .edgesIgnoringSafeArea(.all)
                )
            Spacer()
        }
        .navigationTitle("Informations \(post.nom_post)")
    }
}


struct Posts_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}

