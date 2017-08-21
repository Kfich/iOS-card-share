//
//  ProfileViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/31/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UICollectionViewDelegate, UICollectionViewDataSource{

    // Properties
    // ===================================
    
    //var currentUser = User()
    
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

    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    var selectedBadgeIndex : Int = 0
    
    // Bools to check if array contents empty
    var arraysPopulated = false
    
    var sections = [String]()
    var tableData = [String: [String]]()
    
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
    
    // Badge carosel
    @IBOutlet var badgeCollectionView: UICollectionView!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
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
        //currentUser = ContactManager.sharedManager.currentUser
        
        
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
        
        // Create badge list
        self.initializeBadgeList()
        // Assign profile values
        self.parseDataFromProfile()
        
        // For notifications
        addObservers()
        
        // Set table delegate and data source
        profileInfoTableView.delegate = self
        profileInfoTableView.dataSource = self
        
        
        // Set delegate for empty state
        profileInfoTableView.emptyDataSetSource = self
        profileInfoTableView.emptyDataSetDelegate = self
        // View to remove separators
        profileInfoTableView.tableFooterView = UIView()
        
        // Parse for social data
        //self.parseForSocialIcons()
        
        
        self.socialBadgeCollectionView.reloadData()
        
        profileInfoTableView.reloadData()
        self.badgeCollectionView.reloadData()
        
        // Set shadow
        self.shadowView.shadowRadius = 2
        self.shadowView.shadowMask = YIInnerShadowMaskTop
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //currentUser = ContactManager.sharedManager.currentUser
        
        
        // Assign profile values
       // self.parseDataFromProfile()
    }
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       /* if self.socialBadges.count != 0 {
            // Return the count
            return self.socialBadges.count
        }else{
            return 1
        }*/
        
        if collectionView == self.badgeCollectionView {
            // Return count
            return ContactManager.sharedManager.currentUser.userProfile.badgeList.count
        }else{
            
            return self.socialBadges.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if collectionView == self.badgeCollectionView {
            // Badge config
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
            
            self.configureBadges(cell: cell)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            let fileUrl = NSURL(string: ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            // Set image
            //imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBadgeCell", for: indexPath)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            // Set image
            imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.badgeCollectionView {
            // Set index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl
        }else{
            // Social link badges
            // Set selected index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
            
        }
        
        // Show WebVC
        self.launchMediaWebView()
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableData[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        /*if bios.count == 0 && workInformation.count == 0 && titles.count == 0 && emails.count == 0 && phoneNumbers.count == 0 && socialLinks.count == 0 && websites.count == 0 && organizations.count == 0{
            return "Edit profile to add information"
        }*/
        /*
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
            return "Edit profile to add information"
        }*/
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        cell.descriptionLabel.text = tableData[sections[indexPath.section]]?[indexPath.row]
        
        /*switch indexPath.section {
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
            // Set
            cell.titleLabel.text = "No Data"
            return cell
        }*/
        
        return cell
        
    }
    // Set row height
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0
    }
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Config container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Create section header buttons
        let imageName = "icn-time.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 12, height: 12)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(30, 9, 100, 15))
        lbl.text = "Recents"
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        containerView.addSubview(imageView)
        
        return containerView
    }
    */
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor.white
        
        // Add label to the view
        var lbl = UILabel(frame: CGRect(8, 3, 180, 15))
        lbl.text = sections[section]
        lbl.textAlignment = .left
        lbl.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        
        return containerView
        
        /*let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        // Add label to the view
        var lbl = UILabel(frame: CGRect(8, 3, 100, 15))
        lbl.textAlignment = .left
        
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Avenir", size: CGFloat(11))
        
        switch section {
        case 0:
            if bios.count != 0 {
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
                containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                
                // Create section header buttons
                let imageName = "icn-time.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 10, y: 10, width: 12, height: 12)
                
                // Add label to the view
                //lbl = UILabel(frame: CGRect(30, 9, 100, 15))
                lbl.text = "Recents"
                lbl.textAlignment = .left
                lbl.textColor = UIColor.white
                lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
                
                // Add subviews
                containerView.addSubview(lbl)
                containerView.addSubview(imageView)
                return containerView
            }
        case 1:
            if workInformation.count != 0 {
                lbl.text = "Work"
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
                containerView.backgroundColor = UIColor.clear//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                // Add label to view
                containerView.addSubview(lbl)
                return containerView
            }
                
        case 2:
            if titles.count != 0 {
                lbl.text = "Titles"
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
                containerView.backgroundColor = UIColor.clear//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                // Add label to view
                containerView.addSubview(lbl)
                return containerView
            }
        case 3:
            if emails.count != 0 {
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
                containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                
                // Create section header buttons
                let imageName = "icn-time.png"
                let image = UIImage(named: imageName)
                let imageView = UIImageView(image: image!)
                imageView.frame = CGRect(x: 10, y: 10, width: 12, height: 12)
                
                // Add label to the view
                //lbl = UILabel(frame: CGRect(30, 9, 100, 15))
                lbl.text = "Recents"
                lbl.textAlignment = .left
                lbl.textColor = UIColor.white
                lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
                
                // Add subviews
                containerView.addSubview(lbl)
                containerView.addSubview(imageView)
                return containerView
            }
            
        case 4:
            if phoneNumbers.count != 0 {
                lbl.text = "Phone Numbers"
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
                containerView.backgroundColor = UIColor.clear//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                // Add label to view
                containerView.addSubview(lbl)
                return containerView
            }
            
        case 5:
            if socialLinks.count != 0 {
                lbl.text = "Social Media"
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
                containerView.backgroundColor = UIColor.clear//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                // Add label to view
                containerView.addSubview(lbl)
                return containerView
            }
            
        case 6:
            if websites.count != 0 {
                lbl.text = "Websites"
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
                containerView.backgroundColor = UIColor.clear//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                // Add label to view
                containerView.addSubview(lbl)
                return containerView
            }
            
        case 7:
            if organizations.count != 0 {
                lbl.text = "Organizations"
                let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 19))
                containerView.backgroundColor = UIColor.clear//UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
                // Add label to view
                containerView.addSubview(lbl)
                return containerView
            }
            
        default:
            lbl.text = ""

        }
        return view*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    
    
    // Custom Methods
    // -----------------------------------
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.parseDataFromProfile), name: NSNotification.Name(rawValue: "RefreshProfile"), object: nil)
        
        
    }
    
    func launchMediaWebView() {
        // Config the social link webVC
        //ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    func launchBadgeWebView() {
        // Config the social link webVC
        ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SocialWebVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
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
        let img11 = UIImage(named: "icn-social-facebook.png")
        let img12 = UIImage(named: "icn-social-twitter.png")
        let img13 = UIImage(named: "icn-social-instagram.png")
        let img14 = UIImage(named: "icn-social-harvard.png")
        let img15 = UIImage(named: "icn-social-pinterest.png")
        let img16 = UIImage(named: "icn-social-pinterest.png")
        let img17 = UIImage(named: "icn-social-facebook.png")
        let img18 = UIImage(named: "icn-social-facebook.png")
        let img19 = UIImage(named: "icn-social-facebook.png")
        let img20 = UIImage(named: "icn-social-facebook.png")
        let img21 = UIImage(named: "icn-social-facebook.png")
        let img22 = UIImage(named: "icn-social-facebook.png")
        let img23 = UIImage(named: "icn-social-facebook.png")
        
        // Hash images
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["harvard" : img4!], ["pinterest" : img5!], ["snapchat" : img6!], ["plus.google" : img7!], ["crunchbase" : img8!], ["youtube" : img9!], ["soundcloud" : img10!], ["flickr" : img11!], ["about.me" : img12!], ["angelist" : img13!], ["foursquare" : img14!], ["medium" : img15!], ["tumblr" : img16!], ["picasa" : img17!], ["quora" : img18!], ["reddit" : img19!], ["messenger" : img20!], ["whatsapp" : img21!], ["viber" : img22!], ["skype" : img23!]]
        
        
        // let fb : NSDictionary = ["facebook" : img1!]
        // self.socialLinkBadges.append([fb])
        
        
    }
    
    func parseForSocialIcons() {
        
        
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
        self.sections.removeAll()
        self.tableData.removeAll()
        
        // Parse bio info
        //currentUser = ContactManager.sharedManager.currentUser
        
        if ContactManager.sharedManager.currentUser.userProfile.bios.count > 0{
            // Add section
            sections.append("Bios")
            // Iterate throught array and append available content
            for bio in ContactManager.sharedManager.currentUser.userProfile.bios{
                bios.append((bio["bio"])!)
                print(bio["bio"])
            }
            
            // Create section data 
            self.tableData["Bios"] = bios
        }
        
        // Parse work info
        
        if ContactManager.sharedManager.currentUser.userProfile.workInformationList.count > 0{
            // Add section
            sections.append("Work")
            // Iterate and parse
            for info in ContactManager.sharedManager.currentUser.userProfile.workInformationList{
                workInformation.append((info["work"])!)
            }
            // Create section data
            self.tableData["Work"] = workInformation
        }
        // Parse work info
        if ContactManager.sharedManager.currentUser.userProfile.titles.count > 0{
            // Add section
            sections.append("Titles")
            for info in ContactManager.sharedManager.currentUser.userProfile.titles{
                titles.append((info["title"])!)
                print(info["title"])
            }
            // Create section data
            self.tableData["Titles"] = titles
        }
        
         if ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.count > 0{
            // Add section
            sections.append("Phone Numbers")
            for number in ContactManager.sharedManager.currentUser.userProfile.phoneNumbers{
                phoneNumbers.append((number["phone"])!)
            }
            // Create section data
            self.tableData["Phone Numbers"] = phoneNumbers
         
        }
        // Parse emails
        
        if ContactManager.sharedManager.currentUser.userProfile.emails.count > 0{
            // Add section
            sections.append("Emails")
            for email in ContactManager.sharedManager.currentUser.userProfile.emails{
                emails.append(email["email"]!)
            }
            // Create section data
            self.tableData["Emails"] = emails
        }
        
        // Parse websites
        if ContactManager.sharedManager.currentUser.userProfile.websites.count > 0{
            // Add section
            sections.append("Websites")
            for site in ContactManager.sharedManager.currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
            // Create section data
            self.tableData["Websites"] = websites
         
        }
         // Parse organizations
        if ContactManager.sharedManager.currentUser.userProfile.organizations.count > 0{
            // Add section
            sections.append("Organizations")
            for org in ContactManager.sharedManager.currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
            // Create section data
            self.tableData["Organizations"] = organizations
        }
         // Parse Tags
        if ContactManager.sharedManager.currentUser.userProfile.tags.count > 0{
            // Add section
            sections.append("Tags")
            
            for hashtag in ContactManager.sharedManager.currentUser.userProfile.tags{
         
                tags.append(hashtag["tag"]!)
        
            }
            // Create section data
            self.tableData["Tags"] = tags
         }
        
        // Parse notes
         if ContactManager.sharedManager.currentUser.userProfile.notes.count > 0{
         
            // Add section
            sections.append("Notes")
            for note in ContactManager.sharedManager.currentUser.userProfile.notes{
         
            notes.append(note["note"]!)
         
            }
            // Create section data
            self.tableData["Notes"] = notes
         }
         // Parse socials links
         if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
         
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
         
               // socialLinks.append(link["link"]!)
                print("ParseProfileData function executing")
         
            }
            
         }
        
        print("This is the section count .. \(sections.count)")
        
        // Parse out social icons
        self.parseForSocialIcons()
        
        // Refresh table
        profileInfoTableView.reloadData()
        socialBadgeCollectionView.reloadData()
        
        print("PRINTING USER from profile view")
        ContactManager.sharedManager.currentUser.printUser()

    }

    func parseData() {
        // Re parse for values
        
        // Reload data values
        // Assign profile image val
        
        /*if let biosArray = UDWrapper.getArray("bios"){
            
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
        }*/
        
        
        
        profileInfoTableView.reloadData()
        
    }
    
    func checkForEmptyData() -> Bool {
        if bios.count == 0 && titles.count == 0 && workInformation.count == 0 && socialLinks.count == 0 && websites.count == 0 && emails.count == 0 && phoneNumbers.count == 0 && organizations.count == 0{
            // Everything is empty
            return true
        }else{
            return false
        }
    }

    
    func configureViews(){
        
        // Round out the card view and set the background colors 
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 2.0
        self.profileCardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        // Config imageview
        self.configureSelectedImageView(imageView: self.profileImageView)
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 0.5
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor

    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    
    func populateCards(){
        
        var currentUser = ContactManager.sharedManager.currentUser
        
        // Senders card
        // Assign current user from manager
        currentUser = ContactManager.sharedManager.currentUser
        
        if currentUser.profileImages.count > 0 {
            profileImageView.image = UIImage(data: currentUser.profileImages[0]["image_data"] as! Data)
        }
        if currentUser.fullName != ""{
            nameLabel.text = currentUser.fullName
        }
        if currentUser.userProfile.phoneNumbers.count > 0{
            numberLabel.text = currentUser.userProfile.phoneNumbers[0]["phone"]
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
    
    // Empty State Delegate Methods
    
    // Settings
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        
        // All arrays are empty
        if checkForEmptyData() == true {
            return true
        }else{
            return false
        }
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        // Lock scroll
        return false
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        // Configure string
        
        let emptyString = "No Profile Info Found"
        let attrString = NSAttributedString(string: emptyString)
        
        return attrString
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        // Config Message for user
        
        let emptyString = ""
        let attrString = NSAttributedString(string: emptyString)
        
        return attrString
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControlState) -> NSAttributedString? {
        // Config button for data set
        
        let emptyString = "Tap to Start Unifying"
        
        let blue = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        let attributes = [ NSForegroundColorAttributeName: blue ]
        
        let attrString = NSAttributedString(string: emptyString, attributes: attributes)
        
        return attrString
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        // Set to height of header bar
        return -64
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap view: UIView) {
        // Configure action for tap
        print("The View Was tapped")
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTap button: UIButton) {
        // Configure action for button tap
        print("The Button Was tapped")
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
