//
//  PostArrayObject.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import Foundation


class PostArrayObject: ObservableObject {
    @Published var dateArray = [PostModel]()
    
    init() {
        
        //FETCH FROM DATABASE HERE
        let post1 = PostModel(postID: "", userID: "", username: "joker ledger",caption: "i do not do drugs i am the drugs", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post2 = PostModel(postID: "", userID: "", username: "Jessica",caption: "i didnt sleep with my teacher", dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post3 = PostModel(postID: "", userID: "", username: "Ginger",caption: nil, dateCreated: Date(), likeCount: 0, likedByUser: false)
        let post4 = PostModel(postID: "", userID: "", username: "Smakharag",caption: "rais erti guli chemi dedasheveci <# <# <# <# <# <3", dateCreated: Date(), likeCount: 0, likedByUser: false)
        self.dateArray.append(post1)
        self.dateArray.append(post2)

        self.dateArray.append(post3)

        self.dateArray.append(post4)

    }
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
    
}
