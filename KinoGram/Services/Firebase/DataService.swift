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
    var REF_REPORT = DB_BASE.collection("reports")
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
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
    
    func uploadReport(reason: String, postID: String, handler: @escaping (_ success: Bool) -> Void) {
        
        let data: [String:Any] = [
        
            DatabaseReportsField.content : reason,
            DatabaseReportsField.postID : postID,
            DatabaseReportsField.dateCreated : FieldValue.serverTimestamp()
        
        ]
        
        REF_REPORT.addDocument(data: data) { error in
            if let error = error {
                print("Error uploading report. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
            
        }
        
    }
    func uploadComment(postID: String, content: String, displayName: String, userID: String, handler: @escaping (_ success: Bool, _ commentID: String?) -> Void) {
        let document = REF_POSTS.document(postID).collection(DatabasePostField.comments).document()
        let commentID = document.documentID
        
        let data: [String:Any] = [
            DatabaseCommentsField.commentID: commentID,
            DatabaseCommentsField.userID : userID,
            DatabaseCommentsField.content : content,
            DatabaseCommentsField.displayName : displayName,
            DatabaseCommentsField.dateCreated : FieldValue.serverTimestamp(),
        ]
        
        document.setData(data) { error in
            if let error = error {
                print(error.localizedDescription)
                handler(false, nil)
                return
            } else {
                handler(true,commentID)
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
    
    private func getCommentsFromSnaapshot(querySnapshot: QuerySnapshot?) -> [CommentModel] {
        var commentArray = [CommentModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents {
                
                if let userID = document.get(DatabaseCommentsField.userID) as? String, let displayName = document.get(DatabaseCommentsField.displayName) as? String,
                   let content = document.get(DatabaseCommentsField.content) as? String,
                   let timestamp = document.get(DatabaseCommentsField.dateCreated) as? Timestamp {
                    
                    
                    let date = timestamp.dateValue()
                    let commentID = document.documentID
                    let newComment = CommentModel(commentID: commentID, userID: userID , username: displayName, content: content, dateCreated: date)
                    commentArray.append(newComment)
                    
                }
            }
            return commentArray
        } else {
            
            return commentArray
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
                let likeCount = document.get(DatabasePostField.likeCount) as? Int ?? 0
                
                var likedByUser: Bool = false
                if let userIDArray = document.get(DatabasePostField.likedBy) as? [String], let userId = currentUserID {
                    
                  likedByUser = userIDArray.contains(userId)
                }
                
                let newPost = PostModel(postID: postID, userID: userID!, username: displayName!, caption: caption, dateCreated: date, likeCount: likeCount, likedByUser: likedByUser)
                postArray.append(newPost)
            }
           return postArray
        } else {
            print("NO DOCUMENTS IN SNAPSHOT FOUND FOR THIS USER")
            return postArray
        }
        
    }
    func downloadComments(postID: String, handler: @escaping (_ comments: [CommentModel]) -> Void) {
        REF_POSTS.document(postID).collection(DatabasePostField.comments).order(by: DatabaseCommentsField.dateCreated, descending: false).getDocuments { querySnapshot, error in
            handler(self.getCommentsFromSnaapshot(querySnapshot: querySnapshot))
            
        }
    }
    
    // MARK: UPDATE FUNCTIONS
    
    func likePost(postID: String, currentUserID: String) {
        // Update the post count
        // Update the array of users who liked the post
        let increment: Int64 = 1
        let data: [String:Any] = [
        
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayUnion([currentUserID])
        ]
        REF_POSTS.document(postID).updateData(data)
    }
    
    func unlikePost(postID: String, currentUserID: String) {
        let increment: Int64 = -1
        let data: [String:Any] = [
        
            DatabasePostField.likeCount : FieldValue.increment(increment),
            DatabasePostField.likedBy : FieldValue.arrayRemove([currentUserID])
        ]
        REF_POSTS.document(postID).updateData(data)
    }
    
    func updateDisplayNameOnPosts(userD: String, displayName: String) {
        downloadPostForUser(userID: userD) { posts in
            for post in posts {
                self.updatePostDisplayName(postID: post.postID, displayName: displayName)
            }
        }
    }
    
    private func updatePostDisplayName(postID: String, displayName: String) {
        
        let data: [String:Any] = [
            DatabasePostField.displayName : displayName
        ]
        
        REF_POSTS.document(postID).updateData(data)
    }
}
