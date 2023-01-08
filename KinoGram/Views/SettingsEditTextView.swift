//
//  SettingsEditTextView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import SwiftUI

struct SettingsEditTextView: View {
    
    @State var submissionText: String = ""
    @State var title: String
    @State var description: String
    @State var placeholder: String
    
    var body: some View {
           NavigationView {
            VStack {
                HStack {
                    Text(description)
                    Spacer(minLength: 0)
                }
                
                TextField(placeholder, text: $submissionText)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .font(.headline)
                    .autocapitalization(.sentences)
                
                Button(action: {
                    
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
}

struct SettingsEditTextView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsEditTextView(title: "Test Title", description: "This is a description", placeholder: "Test Placeholder")
    }
}
