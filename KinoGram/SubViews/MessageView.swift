//
//  MessageView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct MessageView: View {
    
    @State var comment: CommentModel
    @State var profilePicture: UIImage = UIImage(named: "logo.loading")!
    
    var body: some View {
        HStack {
            // MARK: PROFILE IMAGE
            NavigationLink(destination: LazyView(content: {
                ProfileView(isMyprofile: false, profileDisplayName: comment.username, profileUserID: comment.userID, posts: PostArrayObject(userID: comment.userID))
            })) {
                
                Image(uiImage: profilePicture)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
                
            }
       
            
            VStack(alignment: .leading, spacing: 4) {
                // MARK: USERNAME
                Text(comment.username)
                    .font(.caption)
                    .foregroundColor(.gray)
                // MARK: CONTENT
                Text(comment.content)
                    .padding(.all, 10)
                    .foregroundColor(.primary)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            Spacer(minLength: 0)
        }
        .onAppear {
            getProfileImage()
        }
    }
    // MARK: FUNCTIONS
    
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: comment.userID) { image in
            if image != nil {
                self.profilePicture = image!
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    
    static var comment: CommentModel = CommentModel(commentID: "", userID: "", username: "Joe rogan", content: "This photo is dope.", dateCreated: Date())
    
    static var previews: some View {
        MessageView(comment: comment)
        
    }
}
