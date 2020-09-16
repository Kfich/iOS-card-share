//
//  Profile-TableViewController.swift
//  Unify
//


import Firebase
import UIKit
import PopupDialog
import CoreLocation
import BMInputBox



class ProfileTableViewController: UITableViewController, CLLocationManagerDelegate  {
    
    // Properties
    // ============================================
    
    var jsonGlobal: [String:Any]?
    var tableData: [String] = []
    
    var selectedProfiles: [Int] = []
    
    
    // IBOutlets
    // ============================================
    
    @IBOutlet weak var EditOrSave: UIBarButtonItem!
    
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        getProfile()
    }
    

    
    // IBActions / Buttons Pressed
    // ============================================
    
    @IBAction func editBtn_click(_ sender: Any) {
        
         print(sender)
        
         if selectedProfiles.count == 0
         {
            self.performSegue(withIdentifier: "editProfileSegue", sender: self)
        
         } else {

            
            let inputBox = BMInputBox.boxWithStyle(.plainTextInput)
            
            
            inputBox.title = NSLocalizedString("Create Card", comment: "")
            inputBox.message = NSLocalizedString("Give Card Name", comment: "")
            inputBox.submitButtonText = NSLocalizedString("Create", comment: "")
            inputBox.cancelButtonText = NSLocalizedString("Back", comment: "")
            inputBox.validationLabelText = NSLocalizedString("Text must be 6 characters long.", comment: "")
            
            
            inputBox.blurEffectStyle = .light

            
            inputBox.show()
            
            
            inputBox.onSubmit = {(value: AnyObject...) in
               
                  DispatchQueue.main.async {
                    
                    
                    self.EditOrSave.title = "Edit"
                        self.tableView.reloadData()
                    
                }
                
            }
        }
        
        
        
        
    }
    
    // Tableview DataSource && Delegate Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tableData.count
   
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileContactCell") as! ProfileContactCell

            var key = self.tableData[indexPath.row] as! String
        
            print("cell -> \(key)")
        
        
            print( jsonGlobal?[key] )
        
        
            cell.cardTitle.text = key
        
            cell.cardValue.text = jsonGlobal?[key] as! String?

        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedProfiles.append(indexPath.row)
        
        EditOrSave.title = "Create Card"
        
        
        
    }
    
    
    //MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        // This is where you would change section header content
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ProfileHeaderCell

            print(  self.jsonGlobal?["email"] )
        
            cell.givenName.text = self.jsonGlobal?["givenName"] as! String?
        
            print("---------!")
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 150
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
    // Custom Methods
    // ============================================
    
    func getProfile(){
        
        
        let url:URL = URL(string: "https://unifyalphaapi.herokuapp.com/getProfile")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let paramString = "uuid=\(global_uuid!)"
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) {
            (
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    
                    //let contact = ContactRecord(json: json)
                    
                    print(json)
                    
                    //let jsonParsed = parsedData["currently"] as! [String:Any]
                    self.jsonGlobal = json
                    
                    
                    for (key, value) in json {
                        print("\(key) ->> \(value) ")
                        
                        if key != "givenName"
                        {
                            if let str = value as? String {
                                // obj is a String. Do something with str
                                self.tableData.append(key)
                            }
                            else {
                                // obj is not a String
                            }
                            
                        }
                        
                        
                    }
                    
                    print(json.count)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                    
                }
                
                
            } catch let error {
                
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
    

    // Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passing Contact Card Data")
        print(sender)
        
        if segue.identifier == "editProfileSegue"
        {
            
            let nextScene =  segue.destination as! EditProfileTableViewController
            
            nextScene.jsonGlobal = self.jsonGlobal
            nextScene.tableData = self.tableData
            
            
        }
        
    }
    
    
    
    
}








