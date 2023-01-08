//
//  Extensions.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import Foundation
import SwiftUI
import UIKit


extension View {
    @ViewBuilder
    func `if`<Transform: View> (
        _ condition: Bool,
        transform: (Self) -> Transform) -> some View {
            if condition {
                transform(self)
            } else {
                self
            }
        }
}
extension Color {
    static let buttonColor = Color(.blue)
    
}
extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}

struct HideNavigationView: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationTitle("")
            .navigationBarHidden(true)
    }
}
