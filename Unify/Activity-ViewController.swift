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
        tableView.estimatedSectionHeaderHeight = 8.0
        self.automaticallyAdjustsScrollViewInsets = false
        // Set a header for the table view
       // let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
       // header.backgroundColor = .red
        //tableView.tableHeaderView = header
        
        // Init and configure segment controller
        segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        // Set tint
        segmentedControl.tintColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "Introductions", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Connections", at: 2, animated: false)
        //segmentedControl.insertSegment(withTitle: "Follow Up",at: 3, animated: false)
        
        segmentedControl.selectedSegmentIndex = 0
        
        // Add segment control to navigation bar
        self.navigationBar.titleView = segmentedControl

        
        // Set tint on main nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
    }
    
    // TableView Delegate & Data Source

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showFollowupSegue", sender: indexPath.row)
        
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
            v.backgroundColor = .clear
        
            // View between sections
        
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
        
        // config cell
        configureViewsForIntro(cell: cell)

        
        return cell
    }
    
    // View Configuration
    
    func configureViewsForIntro(cell: ActivityCardTableCell){
        // Add radius config & border color
        // Add radius config & border color
        cell.profileImage.layer.cornerRadius = 55.0
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.borderWidth = 1.5
        cell.profileImage.layer.borderColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0).cgColor

        
        // Add radius config & border color
        cell.recipientProfileImage.layer.cornerRadius = 55.0
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
        
        

        
    }

    func configureViewsForConnection(cell: ActivityCardTableCell){
        // Add radius config & border color
        // Add radius config & border color
        cell.connectionOwnerProfileImage.layer.cornerRadius = 55.0
        cell.connectionOwnerProfileImage.clipsToBounds = true
        cell.connectionOwnerProfileImage.layer.borderWidth = 1.5
        cell.connectionOwnerProfileImage.layer.borderColor = UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0).cgColor
        
        
        // Add radius config & border color
        cell.connectionRecipientImageView.layer.cornerRadius = 55.0
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
