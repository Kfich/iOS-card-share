//
//  CardCollectionViewCell.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit


class CardCollectionViewCell: UICollectionViewCell {
    
    // Properties
    // ----------------------------------
    
    
    // IBOutlets
    // ----------------------------------
    
    // KFich Edits
    // Use the view created as a template to render in the collection view
    @IBOutlet var businessCardView: BusinessCardView!
    
    
    // Previous collection cell
    
    @IBOutlet weak var cardName: UILabel!
    
    @IBOutlet weak var cardSelectedBtn: UIButton!
    
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var cardDisplayName: UILabel!
    
    @IBOutlet weak var cardPhone: UILabel!
    
    @IBOutlet weak var cardEmail: UILabel!
    
    
    // Init 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    
    
}
