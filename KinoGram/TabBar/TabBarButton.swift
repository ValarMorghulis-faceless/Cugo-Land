//
//  TabBarButton.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI



struct TabBarButton: View {
    var buttonText: String
    var imageName: String
    var isActive: Bool
    var body: some View {
        GeometryReader { geo in
            
            if isActive {
                Rectangle()
                    .foregroundColor(Color(.blue))
                    .frame(width: geo.size.width/2, height: 4, alignment: .center)
                    .padding(.leading, geo.size.width/4)
            }
        
            
        VStack(alignment: .center, spacing: 4) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30, alignment: .center)
            
                
            Text(buttonText)
                .font(.system(size: 13).monospaced())
        }
        .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        
        }
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TabBarButton(buttonText: "Chats", imageName: "bubble.left", isActive: true)
    }
}
