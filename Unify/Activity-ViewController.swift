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
    var currentUser = User()
    var transactions = [Transaction]()
    var selectedUsers = [User]()
    var selectedTransaction = Transaction()
    var segmentedControl = UISegmentedControl()
    
    @IBOutlet var navigationBar: UINavigationItem!
    // IBOutlets
    // ----------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // Page Config
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Fetch the users transactions 
        getTranstactions()
        
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
        
        // Set selected transaction
        self.selectedTransaction = self.transactions[indexPath.row]
        
        // Pass in segue
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Check what cell is needed
        var cell = UITableViewCell()
        
        // Init transaction 
        let trans = transactions[indexPath.row]
        
        if trans.type == "connection" {
            // Configure Cell
            cell = tableView.dequeueReusableCell(withIdentifier: "CellD") as! ActivityCardTableCell
            configureViewsForIntro(cell: cell as! ActivityCardTableCell, index: indexPath.row)
        }else if trans.type == "intro"{
            
            // Configure Cell
            cell = tableView.dequeueReusableCell(withIdentifier: "CellDb") as! ActivityCardTableCell
            configureViewsForConnection(cell: cell as! ActivityCardTableCell, index: indexPath.row)
        }
 
        // config cell
        

        
        return cell
    }
    
    // Custom Methods
    
    func getTranstactions() {
        
        // 
        // Hit endpoint for updates on users nearby
        let parameters = ["data" : ["uuid": currentUser.userId]]
        
        print(">>> SENT PARAMETERS >>>> \n\(parameters))")
        
        // Create User Objects
        Connection(configuration: nil).getTransactionsCall(parameters, completionBlock: { response, error in
            if error == nil {
                
                print("\n\nConnection - Radar Response: \n\n>>>>>> \(response)\n\n")
                
                let dictionary : NSArray = response as! NSArray
                
                for item in dictionary {
                    // Update counter
                    // Init user objects from array
                    let trans = Transaction(snapshot: item as! NSDictionary)
                    trans.printTransaction()
                    
                    // Append users to radarContacts array
                    self.transactions.append(trans)
                }
                
                // Show sucess
                KVNProgress.showSuccess()
                
                
            } else {
                print(error)
                // Show user popup of error message
                print("\n\nConnection - Radar Error: \n\n>>>>>>>> \(error)\n\n")
                KVNProgress.show(withStatus: "There was an issue getting activities. Please try again.")
            }
            
        })
    
    }

    // View Configuration


    func configureViewsForIntro(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell
        let trans = transactions[index]
        
        // Assign user objects
        let user1 = selectedUsers[0]
        let user2 = selectedUsers[1]
        
        // See if image ref available
        let image = UIImage(named: "contact")
        cell.profileImage.image = image
        // Set description text
        cell.descriptionLabel.text = "You introduced \(user1.fullName) to \(user2.fullName)"
        
        // Set location
        cell.locationLabel.text = trans.location
    }

    func configureViewsForConnection(cell: ActivityCardTableCell, index: Int){
        // Set transaction values for cell 
        // Set transaction values for cell
        let trans = transactions[index]
        
        // Assign user objects
        let user1 = selectedUsers[0]
        
        // See if image ref available
        let image = UIImage(named: "contact")
        cell.profileImage.image = image
        // Set description text
        cell.descriptionLabel.text = "You connected with \(user1.fullName)"
        
        // Set location 
        cell.connectionLocationLabel.text = trans.location
        
        
    }

    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "showFollowupSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            // Pass the transaction object to nextVC
            nextScene.transaction = self.selectedTransaction
            nextScene.active_card_unify_uuid = "\(sender!)" as String?
            
            
        }
        
    }
    
    
}
