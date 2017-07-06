//
//  CreateAccount-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import Onboard
import UIKit
import PopupDialog
import Contacts
import MBPhotoPicker


class CreateAccountViewController: UIViewController {
    
    // Properties
    // -----------------------------------------------
    
    var store: CNContactStore!
    var hasProfilePic = false
    lazy var photo = MBPhotoPicker()
    
    // User object to assign form fields
    var newUser = User()

    
    // IBOutlets
    // -----------------------------------------------
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var addProfilePictureBtn: UIButton!
    
    @IBOutlet weak var createAccountBtn: UIButton!
    
    @IBOutlet weak var profileImageContainerView: UIImageView!
    
    
    
    // View Prep
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // error here
        firstName.becomeFirstResponder()
        
        // Config Photo Picker
        configurePhotoPicker()
        
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        
    }
    
    
    
    // IBActions
    // -----------------------------------------------
    
    
    @IBAction func AddProfilePicture_click(_ sender: Any) {
        
        photo.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            self.firstName.becomeFirstResponder()
            
            self.hasProfilePic = true
            
            
            self.profileImageContainerView.image = image
            global_image = image
            //self.addProfilePictureBtn.setImage(image, for: UIControlState.normal)

        }
    
        photo.onCancel = {
            print("Cancel Pressed")
        }
        photo.onError = { (error) -> Void in
            print("Photo selection Error")
            print("Error: \(error.rawValue)")
        }
        photo.present(self)
        
        
    }
    
    
    @IBAction func createAccountBtn_click(_ sender: Any) {
        
        
        newUser.firstName = firstName.text!
        newUser.lastName = lastName.text!
        newUser.emails.append(["profile_email": "\(String(describing: email.text))"])
        newUser.profileImage = profileImageContainerView.image!
        
        //newUser.phoneNumbers.append(["profile_phone" : \String(describing: phone)])
        
        // Perfom segue
        performSegue(withIdentifier: "phoneVerificationSegue", sender: self)
        
        
        /*
        
        self.createAccountBtn.isEnabled = false
        

        
        
        print("Processing Profile...", self.hasProfilePic)
        
        if (self.hasProfilePic == false)
        {
            //call function to submit record
            
            processProfile(fileUrl: "")
            
        } else {
            
            //call function to add profile image
            
            let url = NSURL(string: "http://unifyalphaapi.herokuapp.com/storeImages")
            
            var request = URLRequest(url: url! as URL)
            
            request.httpMethod = "POST"
            
            let boundary = self.generateBoundaryString()
            
            request.setValue("multipart/form-data; boundary=\(boundary)",
                forHTTPHeaderField: "Content-Type")
            
            
            
            //if (self.profileImageContainerView.image == nil)
            //{ return }
            
            let image_data = UIImagePNGRepresentation(self.profileImageContainerView.image!)
            
            print(image_data)
            
            
            let body = NSMutableData()
            let fname = "asset.png"
            let mimetype = "image/png"
            
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"photo\"\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append("Incoming\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition:form-data; name=\"files\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: \(mimetype)\r\n\r\n".data(using:
                String.Encoding.utf8)!)
            body.append(image_data!)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
            body.append("--\(boundary)--\r\n".data(using:
                String.Encoding.utf8)!)
            
            request.httpBody = body as Data
            
            let session = URLSession.shared
            
            print("making URL session to connect to services")
            
            let task = session.dataTask(with: request as URLRequest) {
                (
                data, response, error) in
                
                print(response)
                print(error)
                
                guard let _:Data = data, let _:URLResponse = response , error
                    == nil else {
                        print("error")
                        return
                }
                
                let dataString = String(data: data!, encoding:
                    String.Encoding(rawValue: String.Encoding.utf8.rawValue))
                print(dataString)
                
                self.processProfile(fileUrl: dataString!)
                
            }
            
            print(task)
            
            task.resume()
            
            print(task)
           
        }
        */
    }
    
    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    // Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0{
                let height = keyboardSize.height
                
                print("\n\n", self.createAccountBtn.frame.origin.y)
                print(height)
                
                self.createAccountBtn.frame.origin.y = self.view.frame.height - self.createAccountBtn.frame.height - height
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                self.createAccountBtn.frame.origin.y = self.view.frame.height - self.createAccountBtn.frame.height - height
            }
            
        }
    }
    
    
    // Custom Methods
    // ----------------------------------------
    
    func processProfile(fileUrl: String){
        
        // 1. Validate the textbox values
        
        // 2. Show loading indicator
        
        // 3. Upload to /user/create
        
        // 4. if success, perform the segue
        
        
        /*
        global_givenName = "\(firstName.text!) \(lastName.text!)"
        global_email = email.text!
        
        
        let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/onboardProfile")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = "profileImage=\(fileUrl)&firstName=\(self.firstName.text!)&lastName=\(self.lastName.text!)&givenName=\(self.firstName.text!) \(self.lastName.text!)&email=\(self.email.text!)&token="+global_uuid!
        
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            print(dataString)
            
            DispatchQueue.main.async {
                
                // If check passes, show home tab bar
                
                /*
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeTabView") as!
                TabBarViewController
                self.view.window?.rootViewController = homeViewController*/
                
                
                
                
            }
            
        }
        
        task.resume()
        */
    }
    
    
    func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = "yourImageName.jpg"
        
        let yourImage = UIImage(named: "logo")
        
        let imageData = UIImageJPEGRepresentation(yourImage!, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    // Photo Picker Config
    
    func configurePhotoPicker(){
        
        //Initial setup
        photo.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photo.alertTitle = "Select Profile Image"
        photo.alertMessage = ""
        photo.resizeImage = CGSize(width: 150, height: 150)
        photo.allowDestructive = false
        photo.allowEditing = false
        photo.cameraDevice = .front
        photo.cameraFlashMode = .auto
        
        photo.alertTitle = "Select Profile Image"
        photo.alertMessage = ""
        photo.resizeImage = CGSize(width: 150, height: 150)
        photo.allowDestructive = false
        photo.allowEditing = false
        photo.cameraDevice = .front
        
        photo.actionTitleLibrary = "Photo Library"
        photo.actionTitleLastPhoto = "Last Photo"
        photo.actionTitleTakePhoto = "Take Photo"
        
        photo.actionTitleOther = "Import From..."
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    // Navigation 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "phoneVerificationSegue" {
            
            
        }
    }
    

}



