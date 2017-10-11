//
//  ProfileEditViewController.swift
//  Unify
//
//  Created by Kevin Fich on 9/14/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka
import MBPhotoPicker
import Alamofire
import ACFloatingTextfield_Swift

class ProfileEditViewController: FormViewController, UICollectionViewDelegate, UICollectionViewDataSource, RSKImageCropViewControllerDelegate{
    
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
    
    
    @IBOutlet var firstNameTextField: ACFloatingTextfield!
    @IBOutlet var lastNameTextField: ACFloatingTextfield!
    
    
    // IBActions
    // ----------------------------------
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
       
        // Execute call to parse profile from form
        self.parseEditedProfile()
        
    }

    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        // Reassign to the OG user object
        if let user = UDWrapper.getDictionary("user"){
            // Assign current user to manager object from phone
            // Print to test
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
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.profileImageCollectionView {
            // Config images
            return self.profileImages.count
        }else{
            // Badge config
            return socialBadges.count
        }
        //return 4//self.socialBadges.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //cell.backgroundColor = UIColor.blue
        
        if collectionView == self.profileImageCollectionView {
            // Config images
            //self.configurePhoto(cell: cell)
        }else{
            // Badge config
            //self.configureBadges(cell: cell)
        }
        
        if collectionView == self.profileImageCollectionView {
            // Init cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            if indexPath.row != self.profileImages.count - 1 {
                
                // Image config
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
                let image = self.profileImages[indexPath.row]
                //imageView.layer.masksToBounds = true
                // Set image to view
                imageView.image = image
                
                // Delete
                let deleteIconView = UIImageView(frame: CGRect(x: 55, y: 15, width: 20, height: 20))
                let deleteImage = UIImage(named: "icn-minus-red")
                deleteIconView.image = deleteImage
                
                // Add to imageview
                imageView.addSubview(deleteIconView)
                
                // Config cell
                self.configurePhoto(cell: cell)
                
                // Add to collection
                cell.contentView.addSubview(imageView)
                
            }else{
                
                print("Last image index on Photo collection")
                // Badge icon
                var image = UIImage()
                image = self.profileImages[indexPath.row]
                let imageView = UIImageView(frame: CGRect(x: 2, y: 15, width: 20, height: 20))
                imageView.layer.masksToBounds = true
                // Set image to view
                imageView.image = image
                // Add to collection
                cell.contentView.addSubview(imageView)
                
            }
            
            
        }else{
            
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
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.profileImageCollectionView {
            
            if indexPath.row !=  self.profileImages.count - 1{
                // Delete the card
                self.removeImageFromProfile(index: indexPath.row)
            }else{
                // Add new badge
                //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
                self.selectProfilePicture(self)
            }
            //cell.backgroundColor = UIColor.red
            
        }else{
            
            if indexPath.row !=  self.socialBadges.count - 1{
                // Delete the card
                self.removeBadgeFromProfile(index: indexPath.row)
            }else{
                // Add new badge
                performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
            }
            
            
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Show nav everytime
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // Page setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        currentUser = ContactManager.sharedManager.currentUser
        
        // Config textfields
        firstNameTextField.disableFloatingLabel = true
        lastNameTextField.disableFloatingLabel = true
        
        // View config
        configureViews()
        
        self.configureSelectedImageView(imageView: self.contactImageView)
        
        // Parse for images
        self.parseAccountForImges()
        
        // Parse prof for social info
        self.parseForSocialIcons()
        
        // Config photo picker
        self.configurePhotoPicker()
        
        // For notification handling
        self.addObservers()
        
        // Set profile image
        if ContactManager.sharedManager.currentUser.profileImages.count > 0 {
            contactImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
        }
        
        // Set names
        if ContactManager.sharedManager.currentUser.firstName != ""{
            firstNameTextField.text = ContactManager.sharedManager.currentUser.firstName
        }
        
        if ContactManager.sharedManager.currentUser.lastName != ""{
            lastNameTextField.text = ContactManager.sharedManager.currentUser.lastName
        }
        
        // Parse bio info
        
        
        if ContactManager.sharedManager.currentUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in ContactManager.sharedManager.currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
        }
        
        // Parse work info
        /*if contact.workInformationList.count > 0{
         for info in contact.workInformationList{
         workInformation.append(info["work"]!)
         }
         }*/
        
        // Parse work info
        if ContactManager.sharedManager.currentUser.userProfile.titles.count > 0{
            for info in ContactManager.sharedManager.currentUser.userProfile.titles{
                titles.append((info["title"])!)
                
            }
        }

        
        // Parse phone numbers
        if ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.count > 0{
            for number in ContactManager.sharedManager.currentUser.userProfile.phoneNumbers{
            
                // Add dictionary
                phoneNumbers.append(number)
                // Add to label list
                phoneLabels.append(number.keys.first!)
                
            }
        }
        
        
        // Parse emails
        if ContactManager.sharedManager.currentUser.userProfile.emails.count > 0{
            for email in ContactManager.sharedManager.currentUser.userProfile.emails{
                
                // Append dict
                emails.append(email)
                
                // Append label to dict
                emailLabels.append(email.keys.first!)
                
                
            }
        }
        // Parse websites
        if ContactManager.sharedManager.currentUser.userProfile.websites.count > 0{
            for site in ContactManager.sharedManager.currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
        }
        // Parse organizations
        if ContactManager.sharedManager.currentUser.userProfile.organizations.count > 0{
            for org in ContactManager.sharedManager.currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
        }
        
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.notes.count > 0{
            for note in ContactManager.sharedManager.currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
            }
        }
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.tags.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.tags{
                tags.append(link["tag"]!)
            }
        }
        // Parse addresses
        if ContactManager.sharedManager.currentUser.userProfile.addresses.count > 0{
            for add in ContactManager.sharedManager.currentUser.userProfile.addresses{
                // Add dict
                addresses.append(add)
                
                // Add dict
                addressLabels.append(add.keys.first!)
                
  
            }
        }
        
        print("Testing Current User")
        
        
        
        // Create
        
        //let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:365))
        
        //self.cardWrapperView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height:365)
        //self.cardWrapperView.backgroundColor = UIColor.gray
        
        //headerView.addSubview(self.cardWrapperView)
        
        //headerView.backgroundColor = UIColor.lightGray
        
        //let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height:100))
        
        //footerView.backgroundColor = UIColor.lightGray
        
        //self.profileImageCollectionView.backgroundColor = UIColor.blue
        
        tableView.tableHeaderView = self.cardWrapperView
        tableView.tableFooterView = self.profileImageCollectionView
        
        //tableView.separ
        tableView.separatorStyle = .none
        
        // Set bg
        tableView.backgroundColor = UIColor.white
        
        // Show nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
         //self.navigationController?.navigationBar.barStyle = .
        
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
                                            
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                    }
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("titlesRow_\(index)") {
                                        // Set tint
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        $0.add(rule: RuleRequired())
                                        $0.validationOptions = .validatesOnChange
                                        // Add row rule
                                        let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                                            return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Field required!") : nil
                                        }
                                        $0.add(rule: ruleRequiredViaClosure)
                                        
                                        
                                        print("Printing section index ", index)
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Title"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            /*
                                            row.validationOptions = .validatesOnChangeAfterBlurred
                                            row.add(rule: RuleRequired())
                                            // Add row rule
                                            let ruleRequiredViaClosure = RuleClosure<String> { rowValue in
                                                return (rowValue == nil || rowValue!.isEmpty) ? ValidationError(msg: "Field required!") : nil
                                            }
                                            row.add(rule: ruleRequiredViaClosure)*/
                                            
                                            if !row.isValid {
                                                cell.titleLabel?.textColor = .red
                                            }
                                            
                                            
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                   
                                                }
                                            }
                                        
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                            
                                    
                                        }
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
                                        
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        
                                        print("section index: ", $0.indexPath ?? IndexPath())
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Title"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                           
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
           
                                    }

                                }
                                
            
            }
            
            // Filler section
            //+++ Section("")
            
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
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("organizationRow_\(index)") {
                                        
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                    
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Company"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                            
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in organizations{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Company"
                                        $0.value = val
                                        
                                        // Add lineview
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Company"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                    }

                                }
                                
            }
            // Filler section
            //+++ Section("")
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "", footer: "") {
                $0.tag = "Bio Section"
                
                $0.addButtonProvider = { section in
                    return ButtonRow(){
                        $0.title = "Add Bio Info"
                        //$0.tag = "Add Bio"
                        }.cellUpdate { cell, row in
                            cell.textLabel?.textAlignment = .left
                            
                            // Init line view
                            let headerView = UIView()
                            
                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                            headerView.backgroundColor = UIColor.lightGray
                            
                            
                            // Add seperator to label
                            cell.addSubview(headerView)
                    }
                }
                $0.multivaluedRowToInsertAt = { index in
                    return NameRow("bioRow_\(index)") {
                        $0.placeholder = "Bio"
                        //$0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                        $0.cell.textField.autocapitalizationType = .sentences //UITextAutocapitalizationType.none
                        self.count = self.count + 1
                        //$0.tag = "Add Bio"
                        
                        // Init line view
                        let headerView = UIView()
                        headerView.accessibilityIdentifier = "header"
                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                        headerView.backgroundColor = UIColor.lightGray
                        // Add seperator to label
                        $0.cell.addSubview(headerView)
                        
                        }.cellUpdate { cell, row in
                            
                            cell.textField.textAlignment = .left
                            cell.textField.placeholder = "Bio"
                            cell.titleLabel?.textColor = self.view.tintColor
                            
                            // Check if view exists
                            for view in cell.subviews{
                                
                                if view.accessibilityIdentifier == "header"{
                                    
                                    // Don't add header
                                    print("Cell has view already")
                                    
                                    // Remove view
                                    view.removeFromSuperview()
                                    
                                }
                            }
                            
                            // Init line view
                            let headerView = UIView()
                            headerView.accessibilityIdentifier = "header"
                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                            headerView.backgroundColor = UIColor.lightGray
                            // Add seperator to label
                            cell.addSubview(headerView)
                            
                    }
                }
                //$0.footer?.height = 100.0 as CGFloat
                
                // Iterate through array and set val
                
                for val in bios{
                    print(val)
                    $0 <<< NameRow() {
                        $0.placeholder = "Bio"
                        $0.value = val
                        
                        // Init line view
                        let headerView = UIView()
                        headerView.accessibilityIdentifier = "header"
                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                        headerView.backgroundColor = UIColor.lightGray
                        // Add seperator to label
                        $0.cell.addSubview(headerView)
                        
                        
                    }.cellUpdate({ (cell, row) in
                        
                        
                        // Check if view exists
                        for view in cell.subviews{
                            
                            if view.accessibilityIdentifier == "header"{
                                
                                // Don't add header
                                print("Cell has view already")
                                
                                // Remove view
                                view.removeFromSuperview()
                                
                            }
                        }
                        
                        // Init line view
                        let headerView = UIView()
                        headerView.accessibilityIdentifier = "header"
                        headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                        headerView.backgroundColor = UIColor.lightGray
                        // Add seperator to label
                        cell.addSubview(headerView)
                    })
                }
                
                
                
            }

            // Filler section
            //+++ Section("")
            
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
                                            
                                           
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    
                                    return PhoneRow("numbersRow_\(index)") {
                                        $0.title = "mobile"
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        // Set the label frame to align the values against left edge
                                        $0.cell.titleLabel!.frame = CGRect(x: ($0.cell.titleLabel?.frame.origin.x)!, y: ($0.cell.titleLabel?.frame.origin.x)!, width: 160.0 , height: ($0.cell.titleLabel?.frame.height)!)
                
                                        
                                        // Add label to label list
                                        self.phoneLabels.append("mobile")
                                        self.phoneNumbers.append(["mobile" : ""])
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Phone"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Set the label frame to align the values against left edge
                                            cell.titleLabel!.frame = CGRect(x: (cell.titleLabel?.frame.origin.x)!, y: (cell.titleLabel?.frame.origin.x)!, width: 160.0 , height: (cell.titleLabel?.frame.height)!)
                                            
                                            if row.indexPath != nil{
                                                // Add to label
                                                self.addGestureToLabel(label: cell.textLabel!, index: row.indexPath!)
                                                
                                                // Test 
                                                print("Cell updating with index Path", row.indexPath!)
                                                cell.titleLabel!.frame = CGRect(x: (cell.titleLabel?.frame.origin.x)!, y: (cell.titleLabel?.frame.origin.x)!, width: 160.0 , height: (cell.titleLabel?.frame.height)!)
                                                
                                            }
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
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
                                        // Adjust label frame
                                        $0.cell.titleLabel?.frame = CGRect(x: ($0.cell.titleLabel?.frame.origin.x)!, y: ($0.cell.titleLabel?.frame.origin.x)!, width: 160.0 , height: ($0.cell.titleLabel?.frame.height)!)
                                        
                                        // Set label
                                        $0.title = val.keys.first!
                                        
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        
                                        //$0.tag = "Phone Numbers"
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Phone"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Set the label frame to align the values against left edge
                                            cell.titleLabel!.frame = CGRect(x: (cell.titleLabel?.frame.origin.x)!, y: (cell.titleLabel?.frame.origin.x)!, width: 160.0 , height: (cell.titleLabel?.frame.height)!)
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                            cell.titleLabel?.text = self.phoneLabels[(cell.row.indexPath?.row)!]
                                            
                                            
                                            // Add gesture to cell
                                            self.addGestureToLabel(label: cell.textLabel!, index: cell.row.indexPath!)
                                            
                                            
                                    }

                                }
                                
            }
            
            // Filler section
            //+++ Section("")
            
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
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("emailsRow_\(index)") {
                                        $0.title = "home "
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        // Add email validation
                                        // Add email validation
                                        $0.add(rule: RuleRequired())
                                        $0.add(rule: RuleEmail())
                                        //$0.validationOptions = .validatesAlways
                                        $0.add(rule: RuleEmail())
                                        $0.validationOptions = .validatesOnChange
                                        
                                        // Add label to labels
                                        self.emailLabels.append("home")
                                        self.emails.append(["home" : ""])
                                        
                                        // Config text field
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Email"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Add email validation
                                            row.add(rule: RuleRequired())
                                            row.add(rule: RuleEmail())
                                            //row.validationOptions = .validatesAlways
                                            row.validationOptions = .validatesOnChange
                                            
                                            if row.indexPath != nil{
                                                // Add to label
                                                self.addGestureToLabel(label: cell.textLabel!, index: row.indexPath!)
                                                
                                                // Test
                                                print("Cell updating with index Path", row.indexPath!)
                                                
                                            }
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                           
                                            
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
                                        $0.title = val["type"] ?? "work"
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate { cell, row in
                                            // Reconfig alignment
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Email"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Add gesture to cell
                                            self.addGestureToLabel(label: cell.textLabel!, index: cell.row.indexPath!)
                                            
                                            cell.titleLabel?.text = val["type"] ?? "work"
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                    }

                                }
            }
            
            // Filler section
            //+++ Section("")
            
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
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("websitesRow_\(index)") {
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        //$0.add(rule: RuleURL())
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Url"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Config auto correct
                                            cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                            cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                        
                                            
                                    }
                                    
                                }
                                // Iterate through array and set val
                                
                                for val in websites{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Site"
                                        $0.value = val
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "Url"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                            
                                            
                                    }

                                }
            }
            // Filler section
            //+++ Section("")
            
            
            // Filler section
            //+++ Section("")
            
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
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return PostalAddressRow("addressRow_\(index)") {
                                        $0.streetPlaceholder = "Street"
                                        $0.statePlaceholder = "State"
                                        $0.cityPlaceholder = "City"
                                        $0.countryPlaceholder = "Country"
                                        $0.postalCodePlaceholder = "Zip Code"
                                        
                                        // Add label to labelArrays
                                        self.addressLabels.append("home")
                                        self.addresses.append(["home" : ""])
                                        
                                        
                                        // Make all
                                        $0.cell.stateTextField?.autocapitalizationType = UITextAutocapitalizationType.allCharacters
                                        
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
                                                    
                                                    // Init line view
                                                    let headerView = UIView()
                                                    
                                                    headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                                    headerView.backgroundColor = UIColor.lightGray
                                                    
                                                    
                                                    // Add seperator to label
                                                    cell.addSubview(headerView)
                                                    
                                                }
                                            }
                                    }
                                }
            }
            
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
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("tagRow_\(index)") {
                                        $0.placeholder = "Tag"
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        //$0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        //$0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }.cellUpdate({ (cell, row) in
                                        
                                        // Check if view exists
                                        for view in cell.subviews{
                                            
                                            if view.accessibilityIdentifier == "header"{
                                                
                                                // Don't add header
                                                print("Cell has view already")
                                                
                                                // Remove view
                                                view.removeFromSuperview()
                                                
                                            }
                                        }
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        cell.addSubview(headerView)
                                    })
                                }
                                
                                // Iterate through array and set val
                                for val in tags{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Tag"
                                        $0.value = val
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate({ (cell, row) in
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                        })
                                }
            }
            
            // Filler section
            //+++ Section("")
            
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
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            
                                            
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("notesRow_\(index)") {
                                        $0.placeholder = "Note"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.sentences
                                        //$0.tag = "Add Media Info"
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate({ (cell, row) in
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                        })
                                }
                                
                                // Iterate through array and set val
                                for val in notes{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Note"
                                        $0.value = val
                                        
                                        // Init line view
                                        let headerView = UIView()
                                        headerView.accessibilityIdentifier = "header"
                                        headerView.frame = CGRect(x: 0, y: $0.cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                        headerView.backgroundColor = UIColor.lightGray
                                        // Add seperator to label
                                        $0.cell.addSubview(headerView)
                                        
                                        }.cellUpdate({ (cell, row) in
                                            
                                            // Check if view exists
                                            for view in cell.subviews{
                                                
                                                if view.accessibilityIdentifier == "header"{
                                                    
                                                    // Don't add header
                                                    print("Cell has view already")
                                                    
                                                    // Remove view
                                                    view.removeFromSuperview()
                                                    
                                                }
                                            }
                                            
                                            // Init line view
                                            let headerView = UIView()
                                            headerView.accessibilityIdentifier = "header"
                                            headerView.frame = CGRect(x: 0, y: cell.frame.height - 0.5, width: self.tableView.frame.width, height: 0.5)
                                            headerView.backgroundColor = UIColor.lightGray
                                            // Add seperator to label
                                            cell.addSubview(headerView)
                                        })
                                }
        }

        
    
        
        
            
            /*
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "",
                               footer: "") {
                                $0.tag = "Address Section 2"
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Address"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("addressRow_\(index)") {
                                        $0.title = "home "
                                        $0.cell.titleLabel?.textColor = self.view.tintColor
                                        
                                        // Add label to labels
                                        self.addressLabels.append("home")
                                        self.addresses.append(["home" : ""])
                                        
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
                                    
                                
                                }
                                
                                // Iterate through array and set val
                                for val in addresses{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Address"
                                        $0.value = val.values.first!//val
                                        $0.title = val.keys.first!
                                        
                                        }.cellUpdate { cell, row in
                                            // Label config
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = self.view.tintColor
                                            
                                            // Add gesture to cell
                                            self.addGestureToLabel(label: cell.textLabel!, index: cell.row.indexPath!)
                                            
                                            // Set text
                                            cell.titleLabel?.text = self.addressLabels[(cell.row.indexPath?.row)!]
                    
                                            
                                    }

                                }
        }*/
        
        
        //let titleValues = self.form.sectionBy(tag: "Title Section")
        //print("section index: ", titleValues?.index)
        
        
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
        self.setImageData()
        
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
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEditViewController.updateCellLabel), name: NSNotification.Name(rawValue: "Update Labels"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileEditViewController.parseForSocialIcons), name: NSNotification.Name(rawValue: "RefreshEditProfile"), object: nil)
        
        // Update user
       // NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.uploadEditedUser), name: NSNotification.Name(rawValue: "UpdateCurrentUserProfile"), object: nil)
        
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
    
    func selectProfilePicture(_ sender: AnyObject) {
        
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
            
            // Set selected
            self.selectedImage = image!
            
            // Show cropper view
            ContactManager.sharedManager.userArrivedFromSocial = true
            
            //self.profileImageContainerView.layer.borderColor = UIColor.clear as! CGColor
            
            // Show cropper view
            self.dismiss(animated: true, completion: {
                self.showCropper(withImage: self.selectedImage)
            })
            
            
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

    
    func updateCurrentUser() {
        // Configure to send to server
        
        // Get verification phone
        let phone = UDWrapper.getString("verification_phone")
        
        ContactManager.sharedManager.currentUser.userPhoneForVerification = phone ?? ""
        
        
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
                UDWrapper.setDictionary("user", value: ContactManager.sharedManager.currentUser.toAnyObjectWithImage())
                
                // Refresh profile
                self.postNotificationForUpdate()
                
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
    
    func removeImageFromProfile(index: Int) {
        
        print("Initial list count \(ContactManager.sharedManager.currentUser.profileImages.count)")
        // Remove item at index
        ContactManager.sharedManager.currentUser.profileImages.remove(at: index)
        // Remove image from local list
        self.profileImages.remove(at: index)
        
        print("Post delete list count \(ContactManager.sharedManager.currentUser.profileImages.count)")
        
        self.profileImageCollectionView.reloadData()
        
        self.parseAccountForImges()
    }

    
    
    func parseForSocialIcons() {
        
        // Badge List
        self.initializeBadgeList()
        
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
            //self.collectionTableView.reloadData()
        }
        
        // Add image to the end of list
        let image = UIImage(named: "Green-1")
        self.socialBadges.append(image!)
        
        // Get images
        parseAccountForImges()
        
        // Reload table
        
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    
    
    func parseAccountForImges() {
        print("Parse account for images Executing")
        print("Parse account images count >> \(self.profileImages.count)")
        
        // Clear all from list
        self.profileImages.removeAll()
        
        print("Parse account images count post delete >> \(self.profileImages.count)")
        print("Profile images count for current user >> \(ContactManager.sharedManager.currentUser.profileImages.count)")
        
        // Set current user
        self.currentUser = ContactManager.sharedManager.currentUser
        
        // Check for image, set to imageview
        if currentUser.profileImages.count > 0{
            for img in currentUser.profileImages {
                let image = UIImage(data: img["image_data"] as! Data)
                // Append to list
                self.profileImages.append(image!)
            }
        }
        
        // Append dummy image to the end
        // Add image to the end of list
        let image = UIImage(named: "Green-1")
        self.profileImages.append(image!)
        
        print("Refreshing table of photos")
        
        // Refresh
        self.profileImageCollectionView.reloadData()
        
    }
    
    func setImageData() {
        // Image data png
        //let imageData = UIImagePNGRepresentation(self.profileImageContainerView.image!, 0.5)
        let imageData = UIImageJPEGRepresentation(self.selectedImage, 0.5)
        print(imageData!)
        
        // Generate id string for image
        let idString = currentUser.randomString(length: 20)
        
        // Assign asset name and type
        let fname = idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id": idString, "image_data": imageData!, "file_name": fname, "type": mimetype] as [String : Any]
        
        // Add image to user profile images
        ContactManager.sharedManager.currentUser.setImages(imageRecords: imageDict)
        
        print("Contact Manager total images count: >> \(ContactManager.sharedManager.currentUser.profileImages.count)")
        
        // Upload to Server
        // Save card to DB
        let parameters = imageDict
        print(parameters)
        
        // Init imageURLS
        let urls = ImageURLS()
        
        // Create URL For Prod
        //let prodURL = urls.uploadToStagingURL
        
        // Create URL For Test
        let testURL = urls.uploadToDevelopmentURL
        
        
        // Show progress HUD
        //KVNProgress.show(withStatus: "Adding image to profile..")
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "files", fileName: "\(fname).jpg", mimeType: "image/jpg")
            
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
                    
                    // Dismiss hud
                    //KVNProgress.showSuccess()
                    
                    // Reload table
                    self.parseAccountForImges()
                    
                    
                    //self.profileImageCollectionView.reloadData()
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }
        
        
        // Test if image stored
        //print(self.newUser.profileImages)
        
    }
    
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
        ContactManager.sharedManager.currentUser.userProfile.notes.removeAll()
        
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
        notes.removeAll()
        
        
    }
    
    func postNotificationForUpdate() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProfile"), object: self)
        
        //UpdateCurrentUserProfile
        
    }

    func parseEditedProfile() {
        // Parse form
        print("Hello!")
        
        // Clear manager arrays
        self.clearCurrentUserArrays()
        
            
            // Configure to send to server
            if firstNameTextField.text != "" && lastNameTextField.text != "" {
                // Fields not empty
                ContactManager.sharedManager.currentUser.firstName = firstNameTextField.text!
                ContactManager.sharedManager.currentUser.lastName = lastNameTextField.text!
                // Combine to make full name
                ContactManager.sharedManager.currentUser.fullName = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
            }

            
            
            // Clear the arrays
            self.removeAllFromArrays()
            
            // Assign all the items in each list to the contact profile on manager
            // Parse table section vals
            
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
            }
            
            // Titles Section
            let titleValues = form.sectionBy(tag: "Title Section")
            for val in titleValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        ContactManager.sharedManager.currentUser.userProfile.titles.append(["title" : str])
                        titles.append(str)
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
                        
                        // Strip phone to all numbers
                        let result = String(str.characters.filter { "01234567890.".characters.contains($0) })
                        
                        // Add to manager
                        ContactManager.sharedManager.currentUser.userProfile.setPhoneRecords(phoneRecords: [label : result])
                        
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
                        
                        ContactManager.sharedManager.currentUser.userProfile.emails.append(["email": str, "type": label])
                        
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
                        ContactManager.sharedManager.currentUser.userProfile.setWebsites(websiteRecords: ["website": str])
                    }
                }
            }
            
            // Social Media Section
            let mediaValues = form.sectionBy(tag: "Tag Section")
            for val in mediaValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        ContactManager.sharedManager.currentUser.userProfile.setTags(tagRecords: ["tag": str])
                        tags.append(str)
                        
                        //print("Social links not needed here anymore")
                    }
                }
            }
            
            // Organization section
            let organizationValues = form.sectionBy(tag: "Organization Section")
            for val in organizationValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        ContactManager.sharedManager.currentUser.userProfile.setOrganizations(organizationRecords: ["organization": str])
                        organizations.append(str)
                    }
                }
            }
        
        
        // Work Info Section
        let workValues = form.sectionBy(tag: "Notes Section")
        for val in workValues! {
            print(val.baseValue ?? "")
            if let str = "\(val.baseValue ?? "")" as? String{
                if str != "nil" && str != "" {
                    ContactManager.sharedManager.currentUser.userProfile.notes.append(["note" :str])
                    notes.append(str)
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
                        ContactManager.sharedManager.currentUser.userProfile.setAddresses(addressRecords: addressDict)
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
        
            // Call to update
            self.updateCurrentUser()
            
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
        //cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
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
