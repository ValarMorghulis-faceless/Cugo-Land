//
//  TabBarView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case search = 1
    case messages = 2
    case upload = 3
    case profile = 4
}

struct TabBarView: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            
            Button(action: {
                selectedTab = .home
                
            }, label: {
                TabBarButton(buttonText: "Feed", imageName: "house", isActive: selectedTab == .home)
            })
            .tint(selectedTab == .home ? .buttonColor :  Color(.secondaryLabel)  )
            
            Button(action: {
                selectedTab = .search
            }, label: {
                TabBarButton(buttonText: "Browse", imageName: "magnifyingglass", isActive: selectedTab == .search)
            })
            .tint(selectedTab == .search ? .buttonColor :  Color(.secondaryLabel)  )
            Button(action: {
                selectedTab = .messages
            }, label: {
                TabBarButton(buttonText: "Messages", imageName: "message", isActive: selectedTab == .messages)
            })
            .tint(selectedTab == .messages ? .buttonColor :  Color(.secondaryLabel)  )
            Button(action: {
                selectedTab = .upload
            }, label: {
                TabBarButton(buttonText: "Upload", imageName: "square.and.arrow.up", isActive: selectedTab == .upload)
            })
            .tint(selectedTab == .upload ? .buttonColor :  Color(.secondaryLabel)  )
            
            Button(action: {
                selectedTab = .profile
            }, label: {
                TabBarButton(buttonText: "Profile", imageName: "person.crop.circle", isActive: selectedTab == .profile)
            })
            .tint(selectedTab == .profile ? .buttonColor :  Color(.secondaryLabel)  )
            
            
            
        
        }
        
        .frame(height: 70)
        //.background(.primary)
        
        
    }
        
        
       
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(selectedTab: .constant(.home))
         //  .preferredColorScheme(.dark)
            
    }
}
