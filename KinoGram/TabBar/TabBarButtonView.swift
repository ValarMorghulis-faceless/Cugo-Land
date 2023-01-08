//
//  TabBarButtonView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

enum TabBarButtonType: String {
    case feed = "house.fill"
    case search = "magnifyingglass"
    case messages = "message"
    case upload = "square.and.arrow.up"
    case profile = "person.crop.circle"
}

enum TabBarButtonText: String {
    case feed = "Feed"
    case search = "Browse"
    case messages = "Messages"
    case upload = "Upload"
    case profile = "Profile"
}


struct TabBarButtonView: View {
    var type : TabBarButtonType
    var text : TabBarButtonText
    @EnvironmentObject var appState: AppStateManager
    var body: some View {
        Button(action: {
            appState.selectedTab = type
        }, label: {
            TabBarButton(buttonText: text.rawValue, imageName: type.rawValue, isActive: appState.selectedTab == type)
                .tint(appState.selectedTab == type ? .buttonColor : Color.gray.opacity(0.5) )
        })
        
    }

}

struct TabBarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarButtonView(type: .feed, text: .feed)
            .environmentObject(AppStateManager())
            
    }
}
