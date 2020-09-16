//
//  ImageURLS.swift
//  Unify
//


import Foundation
import Alamofire

public class ImageURLS{
    
    static let sharedManager = ImageURLS()
    
    // Properties
    // Uploading
    let uploadToStagingURL = "URL"
    let uploadToDevelopmentURL = "URL"

    // Retrieving
    let getFromStagingURL = "URL"
    let getFromDevelopmentURL = "URL"
    
    
    // Init
    init(){}
    
    // Custom Methods
    
    func uploadImageToDev(imageDict: [String : Any]) {
        
        // Create image dictionary
        //let imageDict = ["image_id": idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        
        // Upload to Server
        let parameters = imageDict
        print(parameters)
        
        // Create URL For Test
        let testURL = uploadToDevelopmentURL
        
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageDict["image_data"] as! Data, withName: "files", fileName: "\(imageDict["file_name"] as! String).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            
            // Currently Set to point to Prod Server
        }, to:testURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\n\n\n\n success...")
                    print(response.result.value ?? "Successful upload")
                    
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                //KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
        

    }

    
    func uploadImageToStaging(imageDict: [String : Any]) {
        
        // Create image dictionary
        //let imageDict = ["image_id": idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        
        // Upload to Server
        let parameters = imageDict
        print(parameters)
        
        // Create URL For Staging
        let prodURL = uploadToStagingURL
        
        
        // Show progress HUD
        //KVNProgress.show(withStatus: "Generating profile..")
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageDict["image_data"] as! Data, withName: "files", fileName: "\(imageDict["file_name"] as! String).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            
            // Currently Set to point to Prod Server
        }, to:prodURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\n\n\n\n success...")
                    print(response.result.value ?? "Successful upload")
                    
                    // Dismiss hud
                    //KVNProgress.dismiss()
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                //KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
        
        
        
    }

}
