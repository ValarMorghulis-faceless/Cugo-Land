//
//  PostView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI
import ProgressHUD

struct PostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var post: PostModel
    var showHeaderAndFooter: Bool
    @State var animateLike: Bool = false
    @State var addheartAnimationToView: Bool
    @State var showActionSheet: Bool = false
    @State var actionSheetType: PostActionSheetOption = .general
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var postImage: UIImage = UIImage(named: "logo.loading")!
    
    @State var backtoprofile: Bool = false
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    enum PostActionSheetOption {
        case general
        case reporting
        case delete
    }
    
    var body: some View {
       
        
        NavigationView {
            VStack(alignment: .center,spacing: 0) {
                
                //MARK: Header
                if showHeaderAndFooter {

                    HStack {
                        
                        NavigationLink {
                            LazyView {
                                ProfileView(isMyprofile: false, profileDisplayName: post.username, profileUserID: post.userID, posts: PostArrayObject(userID: post.userID))
                            }
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
                        .onTapGesture(count: 2) {
                            if !post.likedByUser {
                                likePost()
                                AnalyticsService.instance.likePostDoubleTap()
                            }
                        }
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
                                AnalyticsService.instance.likePostHeartPressed()
                            }
                        }, label: {
                            Image(systemName: post.likedByUser ? "heart.fill" : "heart")
                                .font(.title3)
                        })
                        .accentColor(post.likedByUser ? .red : .primary)
                        // MARK: COMMENT ICON
                        NavigationLink(destination: CommentsView(post: post)) {
                            Image(systemName: "bubble.middle.bottom")
                                .font(.title3)
                                .foregroundColor(.primary)
                        }
                       
                        Button(action: {
                      //  sharePost()
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
           
             
            }.modifier(HideNavigationView())
            .onAppear {
                getImages()
                
        }
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
        
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }
        
        let updatedPost = PostModel(postID: post.postID, userID: post.userID, username: post.username,caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount + 1, likedByUser: true)
        self.post = updatedPost
        animateLike = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            animateLike = false
        }
        DataService.instance.likePost(postID: post.postID, currentUserID: userID)
    }
    
    func isCurrentUsersPost() -> Bool {
        if let userid = currentUserID, userid == post.userID{
            print(userid)
            print(post.userID)
            return true

        } else {
            return false
        }
        
    }
    
    func getActionSheet() -> ActionSheet {
        
        
        switch self.actionSheetType {
        case .general:
            
            if isCurrentUsersPost() {
                            return ActionSheet(title: Text("What would you like to do?"), message: nil, buttons: [
                
                                .destructive(Text("Delete post"), action: {
                                    self.actionSheetType = .delete
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                          self.showActionSheet.toggle()
                                    }
                                })
                                ,
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
            } else {
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
            }
            
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
        case .delete:
            return ActionSheet(title: Text("Delete Post?"), message: nil, buttons: [
                .destructive(Text("Delete Post"), action: {
                   // deletePost(postID: post.postID)
                    self.backtoprofile.toggle()
                
                })
                ,
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
    
    func backtopro() {
        if backtoprofile {
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func deletePost(postID: String) {
        DataService.instance.deletePost(postID: postID)
        
        let ecncodedPostID = postID.replacingOccurrences(of: "/", with: "%2F")
        
        ImageManager.instance.deletePostImage(postID: ecncodedPostID)
        
    }
    
    func reportPost(reason: String) {
        print("REPORT POST NOW")
        
        DataService.instance.uploadReport(reason: reason, postID: post.postID) { success in
            if success {
                ProgressHUD.showSuccess("Post succesfully reported. \n we will review it shortly adn tke the appropriate action!")
            } else {
                ProgressHUD.showError("There was an error uploading the report. \n Please restart the app and try again.")
            }
        }
        
    }
    
    func unlikePost() {
        guard let userID = currentUserID else {
            print("Cannot find userID while liking post")
            return
        }

        let updatedPost = PostModel(postID: post.postID, userID: post.userID, username: post.username,caption: post.caption, dateCreated: post.dateCreated, likeCount: post.likeCount - 1, likedByUser: false)
        self.post = updatedPost
        DataService.instance.unlikePost(postID: post.postID, currentUserID: userID)
    }
}

struct PostView_Previews: PreviewProvider {
    static var post: PostModel = PostModel(postID: "",  userID: "", username: "Fukome var",caption: "this is good photo", dateCreated: Date(), likeCount: 0, likedByUser: false)
    static var previews: some View {
        PostView(post: post, showHeaderAndFooter: true, addheartAnimationToView: true)
    }
}
