//
//  CreateCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import MBPhotoPicker


class CreateCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Properties
    // ----------------------------
    var card = ContactCard()
    var currentUser = User()
    
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
    
    var isSimulator = false
    
    // Photo picker variable
    var photoPicker = MBPhotoPicker()
    
    
    // IBOutlets
    // ----------------------------
    @IBOutlet var cardOptionsTableView: UITableView!

    @IBOutlet var profileCardWrapperView: UIView!
    
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    
    // Buttons on social toolbar
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    // Action buttons
    
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var addCardNameButton: UIButton!

    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // View config 
        configureViews()
        
        // Photo picker config 
        configurePhotoPicker()
        
        // Do any additional setup after loading the view.
        
        
        // Parse the users profile for info 
        
        emails = ["kfich7@gmail.com", "kfich7@aol.com", "bazzucablaster@gmail.com" ]
        phoneNumbers = ["1234567890", "6463597308", "3036558888"]
        socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
        organizations = ["crane.ai", "Hedgeable Inc", "CleanSwipe LLC", "Boys and Girls Club"]
        bios = ["Created a company for doing laundry on college campuses", "Full Stack Engineer at Crane.ai", "College athlete at the University of Miami"]
        websites = ["cleanswipe.co", "crane.ai", "privii.me"]
        titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
        workInformation = ["crane.ai", "Hedgeable Inc", "CleanSwipe LLC", "Boys and Girls Club"]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // --------------------------------------------
    
    // Adding prof pic
    
    @IBAction func selectProfileImage(_ sender: Any) {
        
        
        photoPicker.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            // Change button text
            self.addImageButton.titleLabel?.text = "Change Image"
            
            // Set image to view
            self.profileImageView.image = image
            
            // Pull image data
            /*
            let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.75)
            // Test image data
            print(imageData!)*/
            
            // Image data png
            let imageData = UIImagePNGRepresentation(self.profileImageView.image!)
            print(imageData!)
            
            // Assign asset name and type
            let fname = "asset.png"
            let mimetype = "image/png"
            
            // Create image dictionary
            let imageDict = ["image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
            
            // Add image to contact card profile images
            self.card.cardProfile.setImages(imageRecords: imageDict)
            print(self.card.cardProfile.images)
            
            //global_image = image
            //self.addProfilePictureBtn.setImage(image, for: UIControlState.normal)
        }
        
        photoPicker.onCancel = {
            print("Cancel Pressed")
        }
        photoPicker.onError = { (error) -> Void in
            print("Photo selection Error")
            print("Error: \(error.rawValue)")
        }
        
        photoPicker.present(self)
 
    }
    
    
    @IBAction func addCardName(_ sender: Any) {
        // Call custom func
        
        showAlertWithTextField(description: "Add Card Name", placeholder: "Enter Name", actionType: "Add Name")
    }
    
    @IBAction func addTags(_ sender: Any) {
        // Call custom func w parameters 
        showAlertWithTextField(description: "Add Hashtags to Card", placeholder: "#hastag", actionType: "Add Tag")
    }
    
    @IBAction func addNotes(_ sender: Any) {
        // Call custom func w parameters
        showAlertWithTextField(description: "Add Card Notes", placeholder: "Enter Note", actionType: "Add Note")
    }
    
    
    
    // Sending card to server
    @IBAction func doneCreatingCard(_ sender: Any) {
        
        
        // Print card to see if generated
        card.printCard()
        //card.cardProfile.printProfle()
        
        // Add card to manager object card suite
        ContactManager.sharedManager.currentUserCards.append(card)
        print("\n\nUSER Cards\n\n\(ContactManager.sharedManager.currentUserCards)")
        print("\n\nUSER CARD COUNT\n\n\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Add card to current user object card suite
        currentUser.cards.append(card)
        
        
        // Send to server
        
        /*
        let parameters = card.toAnyObject()
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)*/
        
        // Save card to DB
        
        /*
        Connection(configuration: nil).createCardCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print(response)
                
                // Here you set the id for the card and resubmit the object
                
                
            } else {
                print(error)
                // Show user popup of error message 
            }
        }
        */
        
        // Post notification for radar view to refresh
        postNotification()
        
        // Dismiss VC
        dismiss(animated: true, completion: nil)
    }
    
    // Photo Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        // Set view to selected image
        self.profileImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bios.count
        case 1:
            return workInformation.count
        case 2:
            return titles.count
        case 3:
            return emails.count
        case 4:
            return phoneNumbers.count
        case 5:
            return socialLinks.count
        case 6:
            return websites.count
        case 7:
            return organizations.count
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Bios"
        case 1:
            return "Work Information"
        case 2:
            return "Titles"
        case 3:
            return "Emails"
        case 4:
            return "Phone Numbers"
        case 5:
            return "Social Media Links"
        case 6:
            return "Websites"
        case 7:
            return "Organizations"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "Bio \(indexPath.row)"
            cell.descriptionLabel.text = bios[indexPath.row]
            return cell
        case 1:
            cell.titleLabel.text = "Work \(indexPath.row)"
            cell.descriptionLabel.text = workInformation[indexPath.row]
            return cell
        case 2:
            cell.titleLabel.text = "Title \(indexPath.row)"
            cell.descriptionLabel.text = titles[indexPath.row]
            return cell
        case 3:
            cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            return cell
        case 4:
            cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            return cell
        case 5:
            cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = socialLinks[indexPath.row]
            return cell
        case 6:
            cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = websites[indexPath.row]
            return cell
        case 7:
            cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            return cell
        default:
            return cell
        }

        
        
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell

        // Mark checkbox selected
        cell.accessoryType = .checkmark

        // Switch case to find right section
        switch indexPath.section {
        case 0:
            card.cardProfile.bio = bios[indexPath.row]
        case 1:
            card.cardProfile.workInfo = workInformation[indexPath.row]
        case 2:
            card.cardProfile.title = titles[indexPath.row]
            
            // Assign label value
            self.titleLabel.text = titles[indexPath.row]
        case 3:
            
            card.cardProfile.emails.append(["email" : emails[indexPath.row]])
            print(card.cardProfile.emails as Any)
            // Assign label value
            self.emailLabel.text = emails[indexPath.row]
           
        case 4:
            // Add dictionary value to cardProfile
            card.cardProfile.setPhoneRecords(phoneRecords: ["phone" : phoneNumbers[indexPath.row]])
            // Print for testing
            print(card.cardProfile.phoneNumbers as Any)
            // Assign label value
            self.numberLabel.text = phoneNumbers[indexPath.row]
            
        case 5:
            card.cardProfile.socialLinks.append(["link" : socialLinks[indexPath.row]])
            // Print for test
            print(card.cardProfile.socialLinks as Any)
        case 6:
            card.cardProfile.websites.append(["website" : websites[indexPath.row]])
            // Print for test
            print(card.cardProfile.websites as Any)
        case 7:
            card.cardProfile.organizations.append(["organization" : organizations[indexPath.row]])
            // Print for test
            print(card.cardProfile.organizations as Any)
        default:
            print("Nothing doing here..")
        }
        
        // Deselect cell
        //Change the selected background view of the cell.
        cardOptionsTableView.deselectRow(at: indexPath, animated: true)
        
        
        // Print card to test
        //card.printCard()
    }
    
    // Custom Methods
    
    
    // Configuration
    func configureViews(){
        
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 1.5
        self.profileCardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Assign media buttons
        mediaButton1.image = UIImage(named: "social-blank")
        mediaButton2.image = UIImage(named: "social-blank")
        mediaButton3.image = UIImage(named: "social-blank")
        mediaButton4.image = UIImage(named: "social-blank")
        mediaButton5.image = UIImage(named: "social-blank")
        mediaButton6.image = UIImage(named: "social-blank")
        mediaButton7.image = UIImage(named: "social-blank")
        
    }

    func configurePhotoPicker() {
        //Initial setup
        photoPicker.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photoPicker.alertTitle = "Select Profile Image"
        photoPicker.alertMessage = ""
        photoPicker.resizeImage = CGSize(width: 150, height: 150)
        photoPicker.allowDestructive = false
        photoPicker.allowEditing = false
        // Set front facing camera
        photoPicker.cameraDevice = .front
        photoPicker.cameraFlashMode = .auto
        
        photoPicker.actionTitleLibrary = "Photo Library"
        photoPicker.actionTitleLastPhoto = "Last Photo"
        photoPicker.actionTitleTakePhoto = "Take Photo"
        photoPicker.actionTitleCancel = "Cancel"
        photoPicker.actionTitleOther = "Import From..."
    }
    
    // Alert Controller to Add CardName
    
    func showAlertWithTextField(description: String, placeholder: String, actionType: String){
        
        // Init alert
        let alertVC = PMAlertController(title: "", description: description, image: nil, style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = placeholder
        }
        
        // Add 'cancel' action
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        // Add 'done' action
        alertVC.addAction(PMAlertAction(title: "Done", style: .default, action: { () in
            print("Capture action OK")
            if alertVC.textFields[0].text != nil{
                
                // Switch Case here to do the appropriate action
                switch actionType {
                case "Add Name":
                    // Take text and add it to the card
                    self.card.cardName = alertVC.textFields[0].text
                    // Set Card Name label text
                    self.addCardNameButton.titleLabel?.text = alertVC.textFields[0].text
                case "Add Tag":
                    // Take text and add it to the card
                    self.card.cardProfile.setTags(tagRecords: ["tag" : alertVC.textFields[0].text!])
                    // Show alert confirmation
                    
                case "Add Note":
                    // Append text to notes
                    self.card.cardProfile.setNotes(noteRecords: ["note" : alertVC.textFields[0].text!])
                    // Show confirmation alert
                    
                default:
                    print("")
                }
            }
        }))
        // Show VC
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // Notifications 
    
    func postNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardCreated"), object: self)
    }

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    

}
