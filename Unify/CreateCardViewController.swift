//
//  CreateCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import MBPhotoPicker


class CreateCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // ----------------------------
    var card = ContactCard()
    var currentUser = User()
    
    var selectedCells = [NSIndexPath]()
    
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
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    
    
    // IBOutlets
    // ----------------------------
    @IBOutlet var cardOptionsTableView: UITableView!

    @IBOutlet var profileCardWrapperView: UIView!
    
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Set image 
        // If user has default image, set as container view
        if currentUser.profileImages.count > 0{
            profileImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Check where user arrived from 
        /*if ContactManager.sharedManager.userSelectedEditCard{
            // Set card to selected card
            self.card = ContactManager.sharedManager.selectedCard
            
            // Populate card and tableviews with card profile info
            
        }*/
        
        // Reset arrays
        self.bios = [String]()
        self.titles = [String]()
        self.emails = [String]()
        self.phoneNumbers = [String]()
        self.socialLinks = [String]()
        self.organizations = [String]()
        self.websites = [String]()
        self.workInformation = [String]()
        
        
        // Set name as default value
        if currentUser.fullName != ""{
            nameLabel.text = currentUser.fullName
        }
        
        // Parse card for profile info
        
        if currentUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
        }
        // Parse work info
        if currentUser.userProfile.workInformationList.count > 0{
            for info in currentUser.userProfile.workInformationList{
                workInformation.append(info["work"]!)
            }
        }
    
        // Parse work info
        if currentUser.userProfile.titles.count > 0{
            for info in currentUser.userProfile.titles{
                titles.append((info["title"])!)
                }
        }
    
        if currentUser.userProfile.phoneNumbers.count > 0{
            for number in currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
        }
        // Parse emails
        if currentUser.userProfile.emails.count > 0{
            for email in currentUser.userProfile.emails{
                emails.append(email["email"]!)
            }
        }
        // Parse websites
        if currentUser.userProfile.websites.count > 0{
            for site in currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
        }
        // Parse organizations
        if currentUser.userProfile.organizations.count > 0{
            for org in currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
        }
        // Parse Tags
        if currentUser.userProfile.tags.count > 0{
            for hashtag in currentUser.userProfile.tags{
                tags.append(hashtag["tag"]!)
            }
        }
        // Parse notes
        if currentUser.userProfile.notes.count > 0{
            for note in currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse socials links
        if currentUser.userProfile.socialLinks.count > 0{
            for link in currentUser.userProfile.socialLinks{
                print("Parsing from the create card VC viewwillappear")
                //socialLinks.append(link["link"]!)
            }
        }
        
        // Parse for social icons
        parseForSocialIcons()

        // View config
        configureViews()
        
        // Photo picker config 
        configurePhotoPicker()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // --------------------------------------------
    
    @IBAction func cancelCardCreation(_ sender: Any) {
        // Drop modal view
        dismiss(animated: true, completion: nil)
    }
    
    
    // Adding prof pic
    
    @IBAction func selectProfileImage(_ sender: Any) {
        
        
        photoPicker.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            // Change button text
            self.addImageButton.titleLabel?.text = "Change"
            
            // Set image to view
            self.profileImageView.image = image
            
            // Pull image data
            /*
            let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.75)
            // Test image data
            print(imageData!)*/
            
           // Previous place for image handling and assingment
            
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
        
        // Assign image for card 
        // Image data png
        let imageData = UIImagePNGRepresentation(self.profileImageView.image!)
        print(imageData!)
        
        // Assign asset name and type
        let fname = "asset.png"
        let mimetype = "image/png"
        
        let idString = currentUser.randomString(length: 20)
        
        // Create image dictionary
        let imageDict = ["image_id":idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        
        // Add image to contact card profile images
        self.card.cardProfile.setImages(imageRecords: imageDict)
        print(imageDict)
    
        // Set user name to card
        card.cardHolderName = currentUser.fullName
        // Assign card image id
        card.cardProfile.imageIds.append(["card_image_id": idString])
        
        // Print card to see if generated
        card.printCard()
        //card.cardProfile.printProfle()
        
        // Add card to manager object card suite
        ContactManager.sharedManager.currentUserCards.insert(card, at: 0)
        print("\n\nUSER Cards\n\n\(ContactManager.sharedManager.currentUserCards)")
        print("\n\nUSER CARD COUNT\n\n\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Add card to current user object card suite
        currentUser.cards.append(card)
        
        
        // Send to server
        
        /*
        let parameters = card.toAnyObject()
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)*/
        
        // Store current user cards to local device 
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        // Set ownerid on card 
        card.ownerId = currentUser.userId
        
        // Show progress hud 
        KVNProgress.show(withStatus: "Saving your new card...")
        
        // Save card to DB
        let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).createCardCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print("New Card ID \(dictionary["uuid"] as? String)")
                self.card.cardId = dictionary["uuid"] as? String
                
                // Insert to manager card array
                ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([self.card.toAnyObjectWithImage()], at: 0)
                
                // Set array to defualts
                UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
                
                // Hide HUD
                KVNProgress.dismiss()
            
                // Post notification for radar view to refresh
                self.postNotification()
                // Dismiss VC
                self.dismiss(animated: true, completion: { 
                    // Send to database to update card with the new uuid
                    print("Send to db")
                })
            
            } else {
                print("Card Created Error Response ---> \(error)")
                // Show user popup of error message 
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
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
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* if self.socialBadges.count != 0 {
         // Return the count
         return self.socialBadges.count
         }else{
         return 1
         }*/
        return self.socialBadges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBadgeCell", for: indexPath)
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        // Configure corner radius
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let image = self.socialBadges[indexPath.row]
        
        // Set image
        imageView.image = image
        
        // Add subview
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
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
            if bios.count != 0 {
                return "Bios"
            }else{
             return ""
            }
        case 1:
            if workInformation.count != 0 {
                return "Work Information"
            }else{
                return ""
            }
        case 2:
            if titles.count != 0 {
                return "Titles"
            }else{
                return ""
            }
        case 3:
            if emails.count != 0 {
                return "Emails"
            }else{
                return ""
            }

        case 4:
            if phoneNumbers.count != 0 {
                return "Phone Numbers"
            }else{
                return ""
            }

        case 5:
            if socialLinks.count != 0 {
                return "Social Media"
            }else{
                return ""
            }

        case 6:
            if websites.count != 0 {
                return "Websites"
            }else{
                return ""
            }

        case 7:
            if organizations.count != 0 {
                return "Organizations"
            }else{
                return ""
            }

        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        // Set checkmark
        cell.accessoryType = selectedCells.contains(indexPath as NSIndexPath) ? .checkmark : .none

        
        switch indexPath.section {
        case 0:
            //cell.titleLabel.text = "Bio \(indexPath.row)"
            cell.descriptionLabel.text = bios[indexPath.row]
            return cell
        case 1:
            //cell.titleLabel.text = "Work \(indexPath.row)"
            cell.descriptionLabel.text = workInformation[indexPath.row]
            return cell
        case 2:
            //cell.titleLabel.text = "Title \(indexPath.row)"
            cell.descriptionLabel.text = titles[indexPath.row]
            return cell
        case 3:
            //cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            return cell
        case 4:
            //cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            return cell
        case 5:
            //cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = socialLinks[indexPath.row]
            return cell
        case 6:
            //cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = websites[indexPath.row]
            return cell
        case 7:
            //cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            return cell
        default:
            return cell
        }

        
        
    }
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create Cell
        _ = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell

        // Set Checkmark
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        selectedCells.append(indexPath as NSIndexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            
            selectedCells = selectedCells.filter {$0 as IndexPath != indexPath}
            
        } else {
            
            selectedCell?.accessoryType = .checkmark
        }

        // Switch case to find right section
        switch indexPath.section {
        case 0:
            card.cardProfile.bio = bios[indexPath.row]
            // Append bio to list
            card.cardProfile.setBioRecords(emailRecords: ["bio" : bios[indexPath.row]])
        case 1:
            card.cardProfile.workInfo = workInformation[indexPath.row]
            // Append to work list
            card.cardProfile.setWorkRecords(emailRecords: ["work" : workInformation[indexPath.row]])
        case 2:
            card.cardProfile.title = titles[indexPath.row]
            // Add to list
            card.cardProfile.setTitleRecords(emailRecords: ["title" : titles[indexPath.row]])
            
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
        
        // reload data 
        cardOptionsTableView.reloadData()
        
        // Print card to test
        //card.printCard()
    }
    
    // Custom Methods
    
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
    
    func parseForSocialIcons() {
        
        // Init badges 
        self.initializeBadgeList()
        
        print("Looking for social icons on profile view")
        
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
        
        // Remove all items from badges
        self.socialBadges.removeAll()
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
            self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    
    func populateViewsForEdit() {
        
        // Set card vals to table
        
    }
    
    
    // Configuration
    func configureViews(){
        
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 1.5
        self.profileCardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Assign media buttons
        /*mediaButton1.image = UIImage(named: "social-blank")
        mediaButton2.image = UIImage(named: "social-blank")
        mediaButton3.image = UIImage(named: "social-blank")
        mediaButton4.image = UIImage(named: "social-blank")
        mediaButton5.image = UIImage(named: "social-blank")
        mediaButton6.image = UIImage(named: "social-blank")
        mediaButton7.image = UIImage(named: "social-blank")*/
        
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
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardCreated"), object: self)
        
        // Notification for Profile Card Suite
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddNewCardFinished"), object: self)
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
