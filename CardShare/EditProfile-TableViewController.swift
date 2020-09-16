//
//  EditProfile-TableViewController.swift
//  Unify
//


import Firebase
import UIKit
import PopupDialog
import CoreLocation

class EditProfileTableViewController: UITableViewController, CLLocationManagerDelegate  {
    
    
    var jsonGlobal: [String:Any]?
    var tableData: [String] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditableContactCell") as! EditableContactCell
        
        var key = self.tableData[indexPath.row] as! String
        
        print("cell -> \(key)")
        
        
        print( jsonGlobal?[key] )
        
        
        cell.keyLabel.setTitle(key, for: .normal)
        
        cell.valueInput.text = jsonGlobal?[key] as! String?
        
        
        
        
        return cell
        
        
    }
    
    
    
    //MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! EditProfileHeaderCell
        
        print(  self.jsonGlobal?["email"] )
        
        cell.firstName.text = self.jsonGlobal?["firstName"] as! String?
        
        cell.lastName.text = self.jsonGlobal?["lastName"] as! String?
        
        print("---------!")
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 175
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    
}
