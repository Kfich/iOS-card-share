//
//  ActivityCardTableCell.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit


class ActivityCardTableCell: UITableViewCell {
    
    
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var recipientProfileImage: UIImageView!
    @IBOutlet var followupViewContainer: UIView!
    
    @IBOutlet var followupButton: UIButton!
    
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var recipientLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    
  
    @IBOutlet weak var activityMessage: UILabel!
    
    @IBOutlet weak var activityAgo: UILabel!
    
    @IBOutlet weak var action1Icon: UIImageView!
    
    @IBOutlet weak var actionOne: UILabel!
    
    @IBOutlet weak var actionTwoIcon: UIImageView!
    
    @IBOutlet weak var actionTwo: UILabel!
    
    @IBOutlet weak var actionThreeIcon: UIImageView!
    
    @IBOutlet weak var actionThree: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    
    
}
