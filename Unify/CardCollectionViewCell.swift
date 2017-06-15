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
    
    
    
    // Init 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    
    
}
