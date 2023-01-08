//
//  DataService.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 07.01.23.
//

// Used to handle upload and download data (other than User from our Database
import Foundation
import SwiftUI
import GoogleSignIn
import FirebaseFirestore

class DataService {
    // MARK: PROPERIES
    static let instance = DataService()
    
     var REF_POSTS = DB_BASE.collection("posts/")
    
    // MARK: CREATE FUNCTION
    
    func uploadPost(image: UIImage, caption: String?, displayName: String, userID: String, handler: @escaping(_ error : Error?) -> Void ) {
        
        
        let stringuid = UUID().uuidString
        
        let document = REF_POSTS.document(stringuid)
        let postID = document.documentID
        print(userID)
        
        ImageManager.instance.uploadPostImage(postID: postID, image: image) { error in
            handler(error)
            if error != nil {
                print(error?.localizedDescription)
            }
      
        }
        
        let postData: [String:Any] = [
            DatabasePostField.postID : postID,
            DatabasePostField.userID : userID,
            DatabasePostField.displayName : displayName,
            DatabasePostField.caption : caption,
            DatabasePostField.dateCreated : FieldValue.serverTimestamp()
        ]
            document.setData(postData) { err in
                handler(err)
                if err != nil {
                    print(err?.localizedDescription)
                }
                
            }
    }
    // MARK: GET FUNCTIONS
    
    func downloadPostForUser(userID: String, handler: @escaping(_ posts: [PostModel]) -> Void) {
        
        REF_POSTS.whereField(DatabasePostField.userID, isEqualTo: userID).getDocuments { querySnapshot, error in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))

        }
//        let ref = DB_BASE.collection(userID + " POSTS")
//        ref.getDocuments { querySnapshot, error in
//            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
//
//        }
        
    }
    
    func downloadPostsForFeed(userID: String, handler: @escaping(_ posts: [PostModel]) -> Void) {
        
//        let ref = DB_BASE.collection(userID + " POSTS")
//        ref.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 15).getDocuments { querySnapshot , error in
//            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
//        }
        
        
        REF_POSTS.order(by: DatabasePostField.dateCreated, descending: true).limit(to: 15).getDocuments { querySnapshot , error in
            handler(self.getPostsFromSnapshot(querySnapshot: querySnapshot))
        }
    }
    
    private func getPostsFromSnapshot(querySnapshot: QuerySnapshot?) -> [PostModel] {
        var postArray = [PostModel]()
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            for document in snapshot.documents {
                let userID = document.get(DatabasePostField.userID) as? String
                let displayName = document.get(DatabasePostField.displayName) as? String
                let timestamp = document.get(DatabasePostField.dateCreated) as! Timestamp
                let caption = document.get(DatabasePostField.caption) as? String
                let postID = document.documentID
                let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                
                
                let newPost = PostModel(postID: postID, userID: userID!, username: displayName!, caption: caption, dateCreated: date, likeCount: 0, likedByUser: false)
                postArray.append(newPost)
            }
           return postArray
        } else {
            print("NO DOCUMENTS IN SNAPSHOT FOUND FOR THIS USER")
            return postArray
        }
        
    }
}
