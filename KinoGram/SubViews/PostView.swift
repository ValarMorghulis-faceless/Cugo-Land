//
//  PostView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct PostView: View {
    
    
    @State var post: PostModel
    var showHeaderAndFooter: Bool
    @State var animateLike: Bool = false
    @State var addheartAnimationToView: Bool
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    
    
    enum PostActionSheetOption {
        case general
        case reporting
    }
    
    var body: some View {
        VStack(alignment: .center,spacing: 0) {
            
            //MARK: Header
            if showHeaderAndFooter {
                HStack {
                    
                    NavigationLink {
                        ProfileView(isMyprofile: false, profileDisplayName: post.username, profileUserID: post.userID, posts: PostArrayObject(userID: post.userID))
                    } label: {
                        
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                        .cornerRadius(15)
                        Text(post.username)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }

                
                    Spacer()
                    
                    Button(action: {
                        showActionSheet.toggle()
                        print(post.postID)
                    }, label: {
                        Image(systemName: "ellipsis")
                            .font(.headline)
                    })
                    .actionSheet(isPresented: $showActionSheet) {
                           getActionSheet()
                     //   print(post.postID)
                    }
                    .accentColor(.primary)
                    
                    
                }
                .padding(.all, 6)
            }
        
            //MARK: Image
            
            ZStack {
                Image(uiImage: postImage)
                    .resizable()
                    .scaledToFit()
                if addheartAnimationToView {
                    LikeAnimationView(animate: $animateLike)
                }
                
            }
            
            
            
            //MARK: FOOTER
            if showHeaderAndFooter {
                HStack(alignment: .center, spacing: 20) {
                    Button(action: {
                        if post.likedByUser {
                            //unlike
                            unlikePost()
                        }else {
                            //like
                            likePost()
                        }
                    }, label: {
                        Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                            .font(.title3)
                    })
                    .accentColor(post.likedByUser ? .red : .primary)
                    // MARK: COMMENT ICON
                    NavigationLink(destination: CommentsView()) {
                        Image(systemName: "bubble.middle.bottom")
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                   
                    Button(action: {
                    sharePost()
                    }, label: {
                        Image(systemName: "paperplane")
                            .font(.title3)
                    })
                    .accentColor(.primary)
                   
                    
                    Spacer()
                }
                .padding(.all, 6)

                if let caption = post.caption {
                    HStack {
                        Text(caption)
                        Spacer(minLength: 0)
                    }
                    .padding(.all, 6)
                }
            }
       
         
        }
        .onAppear {
            getImages()
            
        }
        
        
        
        
    }
    func getImages() {
        ImageManager.instance.downloadProfileImage(userID: post.userID) { image in
            if image != nil {
                self.profileImage = image!
            }
        }
        ImageManager.instance.downloadPostImage(postID: post.postID ) { image in
            if image != nil {
                self.postImage = image!
            }
        }
    }
    // MARK: FUNCTIONs
    func likePost() {
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, username: post.username,caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount + 1, likedByUser: true)
        self.post = updatedPost
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            animateLike = false
        }
    }
    
    func getActionSheet() -> ActionSheet {
        
        switch self.actionSheetType {
        case .general:
            return ActionSheet(title: Text("What would you like to do?"), message: nil, buttons: [
                .destructive(Text("Report"), action: {
                    self.actionSheetType = .reporting
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showActionSheet.toggle()
                    }
                   
                }),
                .default(Text("Learn more..."), action: {
                    print("LEARN MORE PRESSED")
                }),
                .cancel()
            ])
        case .reporting:
            return ActionSheet(title: Text("Why are you reporting this post?"), message: nil, buttons: [
                .destructive(Text("This is inappropriate"), action: {
                    reportPost(reason: "This is inappropriate")
                }),
                .destructive(Text("This is spam"), action: {
                    reportPost(reason: "This is spam")
                }),
                .destructive(Text("It made me uncomfortable"), action: {
                    reportPost(reason: "It made me uncomfortable")
                }),
                .cancel({
                    self.actionSheetType = .general
                })
            ])

            
        }
    }
    func sharePost() {
        let message = "Check out this post on CugoLand!"
        let image = postImage
        let link = URL(string: "https://www.google.com")
        let activityViewController = UIActivityViewController(activityItems: [message,image,link], applicationActivities: nil)
        
        let viewController = UIApplication.shared.windows.first?.rootViewController
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
    func reportPost(reason: String) {
        print("REPORT POST NOW")
    }
    
    func unlikePost() {
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, username: post.username,caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        self.post = updatedPost
    }
}

struct PostView_Previews: PreviewProvider {
    static var post: PostModel = PostModel(postID: "",  userID: "", username: "Fukome var",caption: "this is good photo", dateCreated: Date(), likeCount: 0, likedByUser: false)
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true, addheartAnimationToView: true)
    }
}
