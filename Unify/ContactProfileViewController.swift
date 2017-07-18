//
//  ContactProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/24/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Contacts

class ContactProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    // Properties
    // --------------------------------------------
    
    var active_card_unify_uuid: String?
    
    var selectedContact = CNContact()
    let formatter = CNContactFormatter()
    
    // This contact card is really a transaction object
    var card = ContactCard()
    
    
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
    
    // Bools to check if array contents empty
    var biosPopulated = false
    var workInformationPopulated = false
    var organizationsPopulated = false
    var titlesPopulated = false
    var phoneNumbersPopulated = false
    var emailsPopulated = false
    var websitesPopulated = false
    var socialLinksPopulated = false
    var notesPopulated = false
    var tagsPopulated = false
    
    
    
    // IBOutlets
    // --------------------------------------------
    @IBOutlet var followupActionToolbar: UIToolbar!
    @IBOutlet var socialMediaToolbar: UIToolbar!
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var cardShadowView: UIView!
    @IBOutlet var contactOutreachToolbar: UIToolbar!
    
    // Outreach toolbar
    @IBOutlet var outreachChatButton: UIBarButtonItem!
    @IBOutlet var outreachCallButton: UIBarButtonItem!
    @IBOutlet var outreachMailButton: UIBarButtonItem!
    
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // Card info outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    @IBOutlet var calendarButton: UIBarButtonItem!
    
    
    @IBOutlet var phoneImageView: UIImageView!
    @IBOutlet var emailImageView: UIImageView!
    
    // Buttons
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)*/
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        /*
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)*/
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // configure call 
        
    }
    
    
    @IBAction func calendarSelected(_ sender: Any) {
        
        // Configure calendar
    }
    
    
    
    
    // Page Setup

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        // Do any additional setup after loading the view.
        // Test is segue passed properly
        
        print("Selected Contact -> \(selectedContact)")
        
        // Set format style 
        formatter.style = .fullName

        // Parse card for profile info 
        
        /*
        if card.cardProfile.bio != ""{
            bios.append(card.cardProfile.bio!)
        }
        if card.cardProfile.workInfo != ""{
            workInformation.append(card.cardProfile.bio!)
        }
        if card.cardProfile.phoneNumbers.count > 0{
            for number in card.cardProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
        }
        if card.cardProfile.emails.count > 0{
            for email in card.cardProfile.phoneNumbers{
                emails.append(email["email"]!)
            }
        }
        if card.cardProfile.websites.count > 0{
            for site in card.cardProfile.websites{
                websites.append(site["website"]!)
            }
        }
        if card.cardProfile.organizations.count > 0{
            for org in card.cardProfile.organizations{
                organizations.append(org["organization"]!)
            }
        }
        if card.cardProfile.tags.count > 0{
            for hashtag in card.cardProfile.tags{
                tags.append(hashtag["tag"]!)
            }
        }
        if card.cardProfile.notes.count > 0{
            for note in card.cardProfile.notes{
                notes.append(note["note"]!)
            }
        }
        if card.cardProfile.socialLinks.count > 0{
            for link in card.cardProfile.socialLinks{
                notes.append(link["link"]!)
            }
        }
        */
        
        
        // Config Views
        configureViews()
        
        // Populate the cardviewer
        populateCards()
        
        // Configure background image graphics
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        
        // Config navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: Int(0.0/255.0), green: Int(97.0/255.0), blue: Int(140.0/255.0))
        
        // Set color to nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        // reload table data
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        //if biosPopulated && titlesPopulated && workInformationPopulated && emailsPopulated && titlesPopulated && organizationsPopulated && websitesPopulated
        
        /*var count = 0
        // Iterate through arrays and see if populated
        switch count {
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
            return 0
        }
        */
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
            return 0
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
            // Set
            cell.titleLabel.text = "No Data"
            return cell
        }
        
        
        
    }
    

    
    // Custom Methods
    // -------------------------------------------
    func checkForArrayLenth(array: Array<Any>) -> Bool {
        var isEmpty = Bool()
        if array.count != 0{
            isEmpty = false
            return isEmpty
        }else{
            isEmpty = true
            return isEmpty
        }
    }
    
    
    func populateCards(){
        
        
        nameLabel.text = formatter.string(from: selectedContact) ?? "No Name"
        
        if selectedContact.phoneNumbers.count > 0 {
            phoneLabel.text = (selectedContact.phoneNumbers[0].value).value(forKey: "digits") as? String
        }else{
            // Hide phone icon image 
            phoneImageView.isHidden = true
        }
        if selectedContact.emailAddresses.count > 0 {
            emailLabel.text = (selectedContact.emailAddresses[0].value as String)
        }else{
            // Hide email icon
            emailImageView.isHidden = true
        }
        // Check if image data available
        if selectedContact.imageDataAvailable {

            print("Has IMAGE")
            // Create image var
            let image = UIImage(data: selectedContact.imageData!)
            // Set image for contact
            contactImageView.image = image
        }else{
            // Set to placeholder image
            contactImageView.image = UIImage(named: "profile")
        }

        // Senders card
        //contactImageView.image = UIImage(named: "throwback.png")
        //nameLabel.text = "Harold Fich"
        //phoneLabel.text = "1+ (123)-345-6789"
        //emailLabel.text = "Kev.fich12@gmail.com"
        //titleLabel.text = "Founder & CEO, CleanSwipe"
    }
    
    func configureViews(){
        // Round out the vards here 
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 2.0
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
        
        addDropShadow()
        
        // Assign media buttons
        mediaButton1.image = UIImage(named: "icn-social-twitter.png")
        mediaButton2.image = UIImage(named: "icn-social-facebook.png")
        mediaButton3.image = UIImage(named: "icn-social-harvard.png")
        mediaButton4.image = UIImage(named: "icn-social-instagram.png")
        mediaButton5.image = UIImage(named: "icn-social-pinterest.png")
        mediaButton6.image = UIImage(named: "icn-social-twitter.png")
        mediaButton7.image = UIImage(named: "icn-social-facebook.png")
        
        
        // Toolbar button config
        
        outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 14)!], for: UIControlState.normal)
        
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        callButton.image = UIImage(named: "btn-message-blue")
        emailButton.image = UIImage(named: "btn-call-blue")
        calendarButton.image = UIImage(named: "btn-calendar-blue")
    }
    
    func addDropShadow(scale: Bool = true) {
        
        cardShadowView.layer.masksToBounds = false
        cardShadowView.layer.shadowColor = UIColor.black.cgColor
        cardShadowView.layer.shadowOpacity = 0.5
        cardShadowView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cardShadowView.layer.shadowRadius = 1
        
        cardShadowView.layer.shadowPath = UIBezierPath(rect: cardShadowView.bounds).cgPath
        cardShadowView.layer.shouldRasterize = true
        cardShadowView.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
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
