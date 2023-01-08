//
//  BrowseView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct BrowseView: View {
    var posts: PostArrayObject
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    CarouselView()
                    ImageGridView(posts: posts)
                }
            }
            .navigationTitle("Browse")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView(posts: PostArrayObject(userID: "asdasd", shuffled: true))
    }
}
