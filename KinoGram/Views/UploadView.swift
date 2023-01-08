//
//  UploadView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI
import UIKit

struct UploadView: View {
    
    @State var showImagePicker: Bool = false
    @State var imageSelected: UIImage = UIImage(named: "logo")!
    
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var showPostImageView: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    sourceType = UIImagePickerController.SourceType.camera
                    showImagePicker.toggle()
                }, label: {
                    VStack(spacing: 25) {
                        Text("Take photo".uppercased())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.buttonColor)
                        Image(systemName: "camera")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.buttonColor)
                    }
                
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color.white)
                Button(action: {
                    sourceType = UIImagePickerController.SourceType.photoLibrary
                    showImagePicker.toggle()
                }, label: {
                    VStack(spacing: 25) {
                        Text("Upload photo".uppercased())
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Image(systemName: "photo.stack")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(Color(.blue))
            }
            .sheet(isPresented: $showImagePicker, onDismiss: segueToPostImageView) {
                ImagePicker(imageSelected: $imageSelected, sourceType: $sourceType)
            }
            
            Text("CHOOSE UPLOAD")
                .padding()
                .font(.system(size: 30))
                .frame(width: 280, height: 80)
                .foregroundColor(.white)
                .background(Color(.black))
                .cornerRadius(30)
                .fullScreenCover(isPresented: $showPostImageView) {
                    PostImageView(imageSelected: $imageSelected)
                }
            
        }
    }
    func segueToPostImageView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showPostImageView.toggle()
        }
        
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
    }
}
