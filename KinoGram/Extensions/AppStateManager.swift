//
//  AppStateManager.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import Foundation




class AppStateManager: ObservableObject {
    @Published var selectedTab : TabBarButtonType = .feed
    @Published var selectedText : TabBarButtonText = .feed
}
