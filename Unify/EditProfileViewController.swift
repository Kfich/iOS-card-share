//
//  EditProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/31/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka
import MBPhotoPicker

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    // ----------------------------------
    var currentUser = User()
    
    var photo = MBPhotoPicker()
    
    var profileImage = UIImage()
    
    // Parsed profile arrays
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    
    // IBOutlets
    // ----------------------------------
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var selectProfileImageButton: UIButton!
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var doneButton: UIButton!
    
    // Table view to hold custom rows
    @IBOutlet var collectionTableView: UITableView!
    
    
    // IBActions
    // ----------------------------------
    @IBAction func selectProfilePicture(_ sender: AnyObject) {
        
        // Add code to edit photo here
        photo.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            /*
             self.firstName.becomeFirstResponder()
             
             self.hasProfilePic = true
             
             
             self.profileImageContainerView.image = image
             global_image = image*/
            
            print("Selected image")
            
            // Change button text
            //self.selectProfileImageButton.titleLabel?.text = "Change"
            
            // Set image to view
            self.profileImageView.image = image
            
            // Previous location for image assignment to user object
            
            
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
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        // Drop the keyboard
        self.view.endEditing(true)
        
        // Set Manager intent switch to true 
        ContactManager.sharedManager.userSelectedEditCard = true
        
        // Post notification 
        self.postNotification()
        
        //print("Printing from the edit page")
        // Execute call to send to server 
        //self.updateCurrentUser()
        
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        // Reassign to the OG user object
        if let user = UDWrapper.getDictionary("user"){
            // Assign current user to manager object
            //
            
            print("USER DICTIONARY")
            print(user)
            
            print("User has profile!")
            ContactManager.sharedManager.currentUser = User(withDefaultsSnapshot:user)
            
            print("CURRENT USER from edit profile cancel action ")
            ContactManager.sharedManager.currentUser.printUser()
        }
        
        // Dismiss VC
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Check for image, set to imageview
        if currentUser.profileImages.count > 0{
            profileImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        
        // Do any additional setup after loading the view.
        //firstNameTextField.inputAccessoryView = doneButton
        
        // Configure done button in nav bar 
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneEditingProfile))
        
        links = ["https://www.facebook.com/", "https://www.twitter.com/", "https://www.instagram.com/", "https://www.snapchat.com/", "https://www.linkedin.com/", "https://www.pinterest.com/", "https://www.tumblr.com/", "https://www.reddit.com/", "https://www.myspace.com/", "https://www.googleplus.com/"]
        
        // Create list for parsing values
        self.initializeBadgeList()
        
        
        // For notifications 
        self.addObservers()
        
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Get social icons 
        self.parseForSocialIcons()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // 
        return 2
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? CollectionTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        //tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
     func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard cell is CollectionTableViewCell else { return }
        
        //storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    
    
    // Custom Methods
    // ----------------------------------
    
    func addObservers() {
        // Call to refresh table
        //NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.showSocialMediaSelection), name: NSNotification.Name(rawValue: "RefreshProfile"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.parseForSocialIcons), name: NSNotification.Name(rawValue: "RefreshEditProfile"), object: nil)
        
        // Update user
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.uploadEditedUser), name: NSNotification.Name(rawValue: "UpdateCurrentUserProfile"), object: nil)
        
    }
    
    
    func uploadEditedUser() {
        
        print("Kevyyy")
        // update
       self.updateCurrentUser()
    }
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ParseProfileForEdit"), object: self)
        
    }
    
    func postNotificationForRefresh() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProfile"), object: self)
        
    }
    
    func parseForSocialIcons() {
        
        
        print("PARSING for icons from edit profile vc")
        // Remove all items from badges
        self.socialBadges.removeAll()
        self.socialLinks.removeAll()
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
            }
        }
        
        // Add plus icon to list
        
        // Iterate over links[]
        for link in self.socialLinks {
            // Check if link is a key
            print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // Test 
                //print("Item >> \(item.first?.key)")
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    print("exists")
                    
                    // Append link to list
                    self.socialBadges.append(item.first?.value as! UIImage)
                    
                    /*if !socialBadges.contains(item.first?.value as! UIImage) {
                        print("NOT IN LIST")
                        // Append link to list
                        self.socialBadges.append(item.first?.value as! UIImage)
                    }else{
                        print("ALREADY IN LIST")
                    }*/
                    // Append link to list
                    //self.socialBadges.append(item.first?.value as! UIImage)
                    
                    
                    
                    //print("THE IMAGE IS PRINTING")
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            self.collectionTableView.reloadData()
        }
        
        // Add image to the end of list
        let image = UIImage(named: "icn-plus-blue")
        self.socialBadges.append(image!)
        
        // Reload table
        self.collectionTableView.reloadData()
        
    }
    
    
    func showSocialMediaSelection() {
        // Init ViewController for social
        self.performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        
    }
    
    func doneEditingProfile() {
        // Bring a manager here to handle setting the inputs back and forth
        
        print("Done editing")
    }
    
    func initializeBadgeList() {
        // Image config
        let img1 = UIImage(named: "icn-social-facebook.png")
        let img2 = UIImage(named: "icn-social-twitter.png")
        let img3 = UIImage(named: "icn-social-instagram.png")
        let img4 = UIImage(named: "icn-social-harvard.png")
        let img5 = UIImage(named: "icn-social-pinterest.png")
        let img6 = UIImage(named: "icn-social-pinterest.png")
        let img7 = UIImage(named: "icn-social-facebook.png")
        let img8 = UIImage(named: "icn-social-facebook.png")
        let img9 = UIImage(named: "icn-social-facebook.png")
        let img10 = UIImage(named: "icn-social-facebook.png")
        
        // Hash images
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["harvard" : img4!], ["pinterest" : img5!]]/*, ["pinterest" : img6!], ["reddit" : img7!], ["tumblr" : img8!], ["myspace" : img9!], ["googleplus" : img10!]]*/
        
    
       // let fb : NSDictionary = ["facebook" : img1!]
       // self.socialLinkBadges.append([fb])
        
        
    }
    
    
    
    
    func updateCurrentUser() {
        // Configure to send to server 
        
        // Assign current user object
        
        // Send to server
        let parameters = ["data" : ContactManager.sharedManager.currentUser.toAnyObject(), "uuid" : ContactManager.sharedManager.currentUser.userId] as [String : Any]
        print("\n\nThe user update")
        print(parameters)
        
        
        // Show progress hud
        KVNProgress.show(withStatus: "Updating profile...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        
        Connection(configuration: nil).updateUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("User updated Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                
                // Store user to device
                UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
                
                // Refresh profile
                self.postNotificationForRefresh()
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Profile updated successfully!")
                
                // Nav out the view
                self.navigationController?.popViewController(animated: true)
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        if segue.identifier == "showSocialMediaOptions" {
            // Set destination 
            /*let nextVC = segue.destination as! SocialMediaViewController
            // Image config
            let img1 = UIImage(named: "icn-social-facebook.png")
            let img2 = UIImage(named: "icn-social-twitter.png")
            let img3 = UIImage(named: "icn-social-instagram.png")
            let img4 = UIImage(named: "icn-social-facebook.png")
            let img5 = UIImage(named: "icn-social-facebook.png")
            let img6 = UIImage(named: "icn-social-pinterest.png")
            let img7 = UIImage(named: "icn-social-facebook.png")
            let img8 = UIImage(named: "icn-social-facebook.png")
            let img9 = UIImage(named: "icn-social-facebook.png")
            let img10 = UIImage(named: "icn-social-facebook.png")
            
            let thumbnailImageList = [img1!, img2!, img3!, img4!, img5!, img6!, img7!, img8!, img9!, img10!]
            
            // Set the image
            nextVC.thumbnailImageList = thumbnailImageList*/
        }
     }
    
    
}

extension EditProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.socialBadges.count != 0 {
            // Return the count 
            return self.socialBadges.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //cell.backgroundColor = model[collectionView.tag][indexPath.item]
        //cell.backgroundColor = UIColor.blue
        
        /*if self.socialBadges.count == 0 {
            // Set default cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            // Set the cell
            //icn-plus-blue
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
            let image = UIImage(named: "icn-plus-blue")
            
            // Set image
            imageView.image = image
            
            
            // Add subview
            cell.contentView.addSubview(imageView)
            collectionView.addSubview(cell)
            
        }else{*/
        
            
            configureViews(cell: cell)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
       // }
        
        
        /*if indexPath.row == indexPath.las{
            // Set default cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            // Set the cell
            //icn-plus-blue
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
            let image = UIImage(named: "icn-plus-blue")
            
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
            collectionView.addSubview(cell)
        }*/
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func configureViews(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 23.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
        
        
        // Add radius config & border color
        /*cell.mediaImageView.layer.cornerRadius = 12.0
         cell.mediaImageView.clipsToBounds = true
         cell.mediaImageView.layer.borderWidth = 0.5
         cell.mediaImageView.layer.borderColor = UIColor.clear.cgColor
         
         // Set shadow on the container view
         cell.layer.shadowColor = UIColor.black.cgColor
         cell.layer.shadowOpacity = 1.5
         cell.layer.shadowOffset = CGSize.zero
         cell.layer.shadowRadius = 2*/
    }
    
    func reloadCollectionData() {
        // Reload
        
        
        
    }
    
    
    
    
    

}





