//
//  SignInWithAppleButtonCustom.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 04.01.23.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct SignInWithAppleButtonCustom: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}
