//
//  AddNewContactViewController.swift
//  Unify
//
//  Created by Kevin Fich on 9/22/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka
import MBPhotoPicker
import Alamofire
import Contacts

class AddNewContactViewController: FormViewController, UICollectionViewDelegate, UICollectionViewDataSource, RSKImageCropViewControllerDelegate{
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    var contact = Contact()
    var photo = MBPhotoPicker()
    var profileImage = UIImage()
    
    // Parsed profile arrays
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [[String : String]]()
    var phoneNumberDictionaryArray = [NSDictionary]()
    var emailsDictionaryArray = [NSDictionary]()
    var phoneLabels = [String]()
    
    var emails = [[String : String]]()
    var emailLabels = [String]()
    
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    
    var addresses = [[String : String]]()
    var addressLabels = [String]()
    
    var socialBadges = [UIImage]()
    var profileImages = [UIImage()]
    // To check user intent
    //var doneButtonSelected = false]
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var linkToDelete = ""
    
    var userBadges = [UIImage]()
    // Selected image
    var selectedImage = UIImage()
    
    var count = 0
    
    @IBOutlet var cardWrapperView: UIView!
    
    @IBOutlet var profileImageCollectionView: UICollectionView!
    @IBOutlet var badgeCollectionView: UICollectionView!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    // IBOutlets
    // ----------------------------------
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var calendarButton: UIBarButtonItem!
    
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    
    
    
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
            self.contactImageView.image = image
            
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
        
        ContactManager.sharedManager.userCreatedNewContact = true
        
        // Execute call to parse profile from form
        self.parseEditedProfile()
        
        
        // Dismiss view
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        // Set manager to false
        ContactManager.sharedManager.userCreatedNewContact = false
        
        // Reset new contact
        ContactManager.sharedManager.newContact = Contact()
        
        // Dismiss view
        dismiss(animated: true, completion: nil)
        
        // Dismiss VC
        navigationController?.popViewController(animated: true)
        
    }
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            // Badge config
        
        return socialBadges.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //cell.backgroundColor = UIColor.blue
        
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        //configureViews(cell: cell)
        // Configure badge image
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        var image = UIImage()
        image = self.socialBadges[indexPath.row]
        // Set image
        imageView.image = image
        
        if indexPath.row != self.socialBadges.count - 1 {
            
            // Delete
            let deleteIconView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
            let deleteImage = UIImage(named: "icn-minus-red")
            deleteIconView.image = deleteImage
            
            // Add to imageview
            imageView.addSubview(deleteIconView)
            
            // Add to cell
            cell.contentView.addSubview(imageView)
            
        }else{
            
            print("Last image index")
            
            // Configure badge image
            let imageView = UIImageView(frame: CGRect(x: 2, y: 10, width: 20, height: 20))
            var image = UIImage()
            image = self.socialBadges[indexPath.row]
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row !=  self.socialBadges.count - 1{
            // Delete the card
            self.removeBadgeFromProfile(index: indexPath.row)
        }else{
            // Add new badge
            performSegue(withIdentifier: "showContactMediaSelection", sender: self)
        }
        
        // Remove icon from list
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        // Reload data
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // Init view
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "CollectionHeader",
                                                                         for: indexPath)
        return headerView
    }
    
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        currentUser = ContactManager.sharedManager.currentUser
        
        
        configureViews()
        
        
        // Parse prof for social info
        self.parseForSocialIcons()
        
        // Config photo picker
        self.configurePhotoPicker()
        
        // For notification handling
        self.addObservers()
        
        // Set image
        let image = UIImage(named: "profile-placeholder")
        self.contactImageView.image = image
        
        // Config textfields
        self.firstNameTextField.placeholder = "First name"
        self.lastNameTextField.placeholder = "Last name"
        
        
        self.configureSelectedImageView(imageView: self.contactImageView)
        // Parse bio info
        
        // Parse work info
        if contact.titles.count > 0{
            for info in contact.titles{
                titles.append((info["title"])!)
            }
        }
        
        // Parse phone numbers
        if contact.phoneNumbers.count > 0{
            for number in contact.phoneNumbers{
                phoneNumbers.append(number)
                // Add to label list
                phoneLabels.append(number.keys.first!)
            }
        }
        // Parse emails
        if contact.emails.count > 0{
            for email in contact.emails{
                emails.append(email)
                
                emailLabels.append(email["type"]!)
            }
        }
        // Parse websites
        if contact.websites.count > 0{
            for site in contact.websites{
                websites.append(site["website"]!)
            }
        }
        // Parse organizations
        if contact.organizations.count > 0{
            for org in contact.organizations{
                organizations.append(org["organization"]!)
            }
        }
        
        // Parse notes
        if contact.notes.count > 0{
            for note in contact.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse socials links
        if contact.socialLinks.count > 0{
            for link in contact.socialLinks{
                socialLinks.append(link["link"]!)
            }
        }
        // Parse socials links
        if contact.tags.count > 0{
            for link in contact.tags{
                tags.append(link["tag"]!)
            }
        }
        // Parse addresses
        if contact.addresses.count > 0{
            for add in contact.addresses{
                addresses.append(add)
                
                addressLabels.append(add.keys.first!)
            }
        }

        
        print("Testing Current User")
        
        
        tableView.tableHeaderView = self.cardWrapperView
        
        
        // Set bg
        tableView.backgroundColor = UIColor.white
        
        //title = "Multivalued Examples"
        form
            +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "  ",
                               footer: "") {
                                $0.tag = "Title Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Title"
                                        
                                        //$0.tag = "Add Titles"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("titlesRow_\(index)") {
                                        // Set tint
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        print("Printing section index ", index)
                                        
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Title"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            
                                        }.cellSetup({ (cell, row) in
                                            
                                            //self.addGestureToLabel(label: cell.textLabel!, index: row.indexPath!)
                                            
                                            print("Cell Setup on Title Row >> \(row.indexPath!)")
                                        })
                                }
                                
                                /*$0.multivaluedRowToInsertAt = { index in
                                 return NameRow("titlesRow_\(index)") {
                                 $0.placeholder = "Title"
                                 
                                 $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                 $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                 }
                                 }*/
                                // Iterate through array and set val
                                for val in titles{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Title"
                                        $0.value = val
                                        
                                        print("section index: ", $0.indexPath ?? IndexPath())
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Title"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                    }
                                    
                                }
                                
                                
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Organization Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Company"
                                        //$0.tag = "Add Organizations"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("organizationRow_\(index)") {
                                        
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in organizations{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Name"
                                        $0.value = val
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            
                                    }
                                    
                                }
                                
            }
            
            /*
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "Bio Information", footer: "") {
                $0.tag = "Bio Section"
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "Add Bio Info"
                        //$0.tag = "Add Bio"
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textAlignment = .left
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return NameRow("bioRow_\(index)") {
                        $0.placeholder = "Bio"
                        //$0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                        $0.cell.textField.autocapitalizationType = .sentences //UITextAutocapitalizationType.none
                        self.count = self.count + 1
                        //$0.tag = "Add Bio"
                        
                    }
                }
                //$0.footer?.height = 100.0 as CGFloat
                
                // Iterate through array and set val
                
                for val in bios{
                    print(val)
                    $0 <<< NameRow() {
                        $0.placeholder = "Bio"
                        $0.value = val
                        //$0.tag = "b_row\(IndexPath())"
                    }
                }
                
                
                
            }*/
            
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Phone Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Phone Numbers"
                                        //$0.tag = "Phone Numbers"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    
                                    return NameRow("numbersRow_\(index)") {
                                        $0.title = "mobile"
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        // Add label to label list
                                        self.phoneLabels.append("home")
                                        self.phoneNumbers.append(["home" : ""])
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            if row.indexPath != nil{
                                                // Add to label
                                                self.addGestureToLabel(label: cell.textLabel!, index: row.indexPath!)
                                                
                                                // Test
                                                print("Cell updating with index Path", row.indexPath!)
                                                
                                            }
                                            
                                            /*
                                             // Init line view
                                             let headerView = UIImageView()
                                             
                                             headerView.frame = CGRect(x: cell.textField.frame.width, y: 2, width: 10, height: 10)
                                             headerView.image = UIImage(named: "arrow-left")
                                             headerView.backgroundColor = UIColor.gray
                                             headerView.tintColor = UIColor.gray
                                             
                                             // Add seperator to label
                                             cell.titleLabel?.addSubview(headerView)*/
                                            
                                            
                                            
                                    }
                                    
                                    
                                    /*return PhoneRow("numbersRow_\(index)") {
                                     $0.placeholder = "Number"
                                     $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                     $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                     //$0.tag = "Phone Numbers"
                                     $0.cell.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                                     }*/
                                }
                                // Iterate through array and set val
                                for val in phoneNumbers{
                                    $0 <<< PhoneRow() {
                                        $0.placeholder = "Number"
                                        $0.value = self.format(phoneNumber: val.values.first!)//val
                                        $0.title = val.keys.first!
                                        
                                        
                                        //$0.tag = "Phone Numbers"
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            cell.titleLabel?.text = self.phoneLabels[(cell.row.indexPath?.row)!]
                                            
                                            // Add gesture to cell
                                            self.addGestureToLabel(label: cell.textLabel!, index: cell.row.indexPath!)
                                            
                                            /*
                                             // Init line view
                                             let headerView = UIImageView()
                                             
                                             headerView.frame = CGRect(x: cell.textField.frame.width, y: 2, width: 10, height: 10)
                                             headerView.image = UIImage(named: "arrow-left")
                                             headerView.backgroundColor = UIColor.gray
                                             headerView.tintColor = UIColor.gray
                                             
                                             // Add seperator to label
                                             cell.titleLabel?.addSubview(headerView)*/
                                            
                                    }
                                    
                                }
                                
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Email Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Email"
                                        //$0.tag = "Add Emails"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("emailsRow_\(index)") {
                                        $0.title = "home "
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        // Add label to labels
                                        self.emailLabels.append("home")
                                        self.emails.append(["home" : ""])
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            if row.indexPath != nil{
                                                // Add to label
                                                self.addGestureToLabel(label: cell.textLabel!, index: row.indexPath!)
                                                
                                                // Test
                                                print("Cell updating with index Path", row.indexPath!)
                                                
                                            }
                                            
                                            
                                            /*
                                             // Init line view
                                             let headerView = UIImageView()
                                             
                                             headerView.frame = CGRect(x: cell.textField.frame.width, y: 2, width: 10, height: 10)
                                             headerView.image = UIImage(named: "arrow-left")
                                             headerView.backgroundColor = UIColor.gray
                                             headerView.tintColor = UIColor.gray
                                             
                                             // Add seperator to label
                                             cell.titleLabel?.addSubview(headerView)*/
                                            
                                            print("Cell updating !!")
                                            
                                    }
                                    
                                    /*return NameRow("emailsRow_\(index)") {
                                     $0.placeholder = "Address"
                                     $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                     $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                     //$0.tag = "Add Emails"
                                     }*/
                                }
                                
                                // Iterate through array and set val
                                for val in emails{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Address"
                                        //$0.tag = "Add Emails"
                                        $0.value = val["email"]!
                                        $0.title = val["type"]!
                                        
                                        }.cellUpdate { cell, row in
                                            // Reconfig alignment
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Add gesture to cell
                                            self.addGestureToLabel(label: cell.textLabel!, index: cell.row.indexPath!)
                                            
                                            cell.titleLabel?.text = val["type"]!
                                            
                                            /*
                                             // Init line view
                                             let headerView = UIImageView()
                                             
                                             headerView.frame = CGRect(x: cell.textField.frame.width, y: 2, width: 10, height: 10)
                                             headerView.image = UIImage(named: "arrow-left")
                                             headerView.backgroundColor = UIColor.gray
                                             headerView.tintColor = UIColor.gray
                                             
                                             // Add seperator to label
                                             cell.titleLabel?.addSubview(headerView)*/
                                            
                                    }
                                    
                                }
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Website Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Websites"
                                        //$0.tag = "Add Websites"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("websitesRow_\(index)") {
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Config auto correct
                                            cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                            cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                            
                                            
                                            
                                    }
                                    
                                }
                                // Iterate through array and set val
                                
                                for val in websites{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Site"
                                        $0.value = val
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            
                                    }
                                    
                                }
            }
            
            /* +++
             
             MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
             header: "Social Media Links",
             footer: "") {
             $0.tag = "Media Section"
             $0.addButtonProvider = { section in
             return ButtonRow(){
             $0.title = "Add Media Info"
             //$0.tag = "Add Media Info"
             }.cellUpdate { cell, row in
             cell.textLabel?.textAlignment = .left
             }
             }
             $0.multivaluedRowToInsertAt = { index in
             return NameRow("socialLinkRow_\(index)") {
             $0.placeholder = "Link"
             //$0.tag = "Add Media Info"
             }
             }
             
             // Iterate through array and set val
             for val in socialLinks{
             $0 <<< NameRow() {
             $0.placeholder = "Link"
             $0.value = val
             //$0.tag = "Add Media Info"
             }
             }
             }*/
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Tag Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Tag"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("tagRow_\(index)") {
                                        $0.placeholder = "Tag"
                                        //$0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        //$0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in tags{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Tag"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Notes Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Notes"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("notesRow_\(index)") {
                                        $0.placeholder = "Note"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in notes{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Note"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Address Section"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Address"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return PostalAddressRow("addressRow_\(index)") {
                                        $0.streetPlaceholder = "Street"
                                        $0.statePlaceholder = "State"
                                        $0.cityPlaceholder = "City"
                                        $0.countryPlaceholder = "Country"
                                        $0.postalCodePlaceholder = "Zip code"
                                        
                                        // Add label to labelArrays
                                        self.addressLabels.append("home")
                                        self.addresses.append(["home" : ""])
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            var typeLabel = UILabel()
                                            // Look for label in subviews
                                            for view in cell.contentView.subviews{
                                                
                                                if view is UILabel{
                                                    // assign label
                                                    typeLabel = view as! UILabel
                                                    
                                                }
                                            }
                                            // Check for nil path
                                            if row.indexPath != nil{
                                                // Add gesture to label
                                                self.addGestureToLabel(label: typeLabel, index: row.indexPath!)
                                                
                                                
                                            }
                                    }
                                    
                                }
                                
                                // Iterate through array and set val
                                for val in addresses{
                                    $0 <<< PostalAddressRow() {
                                        $0.streetPlaceholder = "Street"
                                        $0.statePlaceholder = "State"
                                        $0.cityPlaceholder = "City"
                                        $0.countryPlaceholder = "Country"
                                        $0.postalCodePlaceholder = "Zip code"
                                        
                                        // Init all values for the cells
                                        let street = val["street"] ?? ""
                                        let city = val["city"] ?? ""
                                        let state = val["state"] ?? ""
                                        let zip = val["zip"] ?? ""
                                        let country = val["country"] ?? ""
                                        
                                        // Set all field values
                                        $0.cell.streetTextField?.text = street
                                        $0.cell.cityTextField?.text = city
                                        $0.cell.stateTextField?.text = state
                                        $0.cell.postalCodeTextField?.text = zip
                                        $0.cell.countryTextField?.text = country
                                        
                                        // Find label and set val
                                        for view in $0.cell.contentView.subviews{
                                            
                                            if view is UILabel{
                                                
                                                let viewText = (view as! UILabel).text!
                                                print("The Address Label Text", viewText)
                                                
                                                // Set text
                                                (view as! UILabel).text = val["type"] ?? "work"
                                                
                                                
                                            }
                                        }
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            // Look for label in subviews
                                            for view in cell.contentView.subviews{
                                                
                                                
                                                // Init all values for the cells
                                                let street = val["street"] ?? ""
                                                let city = val["city"] ?? ""
                                                let state = val["state"] ?? ""
                                                let zip = val["zip"] ?? ""
                                                let country = val["country"] ?? ""
                                                
                                                // Set all field values
                                                cell.streetTextField?.text = street
                                                cell.cityTextField?.text = city
                                                cell.stateTextField?.text = state
                                                cell.postalCodeTextField?.text = zip
                                                cell.countryTextField?.text = country
                                                
                                                
                                                if view is UILabel{
                                                    
                                                    if view.accessibilityIdentifier == "typeLabel"{
                                                        print("The Address Label Original text", (view as! UILabel).text ?? "No text")
                                                        
                                                        // Set text
                                                        (view as! UILabel).text = val["type"] ?? "work"
                                                    }
                                                    
                                                    // Check for nil path
                                                    if row.indexPath != nil{
                                                        // Add gesture to label
                                                        self.addGestureToLabel(label: (view as! UILabel), index: row.indexPath!)
                                                        
                                                        
                                                    }
                                                    
                                                }
                                            }
                                    }
                                
                                }
        
        }
        
        
        
    }
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        
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
        self.contactImageView.image = croppedImage
        
        // Set selected
        self.selectedImage = croppedImage
        
        // Set image to profile
        //self.uploadi()
        
        //self.profileImages.append(self.selectedImage)
        // Refresh account images
        //self.parseAccountForImges()
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        // Set image to view
        //self.profileImageContainerView.image = originalImage
        
        // Test
        print("Selected Image >> \n\(originalImage)")
    }
    
    
    
    // Custom methods
    
    func addObservers() {
        // Call to refresh table labels
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewContactViewController.updateCellLabel), name: NSNotification.Name(rawValue: "Update Labels"), object: nil)
        
        // Refresh for social icons
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewContactViewController.parseForSocialIcons), name: NSNotification.Name(rawValue: "RefreshContactEditProfile"), object: nil)
        
    }
    
    
    
    func configurePhotoPicker() {
        //Initial setup
        photo.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photo.alertTitle = "Select Profile Image"
        photo.alertMessage = ""
        photo.resizeImage = CGSize(width: 150, height: 150)
        photo.allowDestructive = false
        photo.allowEditing = false
        // Set front facing camera
        photo.cameraDevice = .front
        photo.cameraFlashMode = .auto
        
        photo.actionTitleLibrary = "Photo Library"
        //photo.actionTitleLastPhoto = nil
        photo.actionTitleTakePhoto = "Take Photo"
        photo.actionTitleCancel = "Cancel"
        photo.actionTitleOther = "Import From..."
        
        
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
        let img18 = UIImage(named: "Snapchat.png")
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!], ["snapchat" : img18!]]
        
    }
    
    func removeCorpBadgeFromProfile(index: Int) {
        
        print("Initial badge count \(ContactManager.sharedManager.currentUser.userProfile.badgeList.count)")
        // Remove item at index
        ContactManager.sharedManager.currentUser.userProfile.badgeList.remove(at: index)
        print("Post delete badge count \(ContactManager.sharedManager.currentUser.userProfile.socialLinks.count)")
        // Reload table data
        self.badgeCollectionView.reloadData()
    }
    
    func removeBadgeFromProfile(index: Int) {
        
        print("Initial list count \(ContactManager.sharedManager.currentUser.userProfile.socialLinks.count)")
        // Remove item at index
        ContactManager.sharedManager.currentUser.userProfile.socialLinks.remove(at: index)
        print("Post delete list count \(ContactManager.sharedManager.currentUser.userProfile.socialLinks.count)")
        // Reload table data
        parseForSocialIcons()
    }
    
    
    func parseForSocialIcons() {
        
        // Init badge list
        self.initializeBadgeList()
        
        
        print("PARSING for icons from add contact vc")
        // Remove all items from badges
        self.socialBadges.removeAll()
        self.socialLinks.removeAll()
        
        // Assign currentuser
        //self.currentUser = ContactManager.sharedManager.currentUser
        
        // Parse socials links
        if ContactManager.sharedManager.newContact.socialLinks.count > 0{
            for link in ContactManager.sharedManager.newContact.socialLinks{
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
        let image = UIImage(named: "Green-1")
        self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    // Send to server
    func uploadContactRecord() {
        
        // Assign contact object
        self.contact = ContactManager.sharedManager.newContact
        self.contact.origin = "unify"
        
        print("The new contacts social media")
        contact.printContact()
        
        
        // Show HUD
        KVNProgress.show(withStatus: "Saving new contact..")
        
        // Send to server
        let parameters = ["data" : contact.toAnyObject(), "uuid": self.currentUser.userId] as [String : Any]
        print("\n\nContact Params")
        print(parameters)
        
        // Show HUD
        KVNProgress.show(withStatus: "Uploading new contact..")
        
        // Establish connection
        Connection(configuration: nil).uploadContactCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Contact Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSArray = response as! NSArray
                print(dictionary)
                
                // Hide HUD
                KVNProgress.showSuccess(withStatus: "Contact added successfully!")
                
                // Post notification for refresh
                self.postRefreshNotification()
                
                // Nav out the view
                self.dismiss(animated: true, completion: nil)
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your contact. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func setContact() {
        // Set contact from manager
        //self.contact = ContactManager.sharedManager.newContact
        
        // Parse vals
        if let first = firstNameTextField.text {
            // Assign to contact
            ContactManager.sharedManager.newContact.first = first
        }else{
            print("No first")
        }
        // Parse vals
        if let last = lastNameTextField.text {
            // Assign to contact
            ContactManager.sharedManager.newContact.last = last
        }else{
            print("No last")
        }
        
        // Set contact full name
        ContactManager.sharedManager.newContact.name = "\(ContactManager.sharedManager.newContact.first) \(ContactManager.sharedManager.newContact.last)"
        
        // Set ContactManager Nav bool
        ContactManager.sharedManager.userCreatedNewContact = true
        
        // Store contact to list
        //self.syncContact()
        
        // Upload record
        self.parseEditedProfile()
        
        
    }
    
    func syncContact() {
        
        // Init CNContact Object
        //let temp = CNContact()
        //temp.emailAddresses.append(CNLabeledValue<NSString>)
        let tempContact = ContactManager.sharedManager.newContact
        
        // Append to list of existing contacts
        let store = CNContactStore()
        
        // Set text for name
        let contactToAdd = CNMutableContact()
        contactToAdd.givenName = self.firstNameTextField.text ?? ""
        contactToAdd.familyName = self.lastNameTextField.text ?? ""
        
        if tempContact.phoneNumbers.count > 0{
            
            // Parse for mobile
            let mobileNumber = CNPhoneNumber(stringValue: (tempContact.phoneNumbers[0]["phone"] ?? ""))
            let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
            contactToAdd.phoneNumbers = [mobileValue]
        }
        
        if tempContact.emails.count > 0 {
            
            // Parse for emails
            let email = CNLabeledValue(label: CNLabelWork, value: tempContact.emails[0]["email"] as! NSString ?? "")
            contactToAdd.emailAddresses = [email]
        }
        
        
        if let image = self.contactImageView.image {
            contactToAdd.imageData = UIImagePNGRepresentation(image)
        }
        
        if tempContact.titles.count > 0 {
            // Add to contact
            contactToAdd.jobTitle = tempContact.titles[0]["title"]!
        }
        if tempContact.organizations.count > 0 {
            // Add to contact
            contactToAdd.organizationName = tempContact.organizations[0]["organization"]!
        }
        
        // Save contact to phone
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
        } catch {
            print(error)
        }
        
        // Init contact object
        let newContact : CNContact = contactToAdd
        
        print("New Contact >> \(newContact)")
        
        // Append to contact list
        ContactManager.sharedManager.phoneContactList.append(newContact)
        
        // Post notification for refresh
        //self.postRefreshNotification()
        
    }
    
    func uploadImage(imageDictionary: NSDictionary) {
        // Link to endpoint and send
        // Create URL For Test
        let testURL = ImageURLS().uploadToDevelopmentURL
        //let prodURL = ImageURLS().uploadToDevelopmentURL
        
        // Parse dictionary
        let imageData = imageDictionary["image_data"] as! Data
        let fname = imageDictionary["file_name"] as! String
        
        // Show progress HUD
        KVNProgress.show(withStatus: "Generating profile..")
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "files", fileName: "\(fname).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            /*for (key, value) in parameters {
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }*/
            
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
                
                // Upload the contact
                self.uploadContactRecord()
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
    }
    
    
    // Notification posting
    
    func postRefreshNotification() {
        // Notification for list refresh
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshContactsTable"), object: self)
    }
    func postNotificationForUpdate() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProfile"), object: self)
        
        //UpdateCurrentUserProfile
        
    }
    
    // Reset arrays
    func clearCurrentUserArrays() {
        // Clear all profile info to prepare for override
        ContactManager.sharedManager.currentUser.userProfile.bios.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.titles.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.emails.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.websites.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.organizations.removeAll()
        //ContactManager.sharedManager.currentUser.userProfile.socialLinks.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.workInformationList.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.tags.removeAll()
        ContactManager.sharedManager.currentUser.userProfile.addresses.removeAll()
        
    }
    
    func removeAllFromArrays() {
        // Clear all profile info to prepare for override
        /*ContactManager.sharedManager.currentUser.userProfile.bios.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.titles.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.emails.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.websites.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.organizations.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.socialLinks.removeAll()
         ContactManager.sharedManager.currentUser.userProfile.workInformationList.removeAll()*/
        
        // Clear all profile info to prepare for override
        bios.removeAll()
        titles.removeAll()
        emails.removeAll()
        phoneNumbers.removeAll()
        websites.removeAll()
        organizations.removeAll()
        //socialLinks.removeAll()
        workInformation.removeAll()
        tags.removeAll()
        addresses.removeAll()
        
        
    }

    func parseEditedProfile() {
        // Parse form
        print("Hello!")
        
        // Clear manager arrays
        self.clearCurrentUserArrays()
        
        
        // Configure to send to server
        if firstNameTextField.text != "" && lastNameTextField.text != "" {
            // Fields not empty
            ContactManager.sharedManager.newContact.first = firstNameTextField.text!
            ContactManager.sharedManager.newContact.last = lastNameTextField.text!
            // Combine to make full name
            ContactManager.sharedManager.newContact.name = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
        }
        
        
        
        // Clear the arrays
        self.removeAllFromArrays()
        
        // Assign all the items in each list to the contact profile on manager
        // Parse table section vals
        
        /*
        // Bios Section
        let bioValues = form.sectionBy(tag: "Bio Section")
        for val in bioValues! {
            
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String {
                // Append to user profile
                if str != "nil" && str != "" {
                    ContactManager.sharedManager.currentUser.userProfile.setBioRecords(emailRecords: ["bio": str])
                    bios.append(str)
                }
            }
        }*/
        
        // Titles Section
        let titleValues = form.sectionBy(tag: "Title Section")
        for val in titleValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    ContactManager.sharedManager.newContact.titles.append(["title" : str])
                    titles.append(str)
                }
            }
        }
        
        // Organization section
        let organizationValues = form.sectionBy(tag: "Organization Section")
        for val in organizationValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    // Append to arrays
                    ContactManager.sharedManager.newContact.setOrganizations(organization: str)
                    organizations.append(str)
                }
            }
        }
        
        // Phone Number section
        let phoneValues = form.sectionBy(tag: "Phone Section")
        for val in phoneValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    
                    let label = val.baseCell.textLabel?.text ?? "home"
                    
                    // Assign label
                    phoneNumbers.append([label : str])
                    // Add to label list
                    phoneLabels.append(label)
                    
                    // Add to manager
                    ContactManager.sharedManager.newContact.phoneNumbers.append([label : str])
                    
                    phoneNumberDictionaryArray.append(["email": str, "type": label])
                    //print("Phone dict", phoneNumberDictionaryArray)
                    
                    // Func for stripping phone numbers
                    // let result = String(phoneNumberInput.text!.characters.filter { "01234567890.".characters.contains($0) })
                    // print("Filtered Phone String >> \(result)")
                }
            }
        }
        
        // Email Section
        let emailValues = form.sectionBy(tag: "Email Section")
        for val in emailValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    // Get label
                    let label = val.baseCell.textLabel?.text ?? "home"
                    
                    ContactManager.sharedManager.newContact.emails.append(["email": str, "type": label])
                    
                    emailsDictionaryArray.append(["email": str, "type": label])
                    print("Email dict", emailsDictionaryArray)
                    
                    emails.append([label : str])
                }
            }
        }
        
        // Website Section
        let websiteValues = form.sectionBy(tag: "Website Section")
        for val in websiteValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    // Append to array
                    ContactManager.sharedManager.newContact.setWebsites(websiteRecord: str)
                }
            }
        }

        
        // Notes Section
        let noteValues = form.sectionBy(tag: "Notes Section")
        for val in noteValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    // Set values to arrays
                    ContactManager.sharedManager.newContact.setNotes(note: str)
                    notes.append(str)
                }
            }
        }
        
        // Social Media Section
        let tagValues = form.sectionBy(tag: "Tag Section")
        for val in tagValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    ContactManager.sharedManager.newContact.setTags(tag: str)
                    tags.append(str)
                    
                    //print("Social links not needed here anymore")
                }
            }
        }
        
        // Organization section
        let addressValues = form.sectionBy(tag: "Address Section")
        for val in addressValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    
                    // Init address dict
                    var addressDict:[String : String] = [:]
                    // Extract values
                    let cell = val.baseCell as! PostalAddressCell
                    
                    var label = "work" // assign the address type here
                    
                    // Get label val
                    for view in cell.contentView.subviews{
                        print("Subview iteration count", cell.contentView.subviews.count)
                        
                        print("Access ID", view.accessibilityIdentifier)
                        
                        if view.accessibilityIdentifier != nil{
                            
                            print("The Address Label Original text", (view as! UILabel).text ?? "No text")
                            
                            // Set text
                            label = (view as! UILabel).text ?? "work"
                            
                        }
                        
                        
                        
                    }
                    
                    // Set all values for the cells
                    addressDict["street"] = cell.streetTextField?.text ?? ""
                    addressDict["city"] = cell.cityTextField?.text ?? ""
                    addressDict["state"] = cell.stateTextField?.text ?? ""
                    addressDict["zip"] = cell.postalCodeTextField?.text ?? ""
                    addressDict["country"] = cell.countryTextField?.text ?? ""
                    addressDict["type"] = label
                    
                    
                    let dict = [label : addressDict]
                    
                    // Test it
                    print("Final Address\n", dict)
                    
                    // Append to user object
                    ContactManager.sharedManager.newContact.addresses.append(addressDict)
                    addresses.append(addressDict)
                }
            }
        }
        // Set current user
        //ContactManager.sharedManager.currentUser = self.currentUser
        
        // Test to print profile
        print("PRINTING FROM CONTAINER CURRENT USER")
        ContactManager.sharedManager.currentUser.printUser()
        
        // Post notification
        //self.postNotificationForUpdate()
        
        // Get and set image data
        // Assign asset name and type
        let idString = Contact().randomString(length: 20)
        let imageData = UIImageJPEGRepresentation(self.contactImageView.image!, 0.75)
        
        // Name image with id string
        let fname = idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id":idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        // Assign to contact object
        ContactManager.sharedManager.newContact.setContactImageId(id: idString)
        ContactManager.sharedManager.newContact.imageDictionary = imageDict
        
        // Upload
        // Execute upload image call
        self.uploadImage(imageDictionary: imageDict as NSDictionary)
        
        
        
        
        // Call to update
        //self.uploadContactRecord()
        
        // Store user to device
        //UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
        
        //self.postNotification()
        
    }
    
    
    func addGestureToLabel(label: UILabel, intent: String) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showSelectionOptions))
        label.isUserInteractionEnabled = true
        // Add gesture to image
        label.addGestureRecognizer(tapGestureRecognizer)
        // Set description to view based on intent
        
    }
    
    func addGestureToLabel(label: UILabel, index: IndexPath) {
        // Init tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setSelectedTransaction(sender:)))
        label.isUserInteractionEnabled = true
        // Add gesture to image
        label.addGestureRecognizer(tapGestureRecognizer)
        // Set image index
        label.tag = index.row
        // Set string identifier for view
        label.accessibilityIdentifier = String(describing: index)
        
        
    }
    
    func setSelectedTransaction(sender: UITapGestureRecognizer){
        
        let label = sender.view as! UILabel
        let intent = label.text!
        
        print("Sender Index: \((sender.view?.tag)!)")
        print("Sender Index Path: \((sender.view?.accessibilityIdentifier)!)")
        print("Intent : \(intent)")
        
        
        let path = (sender.view?.accessibilityIdentifier)!.characters.filter { "01234567890.".characters.contains($0) }
        print(path, "Path")
        let indexPath = IndexPath(row: Int(String(path[1]))!, section: Int(String(path[0]))!)
        
        // Show selection screen
        showSelectionWithOptions(cellPath: indexPath)
    }
    
    func updateCellLabel(){
        
        // Init section val
        let cellIndex = ContactManager.sharedManager.labelPathWithIntent["index"] as! IndexPath
        let newLabelValue = ContactManager.sharedManager.labelPathWithIntent["label_value"] as! String
        
        // Retrieve the label field
        let sectionTag = form.allSections[cellIndex.section].tag ?? " "
        let section = form.allSections[cellIndex.section]
        
        print("The section", sectionTag, " ", section)
        
        switch sectionTag {
        case "Title Section":
            print("Titles")
            
            // Try and set label
            for cell in section {
                if cell.indexPath == cellIndex {
                    print("The Cell Label val", cell.baseCell.textLabel?.text)
                    // Set text
                    cell.baseCell.textLabel?.text = newLabelValue
                    
                }
            }
            
        case "Organization Section":
            print("Orgs")
            
            
        case "Bio Section":
            print("Bios")
            
            
        case "Phone Section":
            print("Phones")
            
            // Try and set label
            for cell in section {
                if cell.indexPath == cellIndex {
                    
                    print("The Cell Label val", cell.baseCell.textLabel?.text!)
                    
                    // Overwrite previous value for update
                    self.phoneNumbers[cellIndex.row] = [newLabelValue : phoneNumbers[cellIndex.row].values.first!]
                    
                    self.phoneLabels[cellIndex.row] = newLabelValue
                    
                    print("The phone numbers array index value", self.phoneNumbers[cellIndex.row])
                    
                    
                    
                    // Set text
                    cell.baseCell.textLabel?.text = newLabelValue
                    
                    // Update cell
                    
                    
                }
            }
            
            
        case "Email Section":
            print("Emails")
            
            // Try and set label
            for cell in section {
                if cell.indexPath == cellIndex {
                    print("The Cell Label val", cell.baseCell.textLabel?.text)
                    
                    // Overwrite previous value for update
                    self.emails[cellIndex.row] = [newLabelValue : emails[cellIndex.row].values.first!]
                    self.emailLabels[cellIndex.row] = newLabelValue
                    
                    print("The phone emails array index value", self.emails[cellIndex.row])
                    
                    
                    // Set text
                    cell.baseCell.textLabel?.text = newLabelValue
                    
                }
            }
            
            
        case "Website Section":
            print("Web")
            
            
        case "Tag Section":
            print("Tags")
            
            
        case "Address Section":
            print("Address")
            
            // Try and set label
            for cell in section {
                if cell.indexPath == cellIndex {
                    
                    // Overwrite previous value for update
                    self.addresses[cellIndex.row] = [newLabelValue : addresses[cellIndex.row].values.first!]
                    self.addressLabels[cellIndex.row] = newLabelValue
                    
                    print("The addresses array index value", self.addresses[cellIndex.row])
                    
                    // Update cell
                    cell.baseCell.update()
                    print("The cell was found, and updated..")
                    
                    for view in cell.baseCell.contentView.subviews{
                        print("Subview iteration count", cell.baseCell.contentView.subviews.count)
                        
                        print("Access ID", view.accessibilityIdentifier)
                        
                        if view.accessibilityIdentifier != nil{
                            
                            print("The Address Label Original text", (view as! UILabel).text ?? "No text")
                            
                            // Set text
                            (view as! UILabel).text = newLabelValue
                            
                        }
                        
                        
                        
                    }
                    
                }
            }
            
            
        case "Note Section":
            print("Notes")
            
            
        default:
            print("Not a valid section")
        }
        
        
    }
    
    func showSelectionWithOptions(cellPath: IndexPath) {
        
        print("The selected index path", cellPath)
        // Set path
        ContactManager.sharedManager.labelPathWithIntent["index"] = cellPath
        
        print("Manager label path", ContactManager.sharedManager.labelPathWithIntent)
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LabelSelectVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func showSelectionOptions() {
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LabelSelectVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    // Page styling
    func populateCards(){
        
        var currentUser = ContactManager.sharedManager.currentUser
        
        // Senders card
        // Assign current user from manager
        currentUser = ContactManager.sharedManager.currentUser
        
        if currentUser.profileImages.count > 0 {
            contactImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        if currentUser.fullName != ""{
            nameLabel.text = currentUser.fullName
        }
        if currentUser.userProfile.phoneNumbers.count > 0{
            // Format text labels
            phoneLabel.text = self.format(phoneNumber: currentUser.userProfile.phoneNumbers[0].values.first!)
        }
        if currentUser.userProfile.emails.count > 0{
            emailLabel.text = currentUser.userProfile.emails[0]["email"]
        }
        
        if currentUser.userProfile.titles.count > 0{
            titleLabel.text = currentUser.userProfile.titles[0]["title"]
        }
        
        //titleLabel.text = "Founder & CEO, CleanSwipe"
        
        /*
         // Assign media buttons
         mediaButton1.image = UIImage(named: "social-blank")
         mediaButton2.image = UIImage(named: "social-blank")
         mediaButton3.image = UIImage(named: "social-blank")
         mediaButton4.image = UIImage(named: "social-blank")
         mediaButton5.image = UIImage(named: "social-blank")
         mediaButton6.image = UIImage(named: "social-blank")
         mediaButton7.image = UIImage(named: "social-blank")*/
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
    
    func configurePhoto(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 45.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    
    func configureViews(){
        // Toolbar button config
        /*
         outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
         
         outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
         
         outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
         
         outreachCalendarButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
         
         
         // Config buttons
         // ** Email and call inverted
         smsButton.image = UIImage(named: "btn-chat-blue")
         emailButton.image = UIImage(named: "btn-message-blue")
         callButton.image = UIImage(named: "btn-call-blue")
         calendarButton.image = UIImage(named: "btn-calendar-blue")*/
    }
    
    
    // Format textfield for phone numbers
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard /*length == 7 ||*/ length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    // Add formatting action to textfield
    func textFieldDidChange(_ textField: UITextField) {
        
        
        if format(phoneNumber: textField.text! ) != nil
        {
            textField.text = format(phoneNumber: textField.text! )!
        }
        
    }
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewContactAdded"), object: self)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
