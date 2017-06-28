//
//  ContactListCell.swift
//  Unify
//
//  Created by Kevin Fich on 6/27/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class ContactListCell: UITableViewCell {
    
    // IBOutlets 
    
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var introImageView: UIImageView!

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
