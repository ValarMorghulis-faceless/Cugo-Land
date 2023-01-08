//
//  OnboardingViewPart2.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD

struct OnboardingViewPart2: View {
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    @Binding var displayName: String
    @Binding var email: String
    @Binding var providerID: String
    @Environment(\.presentationMode) var presentationMode
    
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("What's your name?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(.white)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
            
            Button(action: {
                showImagePicker.toggle()
            }, label: {
                Text("Finish: Add profile picture")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(.yellow)
                    .cornerRadius(12)
                    .padding(.horizontal)
            })
            .accentColor(Color(.purple))
            .opacity(displayName != "" ? 1.0 : 0.0)
            .animation(.easeOut(duration: 1.0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.purple))
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker,onDismiss: createProfile ) {
            ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
        }
    }
    // MARK: FUNCTIONS
    func createProfile() {
        print("CREATE PROFILE NOW")
        AuthService.instance.createNewUserInDatabase(name: displayName, email: email, providerID: providerID, provider: "https://accounts.google.com", profileImage: imageSelected) { userID, error  in
            if let userID = userID {
                // SUCCESS
                print("SUccessfully created new user in database.")
                AuthService.instance.logInUserToApp(userID: userID) { error in
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.presentationMode.wrappedValue.dismiss()

                        }
                    }
                }
            } else {
                // ERROR
                ProgressHUD.showError(error?.localizedDescription)
                print("Error creating user in Database")
            }
        }
    }
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    @State static var testString: String = "Test"
    static var previews: some View {
        OnboardingViewPart2(displayName: $testString, email: $testString, providerID: $testString)
    }
}
