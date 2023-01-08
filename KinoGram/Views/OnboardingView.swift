//
//  OnboardingView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD
import GoogleSignInSwift
import GoogleSignIn
import FirebaseAuth

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2 : Bool = false
    @State var showError: Bool = false
    @ObservedObject var signGoogle: SignInWithGoogle = SignInWithGoogle()
    
    @State var displayName: String = ""
    @State var email: String = ""
    @State var providerID: String = ""
    @State var provider: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            Image("logo.transparent")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100, alignment: .center)
                .shadow(radius: 12)
            
            Text("Welcome to CUGOLAND!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(.purple))
            Text("Really nice app man we really love dogs.")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color(.purple))
            // MARK: SIGN IN WITH APPLE
            Button(action: {
                
                ProgressHUD.showError("Sign in with apple is not working")
            
            }, label: {
                SignInWithAppleButtonCustom()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
            })
          //   MARK: SIGN IN WITH GOOGLE
            Button(action: {
               // showOnboardingPart2.toggle()
            
                signGoogle.signInGoogle { result, error in
                    ProgressHUD.show()
                    if error != nil {
                        ProgressHUD.showError(error?.localizedDescription)
                    } else {
                        let user = result?.user
                        let userID = user?.userID
                        print("USER ID: \(userID)")
                        let proID = user?.idToken?.tokenString
                        self.displayName = (user?.profile!.name)!
                        self.email = (user?.profile!.email)!
                        self.providerID = proID!
                        
                        
                      //  showOnboardingPart2.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            AuthService.instance.checkIfUserExistsInDatabase(userID: userID) { isNewUser, error in
                                if isNewUser!{
                                    ProgressHUD.dismiss()
                                    showOnboardingPart2.toggle()
                                } else {
                                    AuthService.instance.logInUserToApp(userID: userID!) { error in
                                        if error != nil {
                                            print(error?.localizedDescription)
                                        }
                                        ProgressHUD.dismiss()
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }
                        
                    }
                }
                
            }, label: {
                HStack {
                    Image("google.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    Text("Sign in with Google")

                }
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color(.sRGB, red: 222/255, green: 82/255, blue: 70/255, opacity: 1.0))
                        .cornerRadius(6)
                        .font(.system(size: 23, weight: .medium, design: .default))
            })
            .accentColor(.white)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Continue as guest".uppercased())
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
            })
            .accentColor(.black)
            
        }
        .padding(.all, 20)
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showOnboardingPart2, onDismiss: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            OnboardingViewPart2(displayName: $displayName, email: $email, providerID: $providerID)
        }
       
    }
        // MARK: Functions

  
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
