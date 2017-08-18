//
//  CustomImageCell.swift
//  Unify
//
//  Created by Kevin Fich on 8/17/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation
import Eureka
import UIKit

final class CustomImageCell: Cell<SocialBagde>, CellType, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    // ----------------------------
    var currentCard = ContactCard()
    var currentUser = User()
    var badgeList = [UIImage]()
    
    
    // IBOutlets
    // ----------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
   
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        // we do not want our cell to be selected in this case. If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        
        // set a light background color for our cell
        backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }
    
    override func update() {
        super.update()
        
        
    }
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* if self.socialBadges.count != 0 {
         // Return the count
         return self.socialBadges.count
         }else{
         return 1
         }*/
        return badgeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardBadgeCell", for: indexPath)
        
        //cell.contentView.backgroundColor = UIColor.red
        self.configureBadges(cell: cell)
        
        //let badgeList = ContactManager.sharedManager.parseContactCardForSocialIcons(card: ContactManager.sharedManager.currentUserCards[indexPath.row])
        
        // Configure corner radius
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let image = badgeList[indexPath.row]
        
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

final class CustomImageRow: Row<CustomImageCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<CustomImageCell>(nibName: "CustomImageCell")
    }
}


struct SocialBagde: Equatable {
    var name: String
    var UIImage: String
    var badgeId: Date
    var pictureUrl: URL?

}
func ==(lhs: SocialBagde, rhs: SocialBagde) -> Bool {
    return lhs.name == rhs.name
}
