//
//  PostArrayObject.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import Foundation


class PostArrayObject: ObservableObject {
    
    
    @Published var dateArray = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    /// USED FPR SINGLE POST SELECTED
    init(post: PostModel) {
        self.dateArray.append(post)
    }
    
    /// USED FOR GETTING POSTS FOR USER PROFILE
    init(userID: String) {
        print("GET POSTS FOR USER ID \(userID)")
        DataService.instance.downloadPostForUser(userID: userID) { posts in
            let sortedPosts = posts.sorted { post1, post2 in
                return post1.dateCreated > post2.dateCreated
            }
            self.dateArray.append(contentsOf: sortedPosts)
            self.updateCounts()
        }
    }
    
    /// USED FOR FEED
    
    init(userID: String, shuffled: Bool) {
        print("GET POSTS FOR FEED. SHUFFLED: \(shuffled)")
        DataService.instance.downloadPostsForFeed(userID: userID) { posts in
            if shuffled {
                let shuffled = posts.shuffled()
                self.dateArray.append(contentsOf: shuffled)
            } else {
                self.dateArray.append(contentsOf: posts)
            }
        }
    }
    
    func updateCounts() {
        self.postCountString = "\(self.dateArray.count)"
        let likeCountArray = dateArray.map { existingPost -> Int in
            return existingPost.likeCount
        }
        let sumOfLikeCountArray = likeCountArray.reduce(0, +)
        self.likeCountString = "\(sumOfLikeCountArray)"
    }
    
    
}
