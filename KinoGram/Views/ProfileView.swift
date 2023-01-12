//
//  ProfileView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD
struct ProfileView: View {
    var isMyprofile: Bool
    
    @State var profileDisplayName: String
    var profileUserID: String
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    @State var profileBio: String = ""
    var posts: PostArrayObject
    
    @State var showSetting: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage, postArray: posts, profileBio: $profileBio)
                    Divider()
                    ImageGridView(posts: posts)
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        
                                        Button(action: {
                    showSetting.toggle()
                }, label: {
                    Image(systemName: "line.horizontal.3")
                       
                })
                                            .accentColor(.primary)
                                            .opacity(isMyprofile ? 1.0 : 0.0)
                                            
                                    
                )
                .onAppear {
                    getProfileImage()
                    getAdditionalProfileInfo()
                    print(isMyprofile)
                }
                .sheet(isPresented: $showSetting) {
                    SettingsView(userDisplayName: $profileDisplayName, userBio: $profileBio, userProfilePicture: $profileImage)
                }
            }
        }
    }
    // MARK: FUNTIONS
    func getProfileImage() {
        ImageManager.instance.downloadProfileImage(userID: profileUserID) { image in
        
            if image != nil {
                self.profileImage = image!
            }
        }
    }
    func getAdditionalProfileInfo() {
        AuthService.instance.getUserInfo(forUserID: profileUserID) { name, bio, error in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                print(error?.localizedDescription)
            }
            if let displayName = name {
                self.profileDisplayName = name!
            }
            if let bio = bio {
                self.profileBio = bio
            }
        }
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isMyprofile: true, profileDisplayName: "Samkharag", profileUserID: "", posts: PostArrayObject(userID: ""))
    }
}
