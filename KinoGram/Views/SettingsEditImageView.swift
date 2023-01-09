//
//  SettingsEditImageView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI
import ProgressHUD

struct SettingsEditImageView: View {
    @State var title: String
    @State var description: String
    @State var selectedImage: UIImage // Image shown on this screen
    @Binding var profileImage: UIImage // Image shown on the profile
    @State var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    @State var showsheet: Bool = false
    @AppStorage(CurrentUserDefaults.userID) var currentUserID : String?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
           NavigationView {
               VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(description)
                    Spacer(minLength: 0)
                }
                
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200, alignment: .center)
                    .clipped()
                    .cornerRadius(12)
                   Button(action: {
                       showsheet.toggle()
                   }, label: {
                       Text("IMPORT")
                           .font(.title3)
                           .fontWeight(.bold)
                           .padding()
                           .frame(height: 60)
                           .frame(maxWidth: .infinity)
                           .background(.orange)
                           .cornerRadius(12)
                   })
                   .accentColor(Color(.blue))
                   .sheet(isPresented: $showsheet, content: {
                       ImagePicker(imageSelected: $selectedImage, sourceType: $sourceType)
                   })
                
                Button(action: {
                  saveImage()
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
    
    func saveImage() {
        // Update the UI of the profile
        
        guard let userID = currentUserID else { return }
        self.profileImage = selectedImage
        
        // Update profile image in database
        ImageManager.instance.uploadProfileImage(userID: userID, image: selectedImage)
        presentationMode.wrappedValue.dismiss()
        ProgressHUD.showSuccess("Success")
    }
    
    
}

struct SettingsEditImageView_Previews: PreviewProvider {
    
    @State static var proimage: UIImage = UIImage(named: "dog1")!
    
    static var previews: some View {
        SettingsEditImageView(title: "Title", description: "Description", selectedImage: UIImage(named: "dog1")!, profileImage: $proimage)
    }
}
