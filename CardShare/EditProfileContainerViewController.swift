//
//  EditProfileContainerViewController.swift
//  Unify
//


import UIKit
import Eureka

class EditProfileContainerViewController: FormViewController {
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    
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
    
    // IBOutlets
    // ----------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add observer for refresh
        self.addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set current user
        //currentUser = ContactManager.sharedManager.currentUser
        
        /*
        emails = ["example@gmail.com", "test@aol.com", "sample@gmail.com" ]
        phoneNumbers = ["1234567890", "6463597308", "3036558888"]
        socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
        organizations = ["crane.ai", "Example Inc", "Sample LLC", "Boys and Girls Club"]
        bios = ["Created a company for doing blank for example usecase", "Full Stack Engineer at Crane.ai", "College Professor at the University of Application Building"]
        websites = ["example.co", "sample.ai", "excuse.me"]
        titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
        workInformation = ["Job 1", "Job 2", "Example Job", "Sample Job"]*/
        
        
        // Parse card for profile info
        if ContactManager.sharedManager.userArrivedFromSocial {
            // Print Arrived form social
            print("Arrived from social")
            print("Arrived from social")
            print("Arrived from social")
       
        }else{
         
            // Parse profile info
            self.parseProfileData()
            
            
            self.tableView.backgroundColor = UIColor.white
            
            
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
            }
            
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
                            $0.cell.textField.autocorrectionType = UITextAutocorrectionType.no
                            $0.cell.textField.autocapitalizationType = UITextAutocapitalizationType.none
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
                    
                    
                    
                }
                /*+++ Section()
                <<< CustomImageRow { row in
                    row.value = SocialBagde(name: "Mathias",
                                     badgeId: "mathias@xmartlabs.com",
                                     image: Date(timeIntervalSince1970: 712119600),
                                     pictureUrl: URL(string: "http://lh4.ggpht.com/VpeucXbRtK2pmVY6At76vU45Q7YWXB6kz25Sm_JKW1tgfmJDP3gSAlDwowjGEORSM-EW=w300"))
                }*/
                
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
                                            $0.cell.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
                                            //$0.tag = "Phone Numbers"
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
               /*
                +++
                
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Work Info",
                                   footer: "") {
                                    $0.tag = "Work Section"
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Work Info"
                                            //$0.tag = "Add Work Info"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("workRow_\(index)") {
                                            $0.placeholder = "Work info"
                                            //$0.tag = "Add Work Info"
                                        }
                                    }
                                    // Iterate through array and set val
                                    for val in workInformation{
                                        $0 <<< NameRow() {
                                            $0.placeholder = "Work info"
                                            $0.value = val
                                            //$0.tag = "Add Work Info"
                                        }
                                    }
                }*/
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
                                        return NameRow("addRow_\(index)") {
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
        
        

    }
    
    // Custom methods
    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProfile"), object: self)
        
        //UpdateCurrentUserProfile
        
    }
    
    func postNotificationForUpdate() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateCurrentUserProfile"), object: self)
        
        //UpdateCurrentUserProfile
        
    }
    
    
    func addObservers() {
        // Refresh table
         NotificationCenter.default.addObserver(self, selector: #selector(EditProfileContainerViewController.clearForm), name: NSNotification.Name(rawValue: "RefreshEditProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileContainerViewController.parseEditedProfile), name: NSNotification.Name(rawValue: "ParseProfileForEdit"), object: nil)
        
        
    }
    func clearForm() {
        print("Form Clearing")
        
        // Remove all section of form
        form.removeAll()
    }
    
    func parseEditedProfile() {
        // Parse form
        print("Hello!")
        
        // Clear manager arrays 
        self.clearCurrentUserArrays()
        
        if ContactManager.sharedManager.userSelectedEditCard{
            
            
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
                        ContactManager.sharedManager.currentUser.userProfile.setPhoneRecords(phoneRecords: ["phone" : str])
                        phoneNumbers.append(str)
                        
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
                        ContactManager.sharedManager.currentUser.userProfile.emails.append(["email" : str])
                        emails.append(str)
                    }
                }
            }
            /*
            // Work Info Section
            let workValues = form.sectionBy(tag: "Work Section")
            for val in workValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        ContactManager.sharedManager.currentUser.userProfile.workInformationList.append(["work" :str])
                        workInformation.append(str)
                    }
                }
            }*/
            
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

            // Organization section
            let addressValues = form.sectionBy(tag: "Address Section")
            for val in addressValues! {
                print(val.baseValue ?? "")
                if let str = "\(val.baseValue ?? "")" as? String{
                    if str != "nil" && str != "" {
                        ContactManager.sharedManager.currentUser.userProfile.setAddresses(addressRecords: ["address": str])
                        addresses.append(str)
                    }
                }
            }

            // Set current user
            //ContactManager.sharedManager.currentUser = self.currentUser
            
            // Test to print profile
            print("PRINTING FROM CONTAINER CURRENT USER")
            ContactManager.sharedManager.currentUser.printUser()
            
            // Post notification
            self.postNotificationForUpdate()
            
            // Store user to device
            //UDWrapper.setDictionary("user", value: self.currentUser.toAnyObjectWithImage())
            
            //self.postNotification()
        }else{
            print("They chose to cancel")
        }

    }
    
    func parseProfileData()  {
        // Clear arrays
        self.removeAllFromArrays()
        
        if ContactManager.sharedManager.currentUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in ContactManager.sharedManager.currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
        }
        // Parse work info
        if ContactManager.sharedManager.currentUser.userProfile.workInformationList.count > 0{
            for info in currentUser.userProfile.workInformationList{
                workInformation.append(info["work"]!)
            }
        }
        // Parse work info
        if ContactManager.sharedManager.currentUser.userProfile.titles.count > 0{
            for info in ContactManager.sharedManager.currentUser.userProfile.titles{
                titles.append((info["title"])!)
            }
        }
        
        // Parse phone numbers
        if ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.count > 0{
            for number in ContactManager.sharedManager.currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
        }
        // Parse emails
        if ContactManager.sharedManager.currentUser.userProfile.emails.count > 0{
            for email in ContactManager.sharedManager.currentUser.userProfile.emails{
                emails.append(email["email"]!)
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
        // Parse Tags
        if ContactManager.sharedManager.currentUser.userProfile.tags.count > 0{
            for hashtag in ContactManager.sharedManager.currentUser.userProfile.tags{
                tags.append(hashtag["tag"]!)
            }
        }
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.notes.count > 0{
            for note in ContactManager.sharedManager.currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
        }
        // Parse addresses
        if ContactManager.sharedManager.currentUser.userProfile.addresses.count > 0{
            for add in ContactManager.sharedManager.currentUser.userProfile.addresses{
                addresses.append(add["address"]!)
            }
        }
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
            }
        }
        // Reload Table
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
        socialLinks.removeAll()
        workInformation.removeAll()
        tags.removeAll()
        addresses.removeAll()
        
        
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
    
    func updateCurrentUser() {
        // Configure to send to server
        
        
        // Send to server
        let parameters = ["data" : currentUser.toAnyObject(), "uuid" : currentUser.userId] as [String : Any]
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Store current user cards to local device
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        
        // Show progress hud
        //KVNProgress.show(withStatus: "Saving your new card...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).updateUserCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                print(dictionary)
                
                
                // Store user to device
                UDWrapper.setDictionary("user", value: ContactManager.sharedManager.currentUser.toAnyObjectWithImage())
                
                // Hide HUD
                KVNProgress.dismiss()
                
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
    }
    
}
