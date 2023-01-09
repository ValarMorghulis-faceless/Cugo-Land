//
//  LazyView.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 08.01.23.
//

import Foundation
import SwiftUI

struct LazyView<Content: View>: View {
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
