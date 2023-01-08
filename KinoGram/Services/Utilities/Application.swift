//
//  Application.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 05.01.23.
//

import Foundation
import SwiftUI


final class ApplicationUtility {
    
    static var rootViewController: UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init()
            
        }
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        return root
    }
}
