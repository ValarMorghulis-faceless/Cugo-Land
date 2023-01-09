//
//  SettingsView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var googleSign: SignInWithGoogle = SignInWithGoogle()
    
    @Binding var userDisplayName: String
    @Binding var userBio: String
    @Binding var userProfilePicture: UIImage
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    // MARK: Section 1 : KINOGRAM
                    GroupBox(label: SettingsLabelView(labelText: "KinoGram", labelImage: "dot.radiowaves.left.and.right")) {
                        HStack(alignment: .center, spacing: 10) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80, alignment: .center)
                                .cornerRadius(12)
                            Text("Thi sapp is just dope ther is nothing more to say man...")
                                .font(.footnote)
                        }
                    }
                    .padding()
                    // MARK: Section 2: PROFILE
                    GroupBox(label: SettingsLabelView(labelText: "Profile", labelImage: "person.fill")) {
                        
                        NavigationLink(destination: {
                            SettingsEditTextView(submissionText: userDisplayName, title: "Display Name", description: "You can edit your display name here. This will be seen by other users on your profile and on your posts!", placeholder: "Your display name here...", settingsEditTextOption: .displayName, profileText: $userDisplayName)
                        }, label: {
                            SettingRowView(leftIcon: "pencil", text: "Display Name", color:Color(.purple))
                        })
                        
                        NavigationLink(destination: {
                            SettingsEditTextView(submissionText: userBio, title: "Profile Bio", description: "Your bio is great place to let other users know a little about you. It will be shown on your profile", placeholder: "Your Bio here...", settingsEditTextOption: .bio, profileText: $userBio)
                        }, label: {
                            SettingRowView(leftIcon: "text.quote", text: "bio", color: Color(.purple))
                        })
                       
                        NavigationLink(destination: {
                            SettingsEditImageView(title: "Progile Picture", description: "Your profile picture will be shown on your profile and on your posts. Most users make it an image of themselves or their dog!", selectedImage: userProfilePicture, profileImage: $userProfilePicture)
                        }, label: {
                            SettingRowView(leftIcon: "photo", text: "Profile Picture", color: Color(.purple))
                        })
                        
                        Button(action: {
                           signOut()
                        }, label: {
                            SettingRowView(leftIcon: "figure.walk", text: "Sign Out", color: Color(.purple))

                        })
                        
                    }
                    .padding()
                    
                    // MARK: SECTION 3: APPLICATION
                    GroupBox(label: SettingsLabelView(labelText: "Application", labelImage: "apps.iphone")) {
                        
                        Button(action: {
                            openCustomURL(urlString: "https:///www.google.com")
                        }, label: {
                            SettingRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color(.blue))
                        })
                        Button(action: {
                            openCustomURL(urlString: "https:///www.yahoo.com")
                        }, label: {
                            SettingRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color(.orange))
                        })
                        Button(action: {
                            openCustomURL(urlString: "https:///www.bing.com")
                        }, label: {
                            SettingRowView(leftIcon: "globe", text: "KinoGram's Website", color: Color(.orange))
                        })
                           
                           
                           
                    }
                    .padding()
                    
                    // MARK: SECTION 4: Sign OFF
                    GroupBox {
                        Text("KinoGram was made with love . \n All Rights Reserved \n Cool Apps Inc. \n Copyright 2020 ")
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .padding(.bottom, 80)
                
                    
                }
            }
            .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .navigationBarItems(leading:
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.title)
        })
            .accentColor(.primary)
        )
        }
    }
    
    // MARK: FUNCTIONS
    func openCustomURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        if UIApplication.shared.openURL(url) {
            UIApplication.shared.open(url)
        }
    }
    func signOut() {
        AuthService.instance.logOutUSer { error in
            if error != nil {
                print(error?.localizedDescription)
                ProgressHUD.showError(error?.localizedDescription)
            } else {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    @State static var testString: String = ""
    @State static var image: UIImage = UIImage(named: "dog1")!
    static var previews: some View {
        SettingsView(userDisplayName: $testString, userBio: $testString, userProfilePicture: $image)
    }
}
