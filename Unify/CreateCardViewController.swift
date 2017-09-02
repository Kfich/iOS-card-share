//
//  CreateCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import MBPhotoPicker


class CreateCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, RSKImageCropViewControllerDelegate {
    
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
    var addresses = [String]()
    var corpBadges = [CardProfile.Bagde()]
    
    // Profile pics
    var profileImagelist = [UIImage]()
    
    var isSimulator = false
    
    // Photo picker variable
    var photoPicker = MBPhotoPicker()
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    
    var sections = [String]()
    var tableData = [String: [String]]()
    
    // Struct to check if user selected for radar
    struct Check {
        var index: Int
        var isSelected: Bool // selection state
        
        init(arrayIndex: Int, selected: Bool) {
            index = arrayIndex
            isSelected = selected
        }
    }
    
    var selectedSocialLinkList = [Check]()
    
    var selectedCorpBadgeList = [Check]()

    
    // IBOutlets
    // ----------------------------
    @IBOutlet var cardOptionsTableView: UITableView!

    @IBOutlet var profileCardWrapperView: UIView!
    
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    @IBOutlet var badgeCollectionView: UICollectionView!
    @IBOutlet var profileImageCollectionView: UICollectionView!
    
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
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current user
        currentUser = ContactManager.sharedManager.currentUser
        
        // Set image 
        // If user has default image, set as container view
        if currentUser.profileImages.count > 0{
            profileImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        
        // Add name off jump 
        showAlertWithTextField(description: "Add Card Name", placeholder: "Enter Name", actionType: "Add Name")
        
        // Set shadow
        self.shadowView.shadowRadius = 3
        self.shadowView.shadowMask = YIInnerShadowMaskTop
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
        self.corpBadges.removeAll()
        
        // Set name as default value
        if currentUser.fullName != ""{
            nameLabel.text = currentUser.fullName
        }
        
        // Parse card for profile info
        
        // Parse title info
        if currentUser.userProfile.titles.count > 0{
            // Add section
            sections.append("Titles")
            for info in currentUser.userProfile.titles{
                titles.append((info["title"])!)
            }
            // Create section data
            self.tableData["Titles"] = titles
        }
        
        // Parse organizations
        if currentUser.userProfile.organizations.count > 0{
            // Add section
            sections.append("Company")
            for org in currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
            // Create section data
            self.tableData["Company"] = organizations
        }
        
        if currentUser.userProfile.bios.count > 0{
            // Add section
            sections.append("Bios")
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
            // Create section data
            self.tableData["Bios"] = bios
        }
        /*
        // Parse work info
        if currentUser.userProfile.workInformationList.count > 0{
            // Add section
            sections.append("Work")
            for info in currentUser.userProfile.workInformationList{
                workInformation.append(info["work"]!)
            }
            // Create section data
            self.tableData["Work"] = workInformation
        }*/
    
        if currentUser.userProfile.phoneNumbers.count > 0{
            // Add section
            sections.append("Phone Numbers")
            for number in currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
            // Create section data
            self.tableData["Phone Numbers"] = phoneNumbers
        }
        // Parse emails
        if currentUser.userProfile.emails.count > 0{
            // Add section
            sections.append("Emails")
            for email in currentUser.userProfile.emails{
                emails.append(email["email"]!)
            }
            // Create section data
            self.tableData["Emails"] = emails
        }
        // Parse websites
        if currentUser.userProfile.websites.count > 0{
            // Add section
            sections.append("Websites")
            for site in currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
            // Create section data
            self.tableData["Websites"] = websites
        }
        // Parse Tags
        if currentUser.userProfile.tags.count > 0{
            // Add section
            sections.append("Tags")
            for hashtag in currentUser.userProfile.tags{
                tags.append(hashtag["tag"]!)
            }
            // Create section data
            self.tableData["Tags"] = tags
        }
        // Parse notes
        if currentUser.userProfile.notes.count > 0{
            // Add section
            sections.append("Notes")
            for note in currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
            // Create section data
            self.tableData["Notes"] = notes
        }
        
        // Parse notes
        if currentUser.userProfile.addresses.count > 0{
            
            // Add section
            sections.append("Addresses")
            for add in currentUser.userProfile.addresses{
                addresses.append(add["address"]!)
            }
            // Create section data
            self.tableData["Addresses"] = addresses
        }
        

        
        // Parse socials links
        if currentUser.userProfile.socialLinks.count > 0{
            for link in currentUser.userProfile.socialLinks{
                print("Parsing from the create card VC view willappear")
                //socialLinks.append(link["link"]!)
            }
        }
        
        if currentUser.userProfile.badgeList.count > 0{
            
            for badge in ContactManager.sharedManager.currentUser.userProfile.badgeList{
                // Append badges from proile
                corpBadges.append(badge)
                print("Executing parse call from edit card")
            }
        }
        

        
        // Parse for social icons
        parseForSocialIcons()
        
        // Get images
        parseAccountForImages()

        // View config
        configureViews()
        
        // Photo picker config 
        configurePhotoPicker()
        
        //self.profileInfoTableView.tableHeaderView = profileImageCollectionView
        
        //let container = UIView(frame: CGRect(x: 0, y: 0, width: self.cardOptionsTableView.frame.width, height: 3))
        // container.backgroundColor = UIColor.gray
        //container.addSubview(self.profileImageCollectionView)
        
        
        // Add profile images collection as footer
        self.cardOptionsTableView.tableFooterView = self.profileImageCollectionView
       
        
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
        
        print("The New Card Created Call >> \(card.toAnyObject())")
        
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
        if collectionView == self.badgeCollectionView {
            // Return count
            return ContactManager.sharedManager.currentUser.userProfile.badgeList.count
        }else if collectionView == self.socialBadgeCollectionView{
            
            return self.socialBadges.count
        }else{
            // Profile collection view
            return self.profileImagelist.count
        }
        //return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()//collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //cell.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        if collectionView == self.badgeCollectionView {
            // Badge config
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            
            self.configureBadges(cell: cell)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
             let fileUrl = NSURL(string:ContactManager.sharedManager.badgeList[indexPath.row].pictureUrl /*ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl*/)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            
            // Init add image
            let addView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
            
            if self.selectedCorpBadgeList[indexPath.row].isSelected {
                // Add minus sign
                
                let addImage = UIImage(named: "icn-minus-red")
                addView.image = addImage
                
            }else{
                // Add plus sign
                let addImage = UIImage(named: "icn-plus-green")
                addView.image = addImage
                
            }
            
            // Add to imageview
            imageView.addSubview(addView)
            
            // Add subview
            cell.contentView.addSubview(imageView)
            
        }else if collectionView == self.socialBadgeCollectionView{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            //cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            
            // Init add image
            let addView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
            
            if self.selectedSocialLinkList[indexPath.row].isSelected {
                // Add minus sign
                
                let addImage = UIImage(named: "icn-minus-red")
                addView.image = addImage
                
            }else{
                // Add plus sign
                let addImage = UIImage(named: "icn-plus-green")
                addView.image = addImage
                
            }
            
            
            // Set image
            imageView.image = image
            // Add to imageview
            imageView.addSubview(addView)
            
            
            // Add subview
            cell.contentView.addSubview(imageView)

        
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configurePhoto(cell: cell)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            let image = self.profileImagelist[indexPath.row]
            imageView.layer.masksToBounds = true

            
            // Set image to view
            imageView.image = image
            // Add to collection
            cell.contentView.addSubview(imageView)
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Init cell
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        
        if collectionView == self.badgeCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            // Badge cell
             card.cardProfile.badgeList.append(corpBadges[indexPath.row])
            // Highlight cell
            print("Badge Card List >> \(card.cardProfile.badgeList)")
            
            if self.selectedCorpBadgeList[indexPath.row].isSelected == true {
                // Remove
                self.selectedCorpBadgeList[indexPath.row].isSelected = false
                // Add social to card
                card.cardProfile.badgeList.remove(at: indexPath.row)
            }else{
                // Set selected index
                self.selectedCorpBadgeList[indexPath.row].isSelected = true
                // Add social to card
                card.cardProfile.badgeList.append(corpBadges[indexPath.row])
                
            }
        
        }else if collectionView == self.socialBadgeCollectionView{

            if self.selectedSocialLinkList[indexPath.row].isSelected == true {
                // Remove
                self.selectedSocialLinkList[indexPath.row].isSelected = false
                // Add social to card
                card.cardProfile.socialLinks.remove(at: indexPath.row)
            }else{
                // Set selected index
                self.selectedSocialLinkList[indexPath.row].isSelected = true
                // Add social to card
                card.cardProfile.socialLinks.append(["link" : socialLinks[indexPath.row]])
                
            }
            
            // Highlight cell
            print("Social Card List >> \(card.cardProfile.socialLinks)")
        }else{
            self.profileImageView.image = self.profileImagelist[indexPath.row]
        }
        
        collectionView.reloadData()
        
        //
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // Init view
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "CollectionHeader",
                                                                         for: indexPath)
        return headerView
    }
    
    
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        //cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    func configurePhoto(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 45.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    

    
    // MARK: - Table view data source
 
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        // Set checkmark
        cell.accessoryType = selectedCells.contains(indexPath as NSIndexPath) ? .checkmark : .none
        
        cell.descriptionLabel.text = tableData[sections[indexPath.section]]?[indexPath.row]
        
        return cell
        
    }
    // Set row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor.white
        
        // Add label to the view
        var lbl = UILabel(frame: CGRect(8, 3, 180, 15))
        lbl.text = sections[section]
        lbl.textAlignment = .left
        lbl.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium) //UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
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
        switch sections[indexPath.section] {
        case "Bios":
            card.cardProfile.bio = bios[indexPath.row]
            // Append bio to list
            card.cardProfile.setBioRecords(emailRecords: ["bio" : bios[indexPath.row]])
        case "Work":
            card.cardProfile.workInfo = workInformation[indexPath.row]
            // Append to work list
            card.cardProfile.setWorkRecords(emailRecords: ["work" : workInformation[indexPath.row]])
        case "Titles":
            card.cardProfile.title = titles[indexPath.row]
            // Add to list
            card.cardProfile.setTitleRecords(emailRecords: ["title" : titles[indexPath.row]])
            
            // Assign label value
            self.titleLabel.text = titles[indexPath.row]
        case "Emails":
            
            card.cardProfile.emails.append(["email" : emails[indexPath.row]])
            print(card.cardProfile.emails as Any)
            // Assign label value
            self.emailLabel.text = emails[indexPath.row]
           
        case "Phone Numbers":
            // Add dictionary value to cardProfile
            card.cardProfile.setPhoneRecords(phoneRecords: ["phone" : phoneNumbers[indexPath.row]])
            // Print for testing
            print(card.cardProfile.phoneNumbers as Any)
            // Assign label value
            self.numberLabel.text = phoneNumbers[indexPath.row]
            
        case "Tags":
            card.cardProfile.tags.append(["tag" : tags[indexPath.row]])
            // Print for test
            print(card.cardProfile.socialLinks as Any)
        case "Websites":
            card.cardProfile.websites.append(["website" : websites[indexPath.row]])
            // Print for test
            print(card.cardProfile.websites as Any)
        case "Organizations":
            card.cardProfile.organizations.append(["organization" : organizations[indexPath.row]])
            // Print for test
            print(card.cardProfile.organizations as Any)
        case "Notes":
            // Append to array
            card.cardProfile.notes.append(["note" : notes[indexPath.row]])
            // Print for test
            print(card.cardProfile.notes as Any)
            
        case "Addresses":
            // Append to array
            card.cardProfile.addresses.append(["address" : addresses[indexPath.row]])
            // Print for test
            print(card.cardProfile.addresses as Any)

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
    
    func parseAccountForImages() {
        
        // Clear all from list
        self.profileImagelist.removeAll()
        
        // Check for image, set to imageview
        if ContactManager.sharedManager.currentUser.profileImages.count > 0{
            // Add section
            //sections.append("Photos")
            for img in ContactManager.sharedManager.currentUser.profileImages {
                let image = UIImage(data: img["image_data"] as! Data)
                // Append to list
                self.profileImagelist.append(image!)
            }
            // Create section data
            //self.tableData["Photos"] = profileImagelist
        }
        
        // Refresh table
        //self.profileImageCollectionView.reloadData()
        
        
    }
    
    func initializeBadgeList() {
        // Image config
        // Test data config
        let img1 = UIImage(named: "Facebook.png")
        let img2 = UIImage(named: "Twitter.png")
        let img3 = UIImage(named: "instagram.png")
        let img4 = UIImage(named: "Pinterest.png")
        let img5 = UIImage(named: "Linkedin.png")
        let img6 = UIImage(named: "GooglePlus.png")
        let img7 = UIImage(named: "Crunchbase.png")
        let img8 = UIImage(named: "Youtube.png")
        let img9 = UIImage(named: "Soundcloud.png")
        let img10 = UIImage(named: "Flickr.png")
        let img11 = UIImage(named: "AboutMe.png")
        let img12 = UIImage(named: "Angellist.png")
        let img13 = UIImage(named: "Foursquare.png")
        let img14 = UIImage(named: "Medium.png")
        let img15 = UIImage(named: "Tumblr.png")
        let img16 = UIImage(named: "Quora.png")
        let img17 = UIImage(named: "Reddit.png")
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!]]
        
        
    }
    
    func parseForSocialIcons() {
        
        // Init badges 
        self.initializeBadgeList()
        
        print("Looking for social icons on profile view")
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        var counter = 0
        
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
                
                // Create selected index
                let selectedIndex = Check(arrayIndex: counter, selected: false)
                // Set Selected index
                self.selectedSocialLinkList.append(selectedIndex)
                // Test
                print("Count >> \(socialLinks.count)")
                // Update index
                counter = counter + 1
                print("Counter index >> \(counter)")
            }
        }
        
        
        
        // Remove all items from badges
        self.socialBadges.removeAll()
        // Add plus icon to list
        
        // Iterate over links[]
        for link in self.socialLinks {
            // Check if link is a key
            //print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // Test
                //print("Item >> \(item.first?.key)")
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    //print("exists")
                    
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
                    //print("SOCIAL BADGES COUNT")
                    //print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            //self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        //self.socialBadgeCollectionView.reloadData()
        
    }
    
    
    func populateViewsForEdit() {
        
        // Set card vals to table
        
    }
    
    
    // Configuration
    func configureViews(){
        
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 1
        self.profileCardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Config image
        self.configureSelectedImageView(imageView: self.profileImageView)
        
        // Round borders on table
        self.cardOptionsTableView.layer.cornerRadius = 12.0
        self.cardOptionsTableView.clipsToBounds = true
        self.cardOptionsTableView.layer.borderWidth = 2.0
        self.cardOptionsTableView.layer.borderColor = UIColor.white.cgColor
        
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
        photoPicker.alertTitle = "Select Card Image"
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
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    

    // RSKImageCropperDelegate Methods
    
    // When user selects from photoPicker, config image and set to sender view
    func configureSelectedImageView(selectedImage: UIImage) -> UIImageView{
        // Config imageview
        
        // Set image to imageview
        let imageView = UIImageView(image: selectedImage)
        
        // Configure borders
        //imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25    // Create container for image and name
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 10, y: 0 , width: 125, height: 125)
        
        return imageView
    }
    
    // Image Cropper Delegates
    
    func showCropper(withImage: UIImage) {
        // Show image cropper
        let cropper = RSKImageCropViewController()
        // Set Cropper Image
        cropper.originalImage = withImage
        // Set mode
        cropper.cropMode = RSKImageCropMode.circle
        // Set Delegate
        cropper.delegate = self
        
        self.present(cropper, animated: true, completion: nil)
    }
    
    /*
     func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
     // Configure custom rect
     var size = CGSize()
     // Set size
     size.height = 150
     size.width = 150
     
     // Config view size
     let viewWidth = self.view.frame.width
     let viewHeight = self.view.frame.height
     
     // Make rect
     let rect = CGRect(x: (viewWidth - size.width) * 0.5, y: (viewHeight - size.height) * 0.5, width: size.width, height: size.height)
     
     return rect
     
     }*/
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        // Drop vc
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        // Set image to view
        // self.profileImageView.image = croppedImage
        
        // Test
        print("Cropped Image >> \n\(croppedImage)")
        
        self.profileImageView.addSubview(self.configureSelectedImageView(selectedImage: croppedImage))
        // Dismiss vc
        dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        // Set image to view
        //self.profileImageContainerView.image = originalImage
        
        // Test
        print("Selected Image >> \n\(originalImage)")
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
