//
//  CommentsView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct CommentsView: View {
    
    @State var submissionText: String = ""
    var post: PostModel
    @State var commentArray = [CommentModel]()
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    @AppStorage(CurrentUserDefaults.userID) var currentUserID : String?
    @AppStorage(CurrentUserDefaults.displayName) var currentDisplayName: String?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack {
                        ForEach(commentArray, id: \.self) { comment in
                             MessageView(comment: comment)
                        }
                    }
                }
                HStack {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                    
                    TextField("ADD a comment here...", text: $submissionText)
                    
                    Button(action: {
                        if textIsAppropriate() {
                            addComment()
                        }
                    }, label: {
                        
                        Image(systemName: "paperplane.fill")
                            .font(.title)
                            .foregroundColor(.buttonColor)
                    })
                   
                    
                }
                .padding(.all, 6)
            }
            .padding(.horizontal)
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                getComments()
                getProfilePicture()
            }
        }
        
    }
    
    // MARK: FUNCTIONS
    func getProfilePicture() {
        
        guard let userID = currentUserID else { return }
        
        
        ImageManager.instance.downloadProfileImage(userID: userID) { image in
            if image != nil {
                self.profilePicture = image!
            }
        }
    }
    
    func getComments() {
        guard self.commentArray.isEmpty else { return }
        
        print("Get Comments from database")
        if let caption = post.caption, caption.count > 1 {
            let captionComment = CommentModel(commentID: "", userID: post.userID, username: post.username, content: caption, dateCreated: post.dateCreated)
            self.commentArray.append(captionComment)
        }
        
        DataService.instance.downloadComments(postID: post.postID) { comments in
            self.commentArray.append(contentsOf: comments)
        }
        
    }
    
    func textIsAppropriate() -> Bool {
        
        let badWordArray: [String] = ["shit", "ass", "fuck"]
        let words = submissionText.components(separatedBy: " ")
        for word in words {
            if badWordArray.contains(words) {
                return false
            }
        }
        if submissionText.count < 3 {
            return false
        }
        return true
    }
    func addComment() {
        
        guard let userID = currentUserID, let displayName = currentDisplayName else { return }
        
        DataService.instance.uploadComment(postID: post.postID, content: submissionText, displayName: displayName, userID: userID) { success, commentID in
            if success, let commentID = commentID {
                let newComment = CommentModel(commentID: commentID, userID: userID, username: displayName, content: submissionText, dateCreated: Date())
                self.commentArray.append(newComment)
                self.submissionText = ""
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static let post = PostModel(postID: "asd", userID: "Asda", username: "ASDASD", dateCreated: Date(), likeCount: 3, likedByUser: false)
    static var previews: some View {
        CommentsView(post: post)
    }
}
