//
//  FeedView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct FeedView: View {
    
    @ObservedObject var posts: PostArrayObject
    var title: String
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach(posts.dateArray, id: \.self) { post in
                        
                        PostView(post: post, showHeaderAndFooter: true, addheartAnimationToView: true)
                      
                        
                    }
                }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(posts: PostArrayObject(userID: "asdasd", shuffled: false), title: "Feed Test")
    }
}
