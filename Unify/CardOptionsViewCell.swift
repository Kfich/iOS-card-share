//
//  CardOptionsViewCell.swift
//  Unify
//
//  Created by Kevin Fich on 6/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class CardOptionsViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
