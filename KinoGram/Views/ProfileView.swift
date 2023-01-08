//
//  ProfileView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI

struct ProfileView: View {
    var isMyprofile: Bool
    
    @State var profileDisplayName: String
    var profileUserID: String
    @State var profileImage: UIImage = UIImage(named: "logo.loading")!
    
    var posts: PostArrayObject
    
    @State var showSetting: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    ProfileHeaderView(profileDisplayName: $profileDisplayName, profileImage: $profileImage)
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
                    print(profileUserID)
                }
                .sheet(isPresented: $showSetting) {
                    SettingsView()
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
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isMyprofile: true, profileDisplayName: "Samkharag", profileUserID: "", posts: PostArrayObject(userID: ""))
    }
}
