//
//  FollowUp-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit
import PopupDialog
import UIDropDown
import Social
import MessageUI
import Eureka


class FollowUpViewController: FormViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    var contact = Contact()
    
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
    var addresses = [String]()
    
    // To check user intent
    //var doneButtonSelected = false
    
    var count = 0
    
    @IBOutlet var cardWrapperView: UIView!
    
    @IBOutlet var profileImageCollectionView: UICollectionView!
    
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
    
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5//self.socialBadges.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.blue
        
        if collectionView == self.profileImageCollectionView {
            // Config images
            self.configurePhoto(cell: cell)
        }else{
            // Badge config
            self.configureBadges(cell: cell)
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
    
    
    
    
    // Page setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        currentUser = ContactManager.sharedManager.currentUser
        
        
        
        // Parse card for profile info
        
        
        // Parse bio info
        
        /*if contact.bios.count > 0{
         // Iterate throught array and append available content
         for bio in currentUser.userProfile.bios{
         bios.append(bio["bio"]!)
         }
         }*/
        
        // Parse work info
        /*if contact.workInformationList.count > 0{
         for info in contact.workInformationList{
         workInformation.append(info["work"]!)
         }
         }*/
        
        // Parse work info
        if currentUser.userProfile.titles.count > 0{
            for info in currentUser.userProfile.titles{
                titles.append((info["title"])!)
                
            }
        }
        
        
        // Parse phone numbers
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
        // Parse socials links
        if currentUser.userProfile.tags.count > 0{
            for link in currentUser.userProfile.tags{
                tags.append(link["tag"]!)
            }
        }
        // Parse addresses
        if currentUser.userProfile.addresses.count > 0{
            for add in currentUser.userProfile.addresses{
                addresses.append(add["address"]!)
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
        
        
        // Set bg
        tableView.backgroundColor = UIColor.white
        
        //title = "Multivalued Examples"
        form +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Titles",
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
                                    return NameRow() {
                                        $0.title = "home "
                                        $0.cell.titleLabel?.textColor = UIColor.blue
                                        // Create headerview
                                       // self.addGestureToLabel(label: $0.cell.textLabel!, intent: "phone")
                                        
                                        }.cellUpdate { cell, row in
                                            
                                            cell.textField.textAlignment = .left
                                            cell.textField.placeholder = "(left alignment)"
                                            cell.titleLabel?.textColor = UIColor.red
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
                                    }
                                }
            }

          /*a  MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Titles",
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
                                        $0.placeholder = "Title"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                    }
                                }
                                // Iterate through array and set val
                                for val in titles{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Title"
                                        $0.value = val
                                    }
                                }
            }*/
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Company",
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
                                        $0.placeholder = "Name"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Organizations"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in organizations{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Name"
                                        $0.value = val
                                        //$0.tag = "Add Organizations"
                                        
                                    }
                                }
                                
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Phone Numbers",
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
                                    return PhoneRow("numbersRow_\(index)") {
                                        $0.placeholder = "Number"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Phone Numbers"
                                        $0.cell.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                                    }
                                }
                                // Iterate through array and set val
                                for val in phoneNumbers{
                                    $0 <<< PhoneRow() {
                                        $0.placeholder = "Number"
                                        $0.value = self.format(phoneNumber: val)//val
                                        //$0.tag = "Phone Numbers"
                                    }
                                }
                                
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Email Addresses",
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
                                        $0.placeholder = "Address"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Emails"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in emails{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Address"
                                        //$0.tag = "Add Emails"
                                        $0.value = val
                                    }
                                }
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Websites",
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
                                        $0.placeholder = "Site"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Websites"
                                    }
                                }
                                // Iterate through array and set val
                                
                                for val in websites{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Site"
                                        $0.value = val
                                        //$0.tag = "Add Websites"
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
                               header: "Tags",
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
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
                               header: "Notes",
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
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in notes{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Link"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Addresses",
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
                                    return NameRow("addressRow_\(index)") {
                                        $0.placeholder = "Address"
                                        $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                                        $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in addresses{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Address"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                    }
                                }
        }
        
        
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        
        // Assign all the items in each list to the contact profile on manager
        // Parse table section vals
        
        if ContactManager.sharedManager.userCreatedNewContact {
            
            
            
            // Titles Section
            let titleValues = form.sectionBy(tag: "Title Section")
            for val in titleValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        contact.titles.append(["title" : str])
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
                        contact.setPhoneRecords(phoneRecord: str)
                        phoneNumbers.append(str)
                    }
                }
            }
            
            // Email Section
            let emailValues = form.sectionBy(tag: "Email Section")
            for val in emailValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        // Append to arrays
                        contact.setEmailRecords(emailAddress: str)
                        emails.append(str)
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
                        contact.setWebsites(websiteRecord: str)
                    }
                }
            }
            
            /*// Social Media Section
             let mediaValues = form.sectionBy(tag: "Media Section")
             for val in mediaValues! {
             print(val.baseValue ?? "")
             if let str = "\(val.baseValue ?? "")" as? String{
             if str != "nil" && str != "" {
             // Append to array
             contact.setSocialLinks(socialLink: str)
             socialLinks.append(str)
             }
             }
             }*/
            
            // Notes Section
            let noteValues = form.sectionBy(tag: "Notes Section")
            for val in noteValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        // Set values to arrays
                        contact.setNotes(note: str)
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
                        contact.setTags(tag: str)
                        tags.append(str)
                        
                        //print("Social links not needed here anymore")
                    }
                }
            }
            
            // Address Section
            let addressValues = form.sectionBy(tag: "Address Section")
            for val in addressValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        contact.setAddresses(address: str)
                        addresses.append(str)
                        
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
                        // Append to arrays
                        contact.setOrganizations(organization: str)
                        organizations.append(str)
                    }
                }
            }
            
            // Add origin
            self.contact.origin = "unify"
            
            // Set contact to shared manager
            ContactManager.sharedManager.newContact = self.contact
            
            
            // Test to print profile
            ContactManager.sharedManager.newContact.printContact()
            
            
            // Post Alert
            self.postNotification()
            
        }else{
            print("They cancelled")
        }
        
    }
    
    // Custom methods
    
    // Page styling
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        
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
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 0.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
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
    
    
}





/*: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // Properties 
    // ---------------------------------------
    var currentUser = User()
    var transaction = Transaction()
    
    // Arrays to hold contact info
    var phoneNumbers = [String]()
    var emailAddresses = [String]()
    
    // Bool checks to see which medium to use
    var useEmails = false
    var usePhones = false
    
    var recipientIds = [String]()
    var selectedUsers = [User]()
    var selectedUserCard = ContactCard()
    var active_card_unify_uuid: String?
    
    //
    var usersHaveEmails = false
    var usersHavePhoneNumbers = false
    
    // IBOutlets
    // ---------------------------------------
    @IBOutlet var contactCardView: ContactCardView!
    
    @IBOutlet var cardWrapperView: UIView!
    
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
    
    // Buttons on contact bar 
    
    @IBOutlet var chatButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Configure background color with image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        // View config 
        configureViews()
        
        // Test data for cards 
        populateCards()
        
        
    }
    
    // IBActions / Buttons Pressed
    // ---------------------------------------
    
    @IBAction func scheduleMeeting_click(_ sender: Any) {
        
        print("open calendar app with as much pre-populated data possible")
        // Configure calendar
        UIApplication.shared.openURL(NSURL(string: "calshow://")! as URL)
    }
    

    @IBAction func sendTextBtn_click(_ sender: Any) {
        
        // Parse user objects to retrieve phone numbers 
        let phoneList = self.retrievePhoneForUsers(contactsArray: self.selectedUsers)
        // Show SMS client with phone number list
        self.showSMSCard(recipientList: phoneList)
    }
    
    @IBAction func sendEmailBtn_click(_ sender: Any) {
        
        self.showEmailCard()
    
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        // Handle navigation on button press 
        navigationController?.popViewController(animated: true)
    }
    
    
    // Custom Methods
    // --------------------------------
    
    // Custom Methods
    
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
        
        // Config buttons for chat, call, email
        chatButton.image = UIImage(named: "btn-chat-blue")
        emailButton.image = UIImage(named: "btn-message-blue")
        callButton.image = UIImage(named: "btn-call-blue")
    }
    
    func populateCards(){
        
        // Check for nil vals
        
        var name = ""
        var phone = ""
        var email = ""
        var title = ""
        
        // Populate label fields
        if selectedUserCard.cardHolderName != "" || selectedUserCard.cardHolderName != nil{
            name = selectedUserCard.cardHolderName!
        }
        if selectedUserCard.cardProfile.phoneNumbers.count > 0{
            phone = selectedUserCard.cardProfile.phoneNumbers[0]["phone"]!
        }
        if selectedUserCard.cardProfile.emails.count > 0{
            email = selectedUserCard.cardProfile.emails[0]["email"]!
        }
        if selectedUserCard.cardProfile.title != "" || selectedUserCard.cardProfile.title != nil{
            title = self.selectedUserCard.cardProfile.title ?? ""
        }
        
        if selectedUserCard.cardProfile.images.count > 0 {
            // Populate image view
            let imageData = selectedUserCard.cardProfile.images[0]["image_data"]
            profileImageView.image = UIImage(data: imageData as! Data)
        }
        
        // Senders card
        nameLabel.text = name
        numberLabel.text = phone
        emailLabel.text = email
        titleLabel.text = title
 
    }

    func createTransaction(type: String) {
        
        // Set type & Transaction data
        transaction.type = type
        transaction.setTransactionDate()
        transaction.senderName = ContactManager.sharedManager.currentUser.getName()
        transaction.senderId = ContactManager.sharedManager.currentUser.userId
        transaction.type = "connection"
        transaction.scope = "transaction"
        transaction.senderCardId = ContactManager.sharedManager.selectedCard.cardId!
        // Show progress hud
        KVNProgress.show(withStatus: "Saving your follow up...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                /*let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your follow up. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func getCardForTransaction(type: String) {
        // Show progress HUD
        KVNProgress.show(withStatus: "Fetching the card...")
        
        // Set senderCardId to params
        let parameters = ["uuid": self.transaction.senderCardId]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).getSingleCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Fetched Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                // Init temp card
                let card = ContactCard(snapshot: dictionary as NSDictionary)
                
                // Set selected card
                self.selectedUserCard = card
                
                // Populate the card rendering with info
                self.populateCards()
                
                // Make call to get users associated
                self.fetchUsersForTransaction()
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Fetched Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error fecthing your card. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    
    func fetchUsersForTransaction() {
        // Fetch the user data associated with users
        
        // Hit endpoint for updates on users nearby
        let parameters = ["data": self.transaction.recipientList]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        // Show progress
        KVNProgress.show(withStatus: "Fetching users for follow up ...")
        
        // Create User Objects
        Connection(configuration: nil).getUserListCall(parameters, completionBlock: { response, error in
            
            if error == nil {
                
                //print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                // Init dictionary to capture response
                let userArray = response as? NSDictionary
                // // Parse dictionary for array of trans
                print(userArray ?? "")
                
                // Create temp user list
                let userList = userArray?["data"] as! NSArray
                
                // Iterate over array, append trans to list
                for item in userList{
                    
                    // Init user objects from array
                    let user = User(snapshot: item as! NSDictionary)
                    
                    // Append users to Selected array
                    self.selectedUsers.append(user)
                }
                
                // Show sucess
                KVNProgress.showSuccess()
                
            } else {
                print(error ?? "")
                // Show user popup of error message
                print("\n\nConnection - User Fetch Error: \n\n>>>>>>>> \(String(describing: error))\n\n")
                KVNProgress.showError(withStatus: "There was an issue getting users. Please try again.")
            }
            // Regardless, hide hud
            KVNProgress.dismiss()
        })
        
    }
    
    func retrievePhoneForUsers(contactsArray: [User]) -> [String] {
        
        // Init email array
        var phoneList = [String]()
        
        // Iterate through email list for contact emails
        for contact in contactsArray {
            // Check for phone number
            if contact.userProfile.phoneNumbers[0]["phone"] != nil{
                let phone = contact.userProfile.phoneNumbers[0]["phone"]
                
                // Add phone to list
                phoneList.append(phone!)
                
                // Print to test phone
                print("PHONE !!!! PHONE")
                print("\n\n\(String(describing: phone))")
                print(phoneList.count)
            }
            
        }
        // Append emails to a list of emails
        
        // Return the list of emails
        return phoneList
        
    }
    
    func retrieveEmailsForUsers(contactsArray: [User]) -> [String] {
        
        // Init email array
        var emailList = [String]()
        
        // Iterate through email list for contact emails
        for contact in contactsArray {
            
            // Check for phone number
            if contact.userProfile.emails[0]["email"] != nil{
                let email = contact.userProfile.emails[0]["email"]
                
                // Add phone to list
                emailList.append(email!)
                
                // Print to test phone
                print("PHONE !!!! PHONE")
                print("\n\n\(String(describing: email))")
                print(emailList.count)
            }else{
                // Set all have emails switch to false
                
            }
            
        }
        // Append emails to a list of emails
        
        // Return the list of emails
        return emailList
    }
    
    
    
    func parseUserList(){
        
        // Get emails 
        self.emailAddresses = self.retrieveEmailsForUsers(contactsArray: self.selectedUsers)
        
        // Get phoneNumbers
        self.phoneNumbers = self.retrievePhoneForUsers(contactsArray: self.selectedUsers)
        
        // Check which medium to use
        if emailAddresses.count >= selectedUsers.count {
            // This means they all have emails 
            self.useEmails = true
        }else{
            // Default to use the phones
            self.usePhones = true
        }
        
    }
    
    
    func displayComposerSheet(){}
    

    
    
    // Mail Delegate
    func showEmailCard() {
        
        print("EMAIL CARD SELECTED")
        
        // Parse user list for emails
        let mailsList = self.retrieveEmailsForUsers(contactsArray: self.selectedUsers)
        
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController(recipientList: mailsList)
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
    func showSMSCard(recipientList: [String]) {
        
        print("SMS CARD SELECTED")
        // Send post notif
        
        let composeVC = MFMessageComposeViewController()
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // Configure message
            let str = "Hi,\n\nIt was a pleasure connecting with you. Looking to continuing our conversation.\n\nBest, \n\(currentUser.getName()) \n\n"
            
            // Set message string
            composeVC.body = str
            // Set recipient list
            composeVC.recipients = recipientList
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController(recipientList: [String]) -> MFMailComposeViewController {
        
        // Set Selected Card
        //selectedUserCard = The one associated with the trans
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        // Create Message
        mailComposerVC.setToRecipients(recipientList)
        mailComposerVC.setSubject("\(currentUser.getName()) - Nice to meet you")
        mailComposerVC.setMessageBody("Hi,\n\nIt was a pleasure connecting with you. Looking to continuing our conversation.\n\nBest, \n\(currentUser.getName()) \n\n", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == .cancelled {
            // User cancelled
            print("User cancelled")
            
        }else if result == .sent{
            // User sent
            self.createTransaction(type: "connection")
            // Dimiss vc
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }
        
        // Dimiss controller
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        if result == .cancelled {
            // User cancelled
            print("Cancelled")
            
        }else if result == .sent{
            // User sent
            // Create transaction
            self.createTransaction(type: "connection")
            // Dismiss VC
            self.dismiss(animated: true, completion: nil)
            
        }else{
            // There was an error
            KVNProgress.showError(withStatus: "There was an error sending your message. Please try again.")
            
        }

        
        // Make checks here for
        controller.dismiss(animated: true) {
            print("Message composer dismissed")
        }
    }
    
    
    
    
    // Navigation


}*/
