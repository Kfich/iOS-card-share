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
    
    // Test data config
    let img1 = UIImage(named: "icn-social-facebook.png")
    let img2 = UIImage(named: "icn-social-facebook.png")
    let img3 = UIImage(named: "icn-social-facebook.png")
    let img4 = UIImage(named: "icn-social-facebook.png")
    let img5 = UIImage(named: "icn-social-facebook.png")
    let img6 = UIImage(named: "icn-social-facebook.png")
    let img7 = UIImage(named: "icn-social-facebook.png")
    let img8 = UIImage(named: "icn-social-facebook.png")
    let img9 = UIImage(named: "icn-social-facebook.png")
    let img10 = UIImage(named: "icn-social-facebook.png")
    let img11 = UIImage(named: "icn-social-facebook.png")
    
    
    // IBOutlets
    // --------------------------------
    
    @IBOutlet var mediaCollectionView: UICollectionView!
    
    // Page setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        
                mediaCollectionView.register(MediaThumbnailCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // galleryCollectionView.register(ProjectThumbnailViewCell.self, forCellWithReuseIdentifier: "GalleryThumbnailCell")
        
        
        // Reload table
        mediaCollectionView.reloadData()
        //galleryCollectionView.reloadData()
        
        thumbnailImageList = [img1!, img2!, img3!, img4!, img5!, img6!, img7!, img8!, img9!, img10!, img11!]
        
        links = ["https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/", "https://www.facebook.com/",]
        
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
    }
    
    
    // UICollectionViewDataSource & Delegate Protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return thumbnailImageList.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MediaThumbnailCell
        
        ///let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailCell", for: indexPath)
        
        cell.contentView.backgroundColor = UIColor.red
        
        // Set image from array of images
        //cell.mediaImageView.image = thumbnailImageList[indexPath.row]
        
        
        // configure the cells
        configureViews(cell: cell)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        // Set selected link
        self.selectedLink = links[indexPath.row]
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
        
    }
    
    func configureViews(cell: MediaThumbnailCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 75.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
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
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        // Check for id 
        if segue.identifier == "showAddSocialLink" {
            // Set destination 
            let nextVC = segue.destination as! SocialMediaDetailViewController
            // Pass selected link
            nextVC.selectedMediaLink = self.selectedLink
        }
     }
    
    
}












