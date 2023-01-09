//
//  AuthService.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 05.01.23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import GoogleSignIn

let DB_BASE = Firestore.firestore()

class AuthService {
    
    // MARK: PROPERTIES
    static let instance = AuthService()
    
    var userSession: FirebaseAuth.User?
    
    init() {
       self.userSession = Auth.auth().currentUser
        
    }
    
    private var REF_USERS = DB_BASE.collection("users")
    
    
    // MARK: AUTH USER FUNCTIONS
    

    func logInUserToApp(userID: String, handler: @escaping (_ error: Error?) -> Void) {
        // Get the users info
        getUserInfo(forUserID: userID) { name, bio, error in
            handler(error)
            if error != nil {
                
                print(error?.localizedDescription)
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UserDefaults.standard.set(userID, forKey: CurrentUserDefaults.userID)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)

                }
                // Set the users info to our app
               
                
            }
            
        }
        
    }
    func createNewUserInDatabase(name: String, email: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping(_ userID: String?, _ error: Error?) -> Void){
        // SEt up a user Document with the user Collection
        
        let document = REF_USERS.document((GIDSignIn.sharedInstance.currentUser?.userID)!)
        let userID = (GIDSignIn.sharedInstance.currentUser?.userID)!
        print(userID)
        handler(userID, nil)
        
        // Upload profile image to Storage
        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)
        
        let userData: [String : Any] = [
            DataBaseUserField.displayName : name,
            DataBaseUserField.email : email,
            DataBaseUserField.providerID : providerID,
            DataBaseUserField.userID : userID,
            DataBaseUserField.bio: "",
            DataBaseUserField.dateCreated : FieldValue.serverTimestamp()
        
        ]
        
        document.setData(userData) { error in
            if let error = error {
                handler(nil, error)
                print(error.localizedDescription)
            }
            
        }
    }
    // MARK: GET USER FUNCTIONS
    
    func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ bio: String?, _ error: Error?) -> Void) {
        REF_USERS.document(userID).getDocument { snapshot, error in
            if let document = snapshot, let name = document.get(DataBaseUserField.displayName) as? String, let bio = document.get(DataBaseUserField.bio) as? String, (error == nil) {
                print("Success getting user info")
                handler(name,bio,nil)
                return
            } else {
               handler(nil,nil,error)
                print(error?.localizedDescription)
                return
            }
        }
    }
    func checkIfUserExistsInDatabase(userID: String?, completion: @escaping (_ isNewUser: Bool?, _ error: Error?) -> Void) {
        let userRef = DB_BASE.collection("users").document(userID ?? "no document")
        userRef.getDocument { doc, err in
            print(userID)
            if err != nil {
                print(err?.localizedDescription)
            }
            if let doc = doc, doc.exists {
                completion(false,nil)
             
            } else {
                completion(true,nil)
               
            }
        }
    }

    

    
    
    func logOutUSer(handler: @escaping (_ error: Error?) -> Void) {
        userSession = nil
        do {
            try Auth.auth().signOut()
        } catch {
            handler(error)
            print(error.localizedDescription)
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    let defaults = UserDefaults.standard
//                    defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier)
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        
        }

    }
    
    // MARK: UPDATE USER FUNCTIONS
    
    func updateUserDisplayName(userID: String, displayName: String, handler: @escaping (_ success: Bool) -> Void) {
        let data: [String:Any] = [
        
            DataBaseUserField.displayName : displayName
        
        ]
        
        REF_USERS.document(userID).updateData(data) { error in
            if error != nil {
                print(error?.localizedDescription)
                handler(false)
                return
            } else {
                handler(true)
                return
            }
            
        }
    }
    
    func updateUserBio(userID: String, bio: String, handler: @escaping (_ success: Bool) -> Void) {
        let data: [String:Any] = [
            DataBaseUserField.bio : bio
        ]
        
        REF_USERS.document(userID).updateData(data) { error in
            if error != nil {
                print(error?.localizedDescription)
                handler(false)
                return
            } else {
                handler(true)
                return
            }
            
        }
    }
    
}
