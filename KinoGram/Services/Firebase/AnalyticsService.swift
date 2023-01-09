//
//  AnalyticsService.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 09.01.23.
//

import Foundation
import FirebaseAnalytics

class AnalyticsService {
    static let instance = AnalyticsService()
    
    func likePostDoubleTap() {
        Analytics.logEvent("like_double_tap", parameters: nil)
        
    }
    func likePostHeartPressed() {
        Analytics.logEvent("like_heart_clicked", parameters: nil)

    }
}
