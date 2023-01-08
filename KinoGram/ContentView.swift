//
//  ContentView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import SwiftUI

struct ContentView: View {
   
    
    @ObservedObject var mng: AppStateManager = AppStateManager()
    @ObservedObject var gmn: SignInWithGoogle = SignInWithGoogle()
    var body: some View {
        MainView()
            .environmentObject(mng)
            .environmentObject(gmn)
           

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
           
        
    }
}
