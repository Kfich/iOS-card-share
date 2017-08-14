//
//  CardCollectionViewCell.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MessageUI

class CardCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Properties
    // ----------------------------------
    
    
    // IBOutlets
    // ----------------------------------
    
    // KFich Edits
    // Use the view created as a template to render in the collection view
    @IBOutlet var businessCardView: BusinessCardView!
    
    @IBOutlet var cardWrapperView: UIView!
    
    // Previous collection cell
    
    @IBOutlet weak var cardName: UILabel!
    
   // @IBOutlet weak var cardSelectedBtn: UIButton!
    
    @IBOutlet weak var cardImage: UIImageView!
    
   // @IBOutlet weak var cardDisplayName: UILabel!
   
    
    @IBOutlet var cardDisplayName: UILabel!
    
    @IBOutlet var cardTitle: UILabel!
    
    @IBOutlet weak var cardPhone: UILabel!
    
    @IBOutlet weak var cardEmail: UILabel!
    
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    // View that holds card name and send buttons 
    @IBOutlet var cardHeaderView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // Init 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    @IBAction func showEmailCard(_ sender: Any) {
       // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EmailCardFromRadar"), object: self)
        
        // Set Manager bool 
        ContactManager.sharedManager.quickshareEmailSelected = true
    }
    
    @IBAction func showEmailFromProfile(_ sender: Any) {
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EmailCardFromProfile"), object: self)
        
        // Set Manager bool
        ContactManager.sharedManager.quickshareEmailSelected = true
    }
    
    
    
    @IBAction func showSMSFromProfile(_ sender: Any) {
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SMSCardFromProfile"), object: self)
        
        // Set Manager bool
        ContactManager.sharedManager.quickshareSMSSelected = true
    }
    
    
    @IBAction func showSMSCard(_ sender: Any) {
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SMSCardFromRadar"), object: self)
        
        // Set Manager bool
        ContactManager.sharedManager.quickshareSMSSelected = true
    }

    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* if self.socialBadges.count != 0 {
         // Return the count
         return self.socialBadges.count
         }else{
         return 1
         }*/
        return ContactManager.sharedManager.socialBadges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardBadgeCell", for: indexPath)
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        // Configure corner radius
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let image = ContactManager.sharedManager.socialBadges[indexPath.row]
        
        // Set image
        imageView.image = image
        
        // Add subview
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //performSegue(withIdentifier: "showSocialMediaOptions", sender: self)
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
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
    
}
