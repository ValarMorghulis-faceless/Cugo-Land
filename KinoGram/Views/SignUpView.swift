//
//  SignUpView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI

struct SignUpView: View {
    
    @State var showOnBoarding: Bool = false
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                
                Spacer()
                
                Image("logo.transparent")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                
                Text("You're not signed in!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color(.purple))
                Text("Click the button below to create an account adn join the fun!")
                    .font(.headline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                Button(action: {
                    showOnBoarding.toggle()
                }, label: {
                    Text("Sign in / Sing up".uppercased())
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.purple))
                        .cornerRadius(12)
                        .shadow(radius: 12)
                })
                .accentColor(.white)
                Spacer()
                Spacer()
            }
            .padding(.all, 40)
        .background(.yellow)
        .fullScreenCover(isPresented: $showOnBoarding) {
            OnboardingView()
        }
        
        }
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
