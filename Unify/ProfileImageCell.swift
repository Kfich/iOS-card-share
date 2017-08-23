//
//  ProfileImageCell.swift
//  Unify
//
//  Created by Kevin Fich on 8/23/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ProfileImageCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Properties
    var imageList = [UIImage]()
    
    // IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let image = UIImage(named: "user")
        imageList.append(image!)
        imageList.append(image!)
        imageList.append(image!)
        imageList.append(image!)
        imageList.append(image!)
        imageList.append(image!)
        
        self.reloadCollection()
        
        addObservers()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Custom Methods
    func addObservers() {
        // Call to refresh table
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileImageCell.reloadCollection), name: NSNotification.Name(rawValue: "RefreshProfileImages"), object: nil)
        
    }
    
    func reloadCollection() {
        self.collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Printing from cell >> \(self.imageList.count)")
        return self.imageList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        var cell = UICollectionViewCell()
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
        
        //configureViews(cell: cell)
            
        
        // Configure badge image
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        var image = UIImage()
        image = self.imageList[indexPath.row]
        // Set image
        imageView.image = image
        // Add subview
        cell.contentView.addSubview(imageView)
        
        configureViews(cell: cell)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Remove icon from list
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    func configureViews(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 23.0
        cell.contentView.clipsToBounds = true
        
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    func reloadCollectionData() {
        // Reload
        
        
        
    }

}

