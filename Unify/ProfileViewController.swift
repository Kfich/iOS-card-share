//
//  ProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/31/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    // Properties
    // ===================================
    
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
    // ===================================
    
    @IBOutlet var profileInfoTableView: UITableView!
    @IBOutlet var profileCardWrapperView: UIView!
    
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    
    // Buttons
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    @IBOutlet var viewCardsButton: UIButton!
    

    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Create test user
        /*currentUser.firstName = "Kevin"
        currentUser.lastName = "Fich"
        currentUser.userId = "54321"
        currentUser.fullName = currentUser.getName()
        currentUser.emails.append(["email": "kfich7@aol.com"])
        currentUser.emails.append(["email": "kfich7@gmail.com"])
        currentUser.phoneNumbers.append(["phone": "1234567890"])
        currentUser.phoneNumbers.append(["phone": "0987654321"])
        currentUser.phoneNumbers.append(["phone": "6463597308"])
        //currentUser.profileImage = UIImage(named: "throwback")!
        currentUser.scope = "user"*/

        // Assign current user from manager
        currentUser = ContactManager.sharedManager.currentUser
        
        
        // View Config
        configureViews()
        
        // Set up card viewer 
        populateCards()
        
        // Configure background image graphics
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Configure Nav bar
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        // Set color
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        // Assign profile values
        self.parseData()
        
        // For notifications
        addObservers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        currentUser = ContactManager.sharedManager.currentUser
        
        // Parse bio info
       /* if currentUser.userProfile.bios.count > 0{
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
                notes.append(link["link"]!)
            }
        }*/
        
    }
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------
    
    
    
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
            // Set
            cell.titleLabel.text = "No Data"
            return cell
        }
        
        
        
    }

    
    
    // Custom Methods
    // -----------------------------------
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.parseData), name: NSNotification.Name(rawValue: "RefreshProfile"), object: nil)
        
    }
    
    func parseData() {
        // Re parse for values 
        
        // Reload data values
        // Assign profile image val
        
        if let biosArray = UDWrapper.getArray("bios"){
            
            // Reload table data
            for value in biosArray {
                self.bios.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        
        if let titlesArray = UDWrapper.getArray("titles"){
            
            // Reload table data
            for value in titlesArray {
                self.titles.append(value as! String)
            }
        }else{
            print("User has no titles")
        }
        if let workArray = UDWrapper.getArray("workInfo"){
            
            // Reload table data
            for value in workArray {
                self.workInformation.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        if let phonesArray = UDWrapper.getArray("phoneNumbers"){
            
            // Reload table data
            for value in phonesArray {
                self.phoneNumbers.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        if let emailsArray = UDWrapper.getArray("emails"){
            
            // Reload table data
            for value in emailsArray {
                self.emails.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        if let socialArray = UDWrapper.getArray("socialLinks"){
            
            // Reload table data
            for value in socialArray {
                self.socialLinks.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        if let orgsArray = UDWrapper.getArray("organizations"){
            
            // Reload table data
            for value in orgsArray {
                self.organizations.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        if let webArray = UDWrapper.getArray("websites"){
            
            // Reload table data
            for value in webArray {
                self.websites.append(value as! String)
            }
            
        }else{
            print("User has no cards")
        }
        
        
        profileInfoTableView.reloadData()
        
    }

    
    func configureViews(){
        
        // Round out the card view and set the background colors 
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 2.0
        self.profileCardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 0.5
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        


    }
    
    func populateCards(){
        
        // Senders card
        // Assign current user from manager
        currentUser = ContactManager.sharedManager.currentUser
        
        if currentUser.profileImages.count > 0 {
            profileImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        if currentUser.fullName != ""{
            nameLabel.text = currentUser.fullName
        }
        if currentUser.phoneNumbers[0]["profile_phone"] != nil{
            numberLabel.text = currentUser.phoneNumbers[0]["profile_phone"]
        }
        if currentUser.emails[0]["profile_email"] != nil{
            emailLabel.text = currentUser.emails[0]["profile_email"]
        }
        
        //titleLabel.text = "Founder & CEO, CleanSwipe"
        
        // Assign media buttons
        mediaButton1.image = UIImage(named: "icn-social-twitter.png")
        mediaButton2.image = UIImage(named: "icn-social-facebook.png")
        mediaButton3.image = UIImage(named: "icn-social-harvard.png")
        mediaButton4.image = UIImage(named: "icn-social-instagram.png")
        mediaButton5.image = UIImage(named: "icn-social-pinterest.png")
        mediaButton6.image = UIImage(named: "icn-social-twitter.png")
        mediaButton7.image = UIImage(named: "icn-social-facebook.png")
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
