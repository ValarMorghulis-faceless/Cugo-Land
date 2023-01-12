//
//  MainView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var appState: AppStateManager
    @EnvironmentObject private var googleSing: SignInWithGoogle
    @AppStorage(CurrentUserDefaults.userID) var currentUserID: String?
    @AppStorage(CurrentUserDefaults.displayName) var currentUserDisplayName: String?
    
    
    func correctViewForState() -> some View {
        switch appState.selectedTab {
        case .feed:
            let view = FeedView(posts: PostArrayObject(userID: currentUserID ?? "ASD", shuffled: false), title: "Feed")
            return AnyView(view)
        case .search:
            let view = BrowseView(posts: PostArrayObject(userID: currentUserID ?? "asd", shuffled: true))
            return AnyView(view)
        case .messages:
            let view = Text("Messages")
            return AnyView(view)
        case .upload:
            let view = UploadView()
            return AnyView(view)
        case .profile:
            if let userID = currentUserID, let displayname = currentUserDisplayName {
                return (AnyView(ProfileView(isMyprofile: true, profileDisplayName: displayname, profileUserID: userID, posts: PostArrayObject(userID: userID))))
            } else {
                return (AnyView(SignUpView()))
            }
            
            
        }
    }
    
    var body: some View {
          ZStack {
              Color(.systemGray6)
                  .opacity(0.35)
                  .edgesIgnoringSafeArea(.vertical)
              
              
             
              VStack {
               //  Spacer()
                  correctViewForState()
                     
                  
                  HStack() {
                      
                      TabBarButtonView(type: .feed, text: .feed)
                      
                      TabBarButtonView(type: .search, text: .search)
                      
                      TabBarButtonView(type: .upload, text: .upload)
                      
                      TabBarButtonView(type: .messages, text: .messages)
                      
                      TabBarButtonView(type: .profile, text: .profile)

                  }
                  .frame(height: 70)
                 // .background(Color.white)
                  .padding(.bottom, -15)
                  .overlay(Rectangle().frame(width: nil, height: 1, alignment: .top).foregroundColor(Color.gray.opacity(0.3)), alignment: .top)

              }
              .ignoresSafeArea(.keyboard,edges: .bottom)
              

              
              

          }

      
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppStateManager())
            .environmentObject(SignInWithGoogle())
            .preferredColorScheme(.light)
            
    }
}
