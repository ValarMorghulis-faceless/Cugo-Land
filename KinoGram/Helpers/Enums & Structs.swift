//
//  Enums & Structs.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 05.01.23.
//

import Foundation


struct DataBaseUserField {
    static let displayName = "display_name"
    static let email = "email"
    static let providerID = "provider_id"
    static let userID = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
}
struct DatabasePostField {
    static let postID = "post_id"
    static let userID = "user_id"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "date_created"
}

struct CurrentUserDefaults {
    static let displayName = "display_name"
    static let bio = "bio"
    static let userID = "user_id"
}
