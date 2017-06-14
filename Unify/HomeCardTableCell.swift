//
//  HomeCardTableCell.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//


import UIKit


class HomeCardTableCell: UITableViewCell {


    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print(collectionView.layer.frame.width)
        
    }
    




}
