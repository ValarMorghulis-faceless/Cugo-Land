//
//  PostModel.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 03.01.23.
//

import Foundation
import SwiftUI

struct PostModel: Identifiable, Hashable {
    var id = UUID()
    var postID: String
    var userID: String
    var username: String
    var caption: String?
    var dateCreated: Date
    var likeCount: Int
    var likedByUser: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
    }
    
    // postID
    // userID
    // user username
    // caption - optional
    // date
    // like count
    //liked by current user
}
