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
    
    
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Page Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedSectionHeaderHeight = 40.0
        self.automaticallyAdjustsScrollViewInsets = false
        // Set a header for the table view
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        header.backgroundColor = .red
        //tableView.tableHeaderView = header

        
        
        // Graphics config
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        self.tableView.backgroundColor = UIColor(patternImage: image)

        
    }
    
    // TableView Delegate & Data Source

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "singleActivitySegue", sender: indexPath.row)
        
        
    }
    
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
            v.backgroundColor = .clear
        
        
        // Segment Control configuration
        
        let segmentedControl = UISegmentedControl(frame: CGRect(x: 10, y: 5, width: tableView.frame.width - 20, height: 30))
        
        
            segmentedControl.tintColor = UIColor.white

            segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
            segmentedControl.insertSegment(withTitle: "Incoming", at: 1, animated: false)
            segmentedControl.insertSegment(withTitle: "Outgoing", at: 2, animated: false)
            segmentedControl.insertSegment(withTitle: "Follow Up",at: 3, animated: false)

            segmentedControl.selectedSegmentIndex = 0
        
            // add segment to view
            v.addSubview(segmentedControl)
        return v
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID") as! ActivityCardTableCell
        
        // config cell
        configureViews(cell: cell)

        
        return cell
    }
    
    // View Configuration
    
    func configureViews(cell: ActivityCardTableCell){
        // Add radius config & border color
        // Add radius config & border color
        cell.profileImage.layer.cornerRadius = 20.0
        cell.profileImage.clipsToBounds = true
        cell.profileImage.layer.borderWidth = 1.0
        cell.profileImage.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        cell.recipientProfileImage.layer.cornerRadius = 20.0
        cell.recipientProfileImage.clipsToBounds = true
        cell.recipientProfileImage.layer.borderWidth = 1.0
        cell.recipientProfileImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "singleActivitySegue"
        {
            
            let nextScene =  segue.destination as! SingleActivityViewController
            
            nextScene.active_card_unify_uuid = "\(sender!)" as String?
            
        }
        
    }
    
    
}
