//
//  SettingsEditTextView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD



struct SettingsEditTextView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    @State var settingsEditTextOption: SettingsEditTextOption
    @Binding var profileText: String
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    
    let haptics = UINotificationFeedbackGenerator()
    
    
    var body: some View {
           NavigationView {
            VStack {
                HStack {
                    Text(description)
                    Spacer(minLength: 0)
                }
                
                TextField(placeholder, text: $submissionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .font(.headline)
                    .autocapitalization(.sentences)
                
                Button(action: {
                    if textIsAppropriate() {
                        saveText()
                    }
                }, label: {
                    Text("SAVE")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color(.blue))
                        .cornerRadius(12)
                })
                .accentColor(Color(.white))
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .navigationTitle(title)
        }
    }
    // MARK: FUNCTIONS
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
    func saveText() {
        
        guard let userID = currentUserID else  {
            return
        }
        
        switch settingsEditTextOption {
        case .displayName:
            
            // Update the UI on the Profile
            self.profileText = submissionText
            
            // Update the UserDefaults
            UserDefaults.standard.setValue(submissionText, forKey: CurrentUserDefaults.displayName)
            
            // Update on all of the user's posts
            DataService.instance.updateDisplayNameOnPosts(userD: userID, displayName: submissionText)
            
            
            // Update on the user's profile in DB
            AuthService.instance.updateUserDisplayName(userID: userID, displayName: submissionText) { success in
                if success {
                    ProgressHUD.showSuccess("Success")
                    presentationMode.wrappedValue.dismiss()
                } else {
                    ProgressHUD.showError("Error changing text")
                }
            }
            
        case .bio:
            self.profileText = submissionText
            
            UserDefaults.standard.setValue(submissionText, forKey: CurrentUserDefaults.bio)
            
            AuthService.instance.updateUserBio(userID: userID, bio: submissionText) { success in
                if success {
                    ProgressHUD.showSuccess("Success")
                    haptics.notificationOccurred(.success)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    ProgressHUD.showError("Error changing text")
                }
            }
        
        }
    }
}

struct SettingsEditTextView_Previews: PreviewProvider {
    
    @State static var text: String = ""
    
    static var previews: some View {
        SettingsEditTextView(title: "Test Title", description: "This is a description", placeholder: "Test Placeholder", settingsEditTextOption: .displayName, profileText: $text)
    }
}
