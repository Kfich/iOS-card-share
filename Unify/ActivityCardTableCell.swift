//
//  ActivityCardTableCell.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit


class ActivityCardTableCell: UITableViewCell {
    
    // Configuration and connections for Introduction 
    // activity card
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var recipientProfileImage: UIImageView!
    @IBOutlet var followupViewContainer: UIView!
    
    @IBOutlet var followupButton: UIButton!
    
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var recipientLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    // Buttons
    @IBOutlet var approveButton: UIButton!
    @IBOutlet var rejectButton: UIButton!
    
    // Configuration and connections for Connection
    // activity card
    
    @IBOutlet var connectionCardWrapperView: UIView!
    @IBOutlet var connectionOwnerProfileImage: UIImageView!
    @IBOutlet var connectionDescriptionLabel: UILabel!
    
    @IBOutlet var connectionRecipientImageView: UIImageView!
    
    @IBOutlet var connectionRecipientNameLabel: UILabel!
    
    @IBOutlet var connectionDateLabel: UILabel!
    
    @IBOutlet var connectionLocationLabel: UILabel!
    
    @IBOutlet var connectionFollowupViewContainer:UIView!
    @IBOutlet var connectionFollowupButton: UIButton!
    
    // Buttons
    @IBOutlet var connectionApproveButton: UIButton!
    @IBOutlet var connectionRejectButton: UIButton!
    // Cleanup down here
  
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
    
    // CellD - Button config
    @IBAction func approveIntroActivity(_ sender: Any) {
        // Test 
        print("Approve intro")
        
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Approve Connection"), object: self)
    }
    
    @IBAction func rejectIntroActivity(_ sender: Any) {
        // Test
        print("Reject intro")
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reject Connection"), object: self)

    }
    
    @IBAction func approveConnectionActivity(_ sender: Any) {
        // Test
        print("Approve connect ")
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Approve Connection"), object: self)

    }
    
    @IBAction func rejectConnectionActivity(_ sender: Any) {
        // Test
        print("Reject connect ")
        // Post notification for radarPullupVC
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Reject Connection"), object: self)

    }
    
    
    
    
    
}







