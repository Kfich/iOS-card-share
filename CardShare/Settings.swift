//
//  Settings.swift
//  Unify
//


import Foundation

// Struct to carry incognito data
class Settings {
    // Properties
    // --------------------
    var name: String = ""
    var image: UIImage = UIImage()
    var imageId: String = ""
    
    
    // Init
    // --------------------
    init() {
        self.name = ""
        self.image = UIImage()
        self.imageId = ""
    }
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    init(snapshot: NSDictionary) {
        
        name = snapshot["name"] as! String
        imageId = snapshot["image_id"] as! String
    }
    
    func setImageId() {
        // Set random string
        // Generate id string for image
        let idString = User().randomString(length: 20)
        
        // Set id string to user object for image
        imageId = idString
    }
    
    func toAnyObject() -> NSDictionary {
        return [
            "name" : name,
            "image_id" : imageId
        ]
    }
    
    // Test
    func printIncognitoData() {
        // Testing
        print("Name : \(name)")
        print("ImageID : \(imageId)")
    }
    
}
