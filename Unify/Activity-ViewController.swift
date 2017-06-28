//
//  Activity-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import UIDropDown


class ActivtiyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Properties
    // ----------------------------------------
    
    var segmentedControl = UISegmentedControl()
    
    @IBOutlet var navigationBar: UINavigationItem!
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Page Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure tableview
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.estimatedSectionHeaderHeight = 8.0
        self.automaticallyAdjustsScrollViewInsets = false
        // Set a header for the table view
       // let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
       // header.backgroundColor = .red
        //tableView.tableHeaderView = header
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Introductions", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Connections", at: 2, animated: false)
        //segmentedControl.insertSegment(withTitle: "Follow Up",at: 3, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        
        // Add segment control to navigation bar
        self.navigationBar.titleView = segmentedControl
        
        
        // Set graphics for background of tableview
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)

        
        // Set tint on main nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
    }
    
    // TableView Delegate & Data Source

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showFollowupSegue", sender: self)
        
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Config container view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Create section header buttons
        let imageName = "icn-time.png"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 10, y: 10, width: 12, height: 12)
        
        // Add label to the view
        let lbl = UILabel(frame: CGRect(30, 9, 100, 15))
        lbl.text = "3 hours"
        lbl.textAlignment = .left
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        containerView.addSubview(imageView)

        return containerView
    }
   
    
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
 
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check what cell is needed
        var cell = UITableViewCell()
        
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
            configureViewsForIntro(cell: cell as! ActivityCardTableCell)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
            configureViewsForConnection(cell: cell as! ActivityCardTableCell)
        }
        
        // config cell
        

        
        return cell
    }
    
    // View Configuration
    
    func configureViewsForIntro(cell: ActivityCardTableCell){
        // Add radius config & border color
        // Add radius config & border color
        /*
        cell.profileImage.layer.cornerRadius = 35.0
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.borderWidth = 1.5
        cell.profileImage.layer.borderColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0).cgColor

        
        // Add radius config & border color
        cell.recipientProfileImage.layer.cornerRadius = 35.0
        cell.recipientProfileImage.clipsToBounds = true
        cell.recipientProfileImage.layer.borderWidth = 1.5
        cell.recipientProfileImage.layer.borderColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0).cgColor
        // Add radius config & border color
        cell.cardWrapperView.layer.cornerRadius = 12.0
        cell.cardWrapperView.clipsToBounds = true
        cell.cardWrapperView.layer.borderWidth = 1.5
        cell.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
        cell.followupViewContainer.layer.shadowColor = UIColor.black.cgColor
        cell.followupViewContainer.layer.shadowOpacity = 1
        cell.followupViewContainer.layer.shadowOffset = CGSize.zero
        cell.followupViewContainer.layer.shadowRadius = 10
        
        
        /*cell.followupViewContainer.layer.shadowPath = UIBezierPath(rect: cell.followupViewContainer.bounds).cgPath*/
        */
        

        
    }

    func configureViewsForConnection(cell: ActivityCardTableCell){
        // Add radius config & border color
        // Add radius config & border color
        
        /*cell.connectionOwnerProfileImage.layer.cornerRadius = 35.0
        cell.connectionOwnerProfileImage.clipsToBounds = true
        cell.connectionOwnerProfileImage.layer.borderWidth = 1.5
        cell.connectionOwnerProfileImage.layer.borderColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0).cgColor
        
        
        // Add radius config & border color
        cell.connectionRecipientImageView.layer.cornerRadius = 35.0 
        cell.connectionRecipientImageView.clipsToBounds = true
        cell.connectionRecipientImageView.layer.borderWidth = 1.5
        cell.connectionRecipientImageView.layer.borderColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0).cgColor
        // Add radius config & border color
        cell.connectionCardWrapperView.layer.cornerRadius = 12.0
        cell.connectionCardWrapperView.clipsToBounds = true
        cell.connectionCardWrapperView.layer.borderWidth = 1.5
        cell.connectionCardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
        cell.connectionFollowupViewContainer.layer.shadowColor = UIColor.black.cgColor
        cell.connectionFollowupViewContainer.layer.shadowOpacity = 1
        cell.connectionFollowupViewContainer.layer.shadowOffset = CGSize.zero
        cell.connectionFollowupViewContainer.layer.shadowRadius = 10
        
        
        /*cell.followupViewContainer.layer.shadowPath = UIBezierPath(rect: cell.followupViewContainer.bounds).cgPath*/
        
        
        */
        
    }

    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "showFollowupSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            
            nextScene.active_card_unify_uuid = "\(sender!)" as String?
            
        }
        
    }
    
    
}
