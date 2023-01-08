//
//  ImageGridView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct ImageGridView: View {
    
    @ObservedObject var posts: PostArrayObject
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], alignment: .center, spacing: nil, pinnedViews: []) {
            
            ForEach(posts.dateArray, id: \.self) { post in
                NavigationLink(destination: FeedView(posts: PostArrayObject(post: post), title: "Post")) {
                    PostView(post: post, showHeaderAndFooter: false, addheartAnimationToView: false)
                }
                
            }
            
           
       
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(posts: PostArrayObject())
    }
}
