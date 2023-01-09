//
//  ImageManager.swift
//  KinoGram
//
//  Created by Giorgi Samkharadze on 05.01.23.
//

import Foundation
import FirebaseStorage

let imageCache = NSCache<AnyObject, UIImage>()

class ImageManager {
    // MARK: PROPERTIES
    
    static let instance = ImageManager()
    
    private var REF_STOR = Storage.storage()
    
    // MARK: PUBLIC FUNCTIONS
        // Functions we call from other places in the app
    func uploadProfileImage(userID: String, image: UIImage) {
        let path = getProfileImagePath(userID: userID)
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { _ in }

        }
    }
    func uploadPostImage(postID: String, image: UIImage, handler: @escaping(_ error: Error?) -> Void) {
        
        let path = getPostImagePath(postID: postID)
        // SAVE IMAGE TO PATH
        DispatchQueue.global(qos: .userInteractive).async {
            self.uploadImage(path: path, image: image) { error in
                if error != nil {
                    print(error?.localizedDescription)
                    
                }
                    DispatchQueue.main.async {
                        handler(error)

                    }
                   
                
            }
        }
      
        
    }
    
    private func getProfileImagePath(userID: String) -> StorageReference {
        let userPath = "users/\(userID)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        return storagePath
    }
    
    private func getPostImagePath(postID: String) -> StorageReference {
      //  let idString = UUID().uuidString
        let postPath = "posts/\(postID)/1"
        let storagePath = REF_STOR.reference(withPath: postPath)
        return storagePath
    }
    
    func downloadProfileImage(userID: String, handler: @escaping (_ image: UIImage?) -> Void) {
        let path = getProfileImagePath(userID: userID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { image in
                DispatchQueue.main.async {
                    handler(image)

                }
            }
        }
        
       
    }
    
    func downloadPostImage(postID: String, handler: @escaping (_ image: UIImage?) -> Void) {
        let path = getPostImagePath(postID: postID)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.downloadImage(path: path) { image in
                DispatchQueue.main.async {
                    handler(image)
                }
            }
        }
        
        
    }
    
    // MARK: PRIVATE FUNCTIONS
    // Functions we call from this file only
    
    private func uploadImage(path: StorageReference, image: UIImage, handler: @escaping(_ error: Error?) -> Void) {
        
        var compression: CGFloat = 1.0
        let maxFileSize: Int = 240 * 240 // Maximum file size that we want to save
        let maxCompression: CGFloat = 0.05
        guard var originalData = image.jpegData(compressionQuality: compression) else {
            handler(fatalError("Error getting data from image"))
            return
        }
        // Check maximum file size
        while originalData.count > maxFileSize && compression > maxCompression {
            compression -= 0.05
            if let compressedData = image.jpegData(compressionQuality: compression) {
                originalData = compressedData
            }
            print(compression)
        }
        
        
        
        guard let finalData = image.jpegData(compressionQuality: compression) else {
            handler(fatalError("Error getting data from image"))
            return
        }
        // Get photo metadata
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        path.putData(finalData, metadata: metadata) { _, error in
            handler(error)
            if error != nil {
                print(error?.localizedDescription)
            } else {
                print("Success uploading image")
            }
         
        }
    }
    func downloadImage(path: StorageReference, handler: @escaping(_ image: UIImage?) -> Void ) {
        if let cachedImage = imageCache.object(forKey: path) {
            print("Image found in cache")
            handler(cachedImage)
            return
        }
        
        path.getData(maxSize: 27 * 1024 * 1024) { returnedImageData, error in
            if let data = returnedImageData, let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: path)
                handler(image)
            } else {
                print("Error getting data from path for image", error?.localizedDescription)
                handler(nil)
                return
            }
        }
        
    }
}
