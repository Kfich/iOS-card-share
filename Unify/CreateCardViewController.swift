//
//  CreateCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class CreateCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // Properties
    // ----------------------------
    var card = ContactCard()
    var currentUser = User()
    
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    
    
    // IBOutlets
    // ----------------------------
    @IBOutlet var cardOptionsTableView: UITableView!
    
    
    
    @IBOutlet var profileCardWrapperView: UIView!
    
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    
    // Buttons on social toolbar
    
    @IBOutlet var mediaButton1: UIBarButtonItem!
    @IBOutlet var mediaButton2: UIBarButtonItem!
    @IBOutlet var mediaButton3: UIBarButtonItem!
    
    @IBOutlet var mediaButton4: UIBarButtonItem!
    @IBOutlet var mediaButton5: UIBarButtonItem!
    @IBOutlet var mediaButton6: UIBarButtonItem!
    @IBOutlet var mediaButton7: UIBarButtonItem!
    
    
    
    

    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        // Do any additional setup after loading the view.
        
        emails = ["kfich7@gmail.com", "kfich7@aol.com", "bazzucablaster@gmail.com" ]
        phoneNumbers = ["1234567890", "6463597308", "3036558888"]
        socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
        organizations = ["crane.ai", "Hedgeable Inc", "CleanSwipe LLC", "Boys and Girls Club"]
        bios = ["Created a company for doing laundry on college campuses", "Full Stack Engineer at Crane.ai", "College athlete at the University of Miami"]
        websites = ["cleanswipe.co", "crane.ai", "privii.me"]
        titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
        workInformation = ["crane.ai", "Hedgeable Inc", "CleanSwipe LLC", "Boys and Girls Club"]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    @IBAction func doneCreatingCard(_ sender: Any) {
        
        // Assign temp card id
        card.cardId = "1234567890"
        
        // Print card to see if generated
        card.printCard()
        card.cardProfile.printProfle()
        
        // Add card to current user object card suite
        currentUser.cards.append(card)
        
        let parameters = card.toAnyObject()
        print("\n\n")
        print(card.toAnyObject())
        
        // Save card to DB
        Connection(configuration: nil).createCardCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print(response)
                
                // Here you set the id for the card and resubmit the object
                
                
            } else {
                print(error)
                // Show user popup of error message 
            }
        }

        
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return bios.count
        case 1:
            return workInformation.count
        case 2:
            return titles.count
        case 3:
            return emails.count
        case 4:
            return phoneNumbers.count
        case 5:
            return socialLinks.count
        case 6:
            return websites.count
        case 7:
            return organizations.count
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Bios"
        case 1:
            return "Work Information"
        case 2:
            return "Titles"
        case 3:
            return "Emails"
        case 4:
            return "Phone Numbers"
        case 5:
            return "Social Media Links"
        case 6:
            return "Websites"
        case 7:
            return "Organizations"
        default:
            return ""
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "Bio \(indexPath.row)"
            cell.descriptionLabel.text = bios[indexPath.row]
            return cell
        case 1:
            cell.titleLabel.text = "Work \(indexPath.row)"
            cell.descriptionLabel.text = workInformation[indexPath.row]
            return cell
        case 2:
            cell.titleLabel.text = "Title \(indexPath.row)"
            cell.descriptionLabel.text = titles[indexPath.row]
            return cell
        case 3:
            cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            return cell
        case 4:
            cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            return cell
        case 5:
            cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = socialLinks[indexPath.row]
            return cell
        case 6:
            cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = bios[indexPath.row]
            return cell
        case 7:
            cell.titleLabel.text = "Organizations \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            return cell
        default:
            return cell
        }

        
    }
    
    //MARK: - UITableViewDelegate
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell

        // Mark checkbox selected
        cell.accessoryType = .checkmark

        
        switch indexPath.section {
        case 0:
            card.cardProfile.bio = bios[indexPath.row]
        case 1:
            card.cardProfile.workInfo = workInformation[indexPath.row]
        case 2:
            card.cardProfile.title = titles[indexPath.row]
            
            // Assign label value
            self.titleLabel.text = titles[indexPath.row]
        case 3:
            card.cardProfile.phoneNumbers?.append(["phone_\(indexPath.row)" : phoneNumbers[indexPath.row]])
            
            // Assign label value
            self.numberLabel.text = phoneNumbers[indexPath.row]
        case 4:
            card.cardProfile.emails?.append(["email_\(indexPath.row)" : emails[indexPath.row]])
            
            // Assign label value
            self.emailLabel.text = emails[indexPath.row]
        case 5:
            card.cardProfile.socialLinks?.append(["link_\(indexPath.row)" : socialLinks[indexPath.row]])
        case 6:
            card.cardProfile.websites?.append(["website_\(indexPath.row)" : websites[indexPath.row]])
        case 7:
            card.cardProfile.organizations?.append(["phone\(indexPath.row)" : organizations[indexPath.row]])
        default:
            print("Nothing doing here..")
        }
        
        
        // Print card to test
        card.printCard()
    }
    
    

}
