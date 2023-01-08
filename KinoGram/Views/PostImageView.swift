//
//  PostImageView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD

struct PostImageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var caprionText: String = ""
    @Binding var imageSelected: UIImage
    
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
                }
            .accentColor(.primary)
                Spacer()
                
            }
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    Image(uiImage: imageSelected)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200, alignment: .center)
                        .cornerRadius(12)
                        .clipped()
                    
                    TextField("Add your caption here..", text: $caprionText)
                        .padding()
                        .frame(height: 60)
                        .frame(maxWidth:.infinity)
                        .background(Color.gray.opacity(0.2))
                        .font(.headline)
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .autocapitalization(.sentences)
                    
                    Button {
                        postPicture() { error in
                            if error != nil {
                                print(error?.localizedDescription)
                                ProgressHUD.showError(error?.localizedDescription)
                                
                            }
                            ProgressHUD.showSuccess("Success")
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                    } label: {
                        Text("Post Picture!".uppercased())
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding()
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .background(Color(.blue))
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .accentColor(Color.white)

                        
                }
                
                
            }

        }
    }
    func postPicture(handler: @escaping (_ error: Error?) -> Void) {
        guard let userID = currentUserID, let displayName = currentUserDisplayName else {
            print("Error getting userID or displayname while posting image")
            return
        }
        DataService.instance.uploadPost(image: imageSelected, caption: caprionText, displayName: displayName, userID: userID) { error in
            handler(error)
            print("USER ID IN POSTIMAGEVIEW:",userID)
            if error != nil {
                print(error?.localizedDescription)
                
            }
        }
        
    }
}

struct PostImageView_Previews: PreviewProvider {
    @State static var image = UIImage(named: "dog1")!
    static var previews: some View {
        PostImageView( imageSelected: $image)
    }
}
