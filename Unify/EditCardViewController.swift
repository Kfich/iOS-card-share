//
//  EditCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 7/24/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MBPhotoPicker

class EditCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
    
    // Selected Items 
    var selectedBios = [String]()
    var selectedWorkInformation = [String]()
    var selectedOrganizations = [String]()
    var selectedTitles = [String]()
    var selectedPhoneNumbers = [String]()
    var selectedEmails = [String]()
    var selectedWebsites = [String]()
    var selectedSocialLinks = [String]()
    var selectedNotes = [String]()
    var selectedTags = [String]()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set current user 
        currentUser = ContactManager.sharedManager.currentUser
        // Set Selected card
        card = ContactManager.sharedManager.selectedCard
        
        // Parse bio info
        self.parseDataFromProfile()
        
        // Parse card for profile info
        self.parseCardForSelections()
    
        
        // Populate the card 
        self.populateCards()
        

        
        // View config
        configureViews()
        
        
        // Photo picker config
        configurePhotoPicker()
        
        // Do any additional setup after loading the view.
        
        
        // Parse the users profile for info
        /*
         emails = ["example@gmail.com", "test@aol.com", "sample@gmail.com" ]
         phoneNumbers = ["1234567890", "6463597308", "3036558888"]
         socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
         organizations = ["crane.ai", "Example Inc", "Sample LLC", "Boys and Girls Club"]
         bios = ["Created a company for doing blank for example usecase", "Full Stack Engineer at Crane.ai", "College Professor at the University of Application Building"]
         websites = ["example.co", "sample.ai", "excuse.me"]
         titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
         workInformation = ["Job 1", "Job 2", "Example Job", "Sample Job"]
         */
        
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
            self.addImageButton.titleLabel?.text = "Change Image"
            
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
        // Set ownerid on card
        card.ownerId = currentUser.userId
        
        // Print card to see if generated
        card.printCard()
        //card.cardProfile.printProfle()
        
        // Add card to manager object card suite
        //ContactManager.sharedManager.currentUserCards.insert(card, at: 0)
        
        // Overwrite card to current user object card suite
    
        
        // Send to server
        
        
        let parameters = ["data" : card.toAnyObject(), "uuid" : currentUser.userId] as [String : Any]
         print("\n\nTHE CARD TO ANY - PARAMS")
         print(parameters)
        
        // Store current user cards to local device
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        
        // Show progress hud
        //KVNProgress.show(withStatus: "Saving your new card...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).updateCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
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
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    @IBAction func deleteCard(_ sender: Any) {
        
        // Delete card from local storage
        ContactManager.sharedManager.deleteCardFromArray(cardIdString: self.card.cardId!)
        
        
        
        // Set array to defualts
        UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
        
        
        // Delete card
        
        // Send to server
        let parameters = ["uuid" : card.cardId]
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Show alert 
        KVNProgress.show(withStatus: "Deleting current card ...")
        
        // Connect to server
        Connection(configuration: nil).deleteCardCall(parameters){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                // Remove from manager card array
                //ContactManager.sharedManager.deleteCardFromArray(cardIdString: self.card.cardId!)
                
                // Reset array to defualts
                //UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
                
                // Hide HUD
                KVNProgress.dismiss()
                
                // Post notification for radar view to refresh
                self.postDeleteNotification()
                // Dismiss VC
                /*self.dismiss(animated: true, completion: {
                    // Send to database to update card with the new uuid
                    print("Send to db")
                })*/
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error deleting your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        // Dismiss VC
        self.dismiss(animated: true, completion: {
            // Send to database to update card with the new uuid
            print("Send to db")
        })
        
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
            
            if selectedBios.contains(bios[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case 1:
            //cell.titleLabel.text = "Work \(indexPath.row)"
            cell.descriptionLabel.text = workInformation[indexPath.row]
            
            // Check if in list
            if selectedWorkInformation.contains(workInformation[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }

            return cell
        case 2:
            //cell.titleLabel.text = "Title \(indexPath.row)"
            cell.descriptionLabel.text = titles[indexPath.row]
            
            // Check if in list
            if selectedTitles.contains(titles[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }

            return cell
        case 3:
            //cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            
            // Check if in list
            if selectedEmails.contains(emails[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            
            return cell
        case 4:
            //cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            
            // Check if in list
            if selectedPhoneNumbers.contains(phoneNumbers[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case 5:
            //cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = socialLinks[indexPath.row]
            
            // Check if in list
            if selectedSocialLinks.contains(socialLinks[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case 6:
            //cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = websites[indexPath.row]
            
            // Check if in list
            if selectedWebsites.contains(websites[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            
            return cell
        case 7:
            //cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            
            // Check if in list
            if selectedOrganizations.contains(organizations[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
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
            
            if self.selectedBios.contains(bios[indexPath.row]) {
                // Print Already selected
                print("Item already selected")
                // Most likely show an alert
                selectedBios.remove(at: indexPath.row)
                // Remove from array
                bios.remove(at: indexPath.row)
                
            }else{
                // Append bio to list if not selected
                card.cardProfile.setBioRecords(emailRecords: ["bio" : bios[indexPath.row]])
            }
            
        case 1:
            card.cardProfile.workInfo = workInformation[indexPath.row]
            
            if self.selectedWorkInformation.contains(workInformation[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedWorkInformation.remove(at: indexPath.row)
                // Remove from array 
                workInformation.remove(at: indexPath.row)
            }else{
                // Append to work list
                card.cardProfile.setWorkRecords(emailRecords: ["work" : workInformation[indexPath.row]])
            }
            
        case 2:
            card.cardProfile.title = titles[indexPath.row]
            
            // Check if already selected
            if self.selectedTitles.contains(titles[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedTitles.remove(at: indexPath.row)
                self.titles.remove(at: indexPath.row)
            }else{
                // Add to list
                card.cardProfile.setTitleRecords(emailRecords: ["title" : titles[indexPath.row]])
            }
            // Assign label value
            self.titleLabel.text = titles[indexPath.row]
            
        case 3:
            // Check if in array already
            if self.selectedEmails.contains(emails[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedEmails.remove(at: indexPath.row)
                self.emails.remove(at: indexPath.row)
                
            }else{
                // Append to list
                card.cardProfile.emails.append(["email" : emails[indexPath.row]])
                print(card.cardProfile.emails as Any)
            }
            // Assign label value
            self.emailLabel.text = emails[indexPath.row]
            
        case 4:
            // Check if in array
            if self.selectedPhoneNumbers.contains(phoneNumbers[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedPhoneNumbers.remove(at: indexPath.row)
                self.phoneNumbers.remove(at: indexPath.row)
            }else{
                // Add dictionary value to cardProfile
                card.cardProfile.setPhoneRecords(phoneRecords: ["phone" : phoneNumbers[indexPath.row]])
                // Print for testing
                print(card.cardProfile.phoneNumbers as Any)
            }
            // Assign label value
            self.numberLabel.text = phoneNumbers[indexPath.row]
            
        case 5:
            // Check if in array 
            if self.selectedSocialLinks.contains(socialLinks[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedSocialLinks.remove(at: indexPath.row)
                self.socialLinks.remove(at: indexPath.row)
            }else{
                // Append to array
                card.cardProfile.socialLinks.append(["link" : socialLinks[indexPath.row]])
                // Print for test
                print(card.cardProfile.socialLinks as Any)
            }
        case 6:
            // Check if in array 
            if self.selectedWebsites.contains(websites[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedWebsites.remove(at: indexPath.row)
                self.websites.remove(at: indexPath.row)
            }else{
                // Append to array
                card.cardProfile.websites.append(["website" : websites[indexPath.row]])
                // Print for test
                print(card.cardProfile.websites as Any)
            }
        case 7:
            if self.selectedOrganizations.contains(organizations[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedOrganizations.remove(at: indexPath.row)
                self.organizations.remove(at: indexPath.row)
            }else{
                // Append to array
                card.cardProfile.organizations.append(["organization" : organizations[indexPath.row]])
                // Print for test
                print(card.cardProfile.organizations as Any)
            }
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
    
    // Configuration
    func configureViews(){
        
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 1.5
        self.profileCardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Assign media buttons
        mediaButton1.image = UIImage(named: "icn-social-twitter.png")
        mediaButton2.image = UIImage(named: "icn-social-facebook.png")
        mediaButton3.image = UIImage(named: "icn-social-harvard.png")
        mediaButton4.image = UIImage(named: "icn-social-instagram.png")
        mediaButton5.image = UIImage(named: "icn-social-pinterest.png")
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
    
    // Parse card for selected values
    func parseCardForSelections() {

        // Parse card for profile info
        
        if card.cardProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in card.cardProfile.bios{
                selectedBios.append(bio["bio"]!)
                print(selectedBios.count)
            }
            
        }
        // Parse work info
        if card.cardProfile.workInformationList.count > 0{
            for info in card.cardProfile.workInformationList{
                selectedWorkInformation.append(info["work"]!)
            }
        }
        
        // Parse work info
        if card.cardProfile.titles.count > 0{
            for info in card.cardProfile.titles{
                selectedTitles.append((info["title"])!)
            }
        }

        if card.cardProfile.phoneNumbers.count > 0{
            for number in card.cardProfile.phoneNumbers{
                selectedPhoneNumbers.append(number["phone"]! )
            }
        }
        
        if card.cardProfile.emails.count > 0{
            for email in card.cardProfile.emails{
                selectedEmails.append(email["email"]! )
            }
        }
        if card.cardProfile.websites.count > 0{
            for site in card.cardProfile.websites{
                selectedWebsites.append(site["website"]! )
            }
        }
        if card.cardProfile.organizations.count > 0{
            for org in card.cardProfile.organizations{
                selectedOrganizations.append(org["organization"]! )
            }
        }
        if card.cardProfile.tags.count > 0{
            for hashtag in card.cardProfile.tags{
                selectedTags.append(hashtag["tag"]! )
            }
        }
        if card.cardProfile.notes.count > 0{
            for note in card.cardProfile.notes{
                selectedNotes.append(note["note"]! )
            }
        }
        if card.cardProfile.socialLinks.count > 0{
            for link in card.cardProfile.socialLinks{
                selectedSocialLinks.append(link["link"]! )
            }
        }
    }
    
    
    func parseDataFromProfile() {
        
        // Reset arrays
        self.bios = [String]()
        self.titles = [String]()
        self.emails = [String]()
        self.phoneNumbers = [String]()
        self.socialLinks = [String]()
        self.organizations = [String]()
        self.websites = [String]()
        self.workInformation = [String]()
        
        // Parse bio info
        if currentUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append((bio["bio"])!)
            }
            
        }
        
        // Parse work info
        
        if currentUser.userProfile.workInformationList.count > 0{
            
            for info in currentUser.userProfile.workInformationList{
                workInformation.append((info["work"])!)
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
                phoneNumbers.append((number["phone"])!)
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
                
                socialLinks.append(link["link"]!)
                
            }
        }
        // Refresh table
        cardOptionsTableView.reloadData()
        
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
    
    // Custom Methods
    // -------------------------------------------
    
    func populateCards(){
        // Senders card config
        
        // Populate image view
        if card.cardProfile.images.count > 0{
            profileImageView.image = UIImage(data: card.cardProfile.images[0]["image_data"] as! Data)
        }
        // Populate label fields
        if let name = card.cardHolderName{
            nameLabel.text = name
        }
        if card.cardProfile.phoneNumbers.count > 0{
            numberLabel.text = card.cardProfile.phoneNumbers[0]["phone"]!
        }
        if card.cardProfile.emails.count > 0{
            emailLabel.text = card.cardProfile.emails[0]["email"]
        }
        if let title = card.cardProfile.title{
            titleLabel.text = title
        }
        // Here, parse data to populate tableview
    }
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: self)
        
        
    }
    
    
    func postDeleteNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardDeleted"), object: self)
        
        
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
