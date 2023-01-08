//
//  ProfileHeaderView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileDisplayName: String
    @Binding var profileImage: UIImage
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            
            
            // MARK: PROFILE PICTURE
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120, alignment: .center)
                .cornerRadius(60)
            
            // MARK: USERNAME
            Text(profileDisplayName)
                .font(.largeTitle)
                .fontWeight(.bold)
            // MARK: BIO
            Text("This is the area of biooo")
                .font(.body)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
            
            
            HStack(alignment: .center, spacing: nil) {
                // MARK: POSTS
                VStack(alignment: .center, spacing: 5) {
                    Text("5")
                        .font(.title2)
                        .fontWeight(.bold)
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    Text("Posts")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                // MARK: LIKES
                VStack(alignment: .center, spacing: 5) {
                    Text("20")
                        .font(.title2)
                        .fontWeight(.bold)
                    Capsule()
                        .fill(Color.gray)
                        .frame(width: 20, height: 2, alignment: .center)
                    Text("LIKES")
                        .font(.callout)
                        .fontWeight(.medium)
                }
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    
    @State static var name: String = "Samkharag"
    @State static var image: UIImage = UIImage(named: "dog1")!
    
    
    static var previews: some View {
        ProfileHeaderView(profileDisplayName: $name, profileImage: $image)
    }
}
