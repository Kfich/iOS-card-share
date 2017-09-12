//
//  SocialMediaViewController.swift
//  Unify
//
//  Created by Kevin Fich on 8/3/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class SocialMediaViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // -------------------------------
    var currentUser = User()
    var links = [String]()
    var selectedLink = ""
    var thumbnailImageList = [UIImage]()
    var reuseIdentifier = "ThumbnailCell"
    var selectedIndex = 0
    
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
    //let img19 = UIImage(named: "green-plus-big.png")

    
    
    // IBOutlets
    // --------------------------------
    
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    // Page setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Assign user 
        //self.currentUser = ContactManager.sharedManager.currentUser
        //self.currentUser.printUser()
        
        // Assign delegates
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        
        mediaCollectionView.register(MediaThumbnailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // galleryCollectionView.register(ProjectThumbnailViewCell.self, forCellWithReuseIdentifier: "GalleryThumbnailCell")
        
        
        // Reload table
        mediaCollectionView.reloadData()
        //galleryCollectionView.reloadData()
        
        //thumbnailImageList = [img1!, img2!, img3!, img4!, img5!, img6!, img7!, img8!, img9!, img10!]
        
        //links = ["https://www.facebook.com/", "https://www.twitter.com/", "https://www.instagram.com/", "https://www.snapchat.com/", "https://www.linkedin.com/", "https://www.pinterest.com/", "https://www.tumblr.com/", "https://www.reddit.com/", "https://www.myspace.com/", "https://www.googleplus.com/"]
        
        links = ["https://www.facebook.com/", "https://www.twitter.com/", "https://www.instagram.com/", "https://www.pinterest.com/", "https://www.linkedin.com/", "https://www.snapchat.com/", "https://www.plus.google.com/", "https://www.crunchbase.com/", "https://www.youtube.com/",
                 "https://www.soundcloud.com/", "https://www.flickr.com/", "https://www.about.me/", "https://www.angel.co/", "https://www.foursquare.com/", "https://www.medium.com/", "https://www.tumblr.com/", "https://www.quora.com/", "https://www.reddit.com/"]
        
        //socialOptions = [, , , , , , , , , , , , , , , , , , , , , , ]
        
        // For notifcations 
        self.addObservers()
        
        mediaCollectionView.reloadData()
        
        mediaCollectionView.backgroundColor = UIColor.clear
        
        /*// Configure blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mediaCollectionView.backgroundView?.addSubview(blurEffectView)*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        thumbnailImageList = [img1!, img2!, img3!, img4!, img5!, img18!, img6!, img7!, img8!, img9!, img10!, img11!, img12!, img13!,img14!, img15!, img16!, img17!]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // ---------------------------------
    
    @IBAction func dismissView(_ sender: Any) {
        // Dismiss view 
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // UICollectionViewDataSource & Delegate Protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(thumbnailImageList.count)
        return thumbnailImageList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MediaThumbnailCell
        
        ///let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.clear
        
        
        // Set image from array of images
        //cell.mediaImageView.image =  UIImage(named: "icn-social-facebook.png")//thumbnailImageList[indexPath.row]
        
        
        // configure the cells
        configureViews(cell: cell, index: indexPath.row)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        // Set selected link
        self.selectedLink = links[indexPath.row]
        self.selectedIndex = indexPath.row
        // Hit the segue
        performSegue(withIdentifier: "showAddSocialLink", sender: self)
    }
    
    
    // Custom Methods
    
    func addObservers() {
        // Call to show success
        NotificationCenter.default.addObserver(self, selector: #selector(SocialMediaViewController.showConfirmHUD), name: NSNotification.Name(rawValue: "Media Selected"), object: nil)
        
    }
    
    func showConfirmHUD() {
        // Show HUD
        KVNProgress.showSuccess(withStatus: "Media link added successfully")
        
        // Post refresh notification
        self.postSocialRefreshNotification()
        
        // Dismiss vc
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func postSocialRefreshNotification() {
        // Notification to reload views
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshEditProfile"), object: self)
    }
    
    
    func configureViews(cell: MediaThumbnailCell, index: Int){
        
        if index != 18 {
            
            // Add radius config & border color
            cell.contentView.layer.cornerRadius = 45.0
            cell.contentView.clipsToBounds = true
            //cell.contentView.layer.borderWidth = 0.5
            //cell.contentView.layer.borderColor = UIColor.blue.cgColor
            
            // Set shadow on the container view
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 1.0
            cell.layer.shadowOffset = CGSize.zero
            cell.layer.shadowRadius = 0.5
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 0, y: 0 , width: 90, height: 90)
            //let image = thumbnailImageList[]
            imageView.image = thumbnailImageList[index]
            cell.contentView.addSubview(imageView)
            
        }else{
            
            // Add radius config & border color
            cell.contentView.layer.cornerRadius = 20
            cell.contentView.clipsToBounds = true
            //cell.contentView.layer.borderWidth = 0.5
            //cell.contentView.layer.borderColor = UIColor.blue.cgColor
            
            // Set shadow on the container view
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 1.0
            cell.layer.shadowOffset = CGSize.zero
            cell.layer.shadowRadius = 0.5
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 22, y: 10 , width: 40, height: 40)
            
            
            //let image = thumbnailImageList[]
            imageView.image = thumbnailImageList[index]
            cell.contentView.addSubview(imageView)
        }
       
        
        
        
        
        // Add radius config & border color
         /*cell.mediaImageView.layer.cornerRadius = 12.0
         cell.mediaImageView.clipsToBounds = true
         cell.mediaImageView.layer.borderWidth = 0.5
         cell.mediaImageView.layer.borderColor = UIColor.clear.cgColor
        
         // Set shadow on the container view
         cell.layer.shadowColor = UIColor.black.cgColor
         cell.layer.shadowOpacity = 1.5
         cell.layer.shadowOffset = CGSize.zero
         cell.layer.shadowRadius = 2*/
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        // Check for id 
        if segue.identifier == "showAddSocialLink" {
            // Set destination 
            let nextVC = segue.destination as! SocialMediaDetailViewController
            // Pass selected link
            nextVC.selectedMediaLink = self.selectedLink
            nextVC.selectedImage = self.thumbnailImageList[self.selectedIndex]
        }
     }
    
    
}












