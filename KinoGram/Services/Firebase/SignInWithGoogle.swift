//
//  SignInWithGoogle.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import Foundation
import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseAuth

class SignInWithGoogle: NSObject, ObservableObject {
    
    


    
        enum SignInState {
          case signedIn
          case signedOut
    }
    
  @Published  var state: SignInState = .signedOut
    
   

    
    
    func signInGoogle(completion: @escaping (_ result: GIDSignInResult?, _ error: Error?) -> Void) {
      GIDSignIn.sharedInstance.signIn(
        
        withPresenting: ApplicationUtility.rootViewController) { signInResult, error in
            completion(signInResult,error)
            if error != nil {

                print(error)
            }
          guard let signInResult = signInResult else {
            // Inspect error
            return
          }
                let user = signInResult.user
                let idToken = user.idToken?.tokenString
                let email = user.profile?.email
                let name = user.profile?.name
            let nonce = UUID().uuidString
            var credential = OAuthProvider.credential(withProviderID: "google.com", idToken: idToken!, rawNonce: nonce)
     
            self.loginUserToFirebase(credential: credential) { result, error  in
              //  completion(nil,error)
                if error != nil {
                    print(error)
                }
            }
            
            
             
            }
            
        
      
    }
  
    
    func loginUserToFirebase(credential: AuthCredential, handler: @escaping (_ result: AuthDataResult?, _ isError: Error?) -> Void){
        
        Auth.auth().signIn(with: credential) { result, error in
            handler(result,error)
            if error != nil {
                print(error)
            }
            
            
        }
        
        
    }
    
    
    
    
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
        self.state = .signedOut
    }
    
    
}
