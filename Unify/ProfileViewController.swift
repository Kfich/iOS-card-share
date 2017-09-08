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
    var addresses = [String]()
    
    // Profile pics 
    var profileImagelist = [UIImage]()

    // Badge list
    var badges : [CardProfile.Bagde] = []
    
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
    @IBOutlet var profileImageCollectionView: UICollectionView!
    @IBOutlet var badgeCollectionView: UICollectionView!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    
    @IBOutlet var shadowView: YIInnerShadowView!
    
    @IBOutlet var imageContainerView: UIView!
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
        
        //self.imageContainerView.addSubview(self.profileImageCollectionView)
        //self.imageContainerView.backgroundColor = UIColor.green
        
        // Create container for collectionview
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.profileInfoTableView.frame.width, height: 200))
        containerView.backgroundColor = UIColor.black
        
        // Set collectionview frame
        //self.profileImageCollectionView.frame = CGRect(x: 10, y: 0, width: self.profileInfoTableView.frame.width, height: 200)
        
        // Add collection to container
        //containerView.addSubview(self.profileImageCollectionView)
        
        self.profileInfoTableView.tableFooterView = self.profileImageCollectionView
        
        
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
        
        /*// Get images
        self.parseAccountForImages()
        
        //self.profileInfoTableView.tableHeaderView = profileImageCollectionView
        
        //let container = UIView(frame: CGRect(x: 0, y: 0, width: self.profileInfoTableView.frame.width, height: 3))
        // container.backgroundColor = UIColor.gray
        //container.addSubview(self.profileImageCollectionView)
        
        
        
        self.profileInfoTableView.tableFooterView = self.profileImageCollectionView
        
        //currentUser = ContactManager.sharedManager.currentUser
        
        
        // Assign profile values
       // self.parseDataFromProfile()*/
        
        // Clear list
        self.badges.removeAll()
        
        // Check for visible badges
        for badge in ContactManager.sharedManager.badgeList {
            // Check if visible
            if badge.isHidden == false {
                // Append to list
                self.badges.append(badge)
                print("The bagde acount on append \(badge.pictureUrl ?? "Empty URL")")
                print(self.badges.count)
            }
        }
        
        // Test
        print("Done getting badges")
        
        
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
        
        //let container = UIView(frame: CGRect(x: 0, y: 0, width: self.profileInfoTableView.frame.width, height: 3))
        // container.backgroundColor = UIColor.gray
       // container.addSubview(self.profileImageCollectionView)
        
        
        // Set footer as images collection 
        
        self.profileInfoTableView.tableFooterView = self.profileImageCollectionView
        
        // Parse for social data
        //self.parseForSocialIcons()
        
        
        self.socialBadgeCollectionView.reloadData()
        
        profileInfoTableView.reloadData()
        self.badgeCollectionView.reloadData()
        
        // Set shadow
        self.shadowView.shadowRadius = 2
        self.shadowView.shadowMask = YIInnerShadowMaskTop
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
            return self.badges.count//ContactManager.sharedManager.currentUser.userProfile.badgeList.count
        }else if collectionView == self.socialBadgeCollectionView{
            
            return self.socialBadges.count
        }else{
            // Profile collection view
            return self.profileImagelist.count
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
            
            let fileUrl = NSURL(string: self.badges[indexPath.row].pictureUrl /*ContactManager.sharedManager.badgeList[indexPath.row].pictureUrl ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl*/)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            // Set image
            //imageView.image = image
            
            // Add subview
            cell.contentView.addSubview(imageView)
        
        }else if collectionView == self.socialBadgeCollectionView{
            
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
        }else{
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configurePhoto(cell: cell)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            let image = self.profileImagelist[indexPath.row]
            imageView.layer.masksToBounds = true
            // Set image to view
            imageView.image = image
            // Add to collection
            cell.contentView.addSubview(imageView)

            
            // Configure corner radius
            /*let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.profileImagelist[indexPath.row]
            
            // Set image
            imageView.image = image
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            // Add subview
            cell.contentView.addSubview(imageView)*/
            
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.badgeCollectionView {
            // Set index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl
            
            // Show WebVC
            self.launchMediaWebView()
            
        }else if collectionView == self.socialBadgeCollectionView{
            // Social link badges
            // Set selected index
            self.selectedBadgeIndex = indexPath.row
            // Config the social link webVC
            ContactManager.sharedManager.selectedSocialMediaLink = self.socialLinks[self.selectedBadgeIndex]
            
            // Show WebVC
            self.launchMediaWebView()
            
        }
        
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
        
        //var cell = UITableViewCell()
        
            // Set regular cell sections
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
            cell.descriptionLabel?.text = tableData[sections[indexPath.section]]?[indexPath.row]
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
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)//UIFont(name: "Avenir-Heavy", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    
    
    // Custom Methods
    // -----------------------------------
    
    // Custom Methods
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshProfileImages"), object: self)
        
        //UpdateCurrentUserProfile
        
    }
    
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
        let img19 = UIImage(named: "social-blank")
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!], ["snapchat" : img18!], ["other" : img19!]]

        
    }

    
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
        
        // Reload data table
        self.profileImageCollectionView.reloadData()
        
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
        // Init map of all keys
        let array = self.socialLinkBadges.flatMap({$0.keys})
        print("Map Array", array)
        
        //
        var knownSocialList : [String] = []
        
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
                   
                    /*
                    // Append link to list
                    self.socialBadges.append(item.first?.value as! UIImage)

                    //print("THE IMAGE IS PRINTING")
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(self.socialBadges.count)*/
                    
                    // Add to known social list
                    knownSocialList.append(link)
                    print("Known list ", knownSocialList)
                    
                }else{
                    print("The link was not in range")
                }
            }
            
            // Reload table
            self.socialBadgeCollectionView.reloadData()
        }
        
        
        // Iterate over links[]
        for link in self.socialLinks {
            print("Link In Social .. \(link)")
            
            if knownSocialList.contains(link) {
                // The item is known
                print("The link is contained here > \(link)")
            }else{
                // The item is known
                print("This link is not in the known list > \(link)")
            }
            
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
        self.tags.removeAll()
        self.addresses.removeAll()
        
        
        // Parse bio info
        //currentUser = ContactManager.sharedManager.currentUser
        
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

        // Parse organizations
        if ContactManager.sharedManager.currentUser.userProfile.organizations.count > 0{
            // Add section
            sections.append("Company")
            for org in ContactManager.sharedManager.currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
            // Create section data
            self.tableData["Company"] = organizations
        }
        
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
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.addresses.count > 0{
            
            // Add section
            sections.append("Addresses")
            for add in ContactManager.sharedManager.currentUser.userProfile.addresses{
                
                addresses.append(add["address"]!)
                
            }
            // Create section data
            self.tableData["Addresses"] = addresses
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
        
        // Get profile
        self.parseAccountForImages()
        
        // Refresh table
        profileInfoTableView.reloadData()
        socialBadgeCollectionView.reloadData()
        profileImageCollectionView.reloadData()
        
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

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureViews(){
        
        // Round out the card view and set the background colors 
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 0.5
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
        imageView.layer.borderWidth = 0.5
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





