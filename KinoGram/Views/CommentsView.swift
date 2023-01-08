//
//  CommentsView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct CommentsView: View {
    
    @State var submissionText: String = ""
    @State var commentArray = [CommentModel]()
    
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
                    Image("dog1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(20)
                    
                    TextField("ADD a comment here...", text: $submissionText)
                    
                    Button(action: {
                        
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
            }
        }
        
    }
    func getComments() {
        
        print("Get Comments from database")
        
        let comment1 = CommentModel(commentID: "", userID: "", username: "Joe rogan", content: "comentingggg", dateCreated: Date())
        let comment2 = CommentModel(commentID: "", userID: "", username: "Alex Jones", content: "comentingggg", dateCreated: Date())
        let comment3 = CommentModel(commentID: "", userID: "", username: "stefanie", content: "comentingggg", dateCreated: Date())
        let comment4 = CommentModel(commentID: "", userID: "", username: "chris", content: "comentingggg", dateCreated: Date())
        self.commentArray.append(comment1)
        self.commentArray.append(comment2)
        self.commentArray.append(comment3)
        self.commentArray.append(comment4)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
