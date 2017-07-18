//
//  CardSelectionViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/28/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MessageUI

class CardSelectionViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // Properties
    // --------------------------------------------
    var active_card_unify_uuid: String?
    
    var selectedCard = ContactCard()
    var currentUser = User()
    
    // Parsed profile arrays
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
    // --------------------------------------------
    @IBOutlet var followupActionToolbar: UIToolbar!
    @IBOutlet var socialMediaToolbar: UIToolbar!
    @IBOutlet var cardWrapperView: UIView!
    @IBOutlet var cardShadowView: UIView!
    @IBOutlet var contactOutreachToolbar: UIToolbar!
    
    // Outreach toolbar
    @IBOutlet var outreachChatButton: UIBarButtonItem!
    @IBOutlet var outreachCallButton: UIBarButtonItem!
    @IBOutlet var outreachMailButton: UIBarButtonItem!
    
    
    // Tableview
    @IBOutlet var profileInfoTableView: UITableView!
    
    // Card info outlets
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var contactImageView: UIImageView!
    @IBOutlet var smsButton: UIBarButtonItem!
    @IBOutlet var emailButton: UIBarButtonItem!
    @IBOutlet var callButton: UIBarButtonItem!
    
    
    
    
    // IBActions / Buttons Pressed
    // --------------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        //dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func smsSelected(_ sender: AnyObject) {
        
        let composeVC = MFMessageComposeViewController()
        
        if(MFMessageComposeViewController .canSendText()){
            
            composeVC.messageComposeDelegate = self
            
            // 6468251231
            
            // Configure the fields of the interface.
            composeVC.recipients = ["6463597308"]
            composeVC.body = "Hi, I'd like to connect with you. Here's my information \n\n\(String(describing: selectedCard.cardHolderName))\n\(String(describing: selectedCard.cardProfile.emails[0]["email"]))\n\(String(describing: selectedCard.cardProfile.title)))"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func emailSelected(_ sender: AnyObject) {
        // Create instance of controller
        let mailComposeViewController = configuredMailComposeViewController()
        
        // Check if deviceCanSendMail
        if MFMailComposeViewController.canSendMail() {
            
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    @IBAction func callSelected(_ sender: AnyObject) {
        
        // configure call
        
    }
    
    @IBAction func editCardSelected(_ sender: Any) {
        
       
        /*// Show add card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
        self.present(controller, animated: true, completion: nil)
        
        // Pass selected card to view
        ContactManager.sharedManager.selectedCard = selectedCard
        
        // Set switch to true
        ContactManager.sharedManager.userSelectedEditCard = true*/
        
        // For the boys
        KVNProgress.showSuccess(withStatus: "Coming soon, don't worry")
        
    }
    
    
    // Page Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Page Setup
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Do any additional setup after loading the view.
        
        // Config Views
        configureViews()
        
        // Populate the cardviewer
        populateCards()
        
        // Configure background image graphics
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
        
        // Config navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: Int(0.0/255.0), green: Int(97.0/255.0), blue: Int(140.0/255.0))
        
        // Set color to nav bar
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 28/255.0, green: 52/255.0, blue: 110/255.0, alpha: 1.0)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : Any]
        
        
        // Parse card for profile info
        
        
        if selectedCard.cardProfile.bio != ""{
            bios.append(selectedCard.cardProfile.bio!)
        }
        if selectedCard.cardProfile.workInfo != ""{
            workInformation.append(selectedCard.cardProfile.bio!)
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            for number in selectedCard.cardProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]! as! String)
            }
        }
        
        if selectedCard.cardProfile.emails.count > 0{
            for email in selectedCard.cardProfile.emails{
                emails.append(email["email"]! as! String)
            }
        }
        if selectedCard.cardProfile.websites.count > 0{
            for site in selectedCard.cardProfile.websites{
                websites.append(site["website"]! as! String)
            }
        }
        if selectedCard.cardProfile.organizations.count > 0{
            for org in selectedCard.cardProfile.organizations{
                organizations.append(org["organization"]! as! String)
            }
        }
        if selectedCard.cardProfile.tags.count > 0{
            for hashtag in selectedCard.cardProfile.tags{
                tags.append(hashtag["tag"]! as! String)
            }
        }
        if selectedCard.cardProfile.notes.count > 0{
            for note in selectedCard.cardProfile.notes{
                notes.append(note["note"]! as! String)
            }
        }
        if selectedCard.cardProfile.socialLinks.count > 0{
            for link in selectedCard.cardProfile.socialLinks{
                notes.append(link["link"]! as! String)
            }
        }
        
        // Reload table data 
        profileInfoTableView.reloadData()

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        //if biosPopulated && titlesPopulated && workInformationPopulated && emailsPopulated && titlesPopulated && organizationsPopulated && websitesPopulated
        
        /*var count = 0
         // Iterate through arrays and see if populated
         switch count {
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
         return 0
         }
         */
        return 8
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
            return 0
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
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        
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
            cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            return cell
        case 4:
            cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            return cell
        case 5:
            cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = socialLinks[indexPath.row]
            return cell
        case 6:
            cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = websites[indexPath.row]
            return cell
        case 7:
            cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            return cell
        default:
            // Set
            cell.titleLabel.text = "No Data"
            return cell
        }
        
        
        
    }
    
    // Message Composer Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        // Make checks here for
        controller.dismiss(animated: true) { 
            print("Message composer dismissed")
        }
    }

    
    // Email Composer Delegate Methods
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        // Create Instance of controller
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        // Check for nil vals 
        
        var name = ""
        var phone = ""
        var email = ""
        var title = ""
        
        // Populate label fields
        if selectedCard.cardHolderName != "" || selectedCard.cardHolderName != nil{
           name = selectedCard.cardHolderName!
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            phone = selectedCard.cardProfile.phoneNumbers[0]["phone"]! as! String
        }
        if selectedCard.cardProfile.emails.count > 0{
            email = selectedCard.cardProfile.emails[0]["email"]! as! String
        }
        if selectedCard.cardProfile.title != "" || selectedCard.cardProfile.title != nil{
            title = self.selectedCard.cardProfile.title!
        }
        
        
        // Create Message
        mailComposerVC.setToRecipients(["kfich7@gmail.com"])
        mailComposerVC.setSubject("Greetings - Let's Connect")
        mailComposerVC.setMessageBody("Hi, I'd like to connect with you. Here's my information \n\n\(name))\n\(title)\n\(email))\n\(title)))", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    // Custom Methods
    // -------------------------------------------
    
    func populateCards(){
        // Senders card config
        
        // Populate image view
        if selectedCard.cardProfile.images.count > 0{
            contactImageView.image = UIImage(data: selectedCard.cardProfile.images[0]["image_data"] as! Data)
        }
        // Populate label fields
        if let name = selectedCard.cardHolderName{
            nameLabel.text = name
        }
        if selectedCard.cardProfile.phoneNumbers.count > 0{
            phoneLabel.text = selectedCard.cardProfile.phoneNumbers[0]["phone"] as! String
        }
        if selectedCard.cardProfile.emails.count > 0{
            emailLabel.text = selectedCard.cardProfile.emails[0]["email"] as! String
        }
        if let title = selectedCard.cardProfile.title{
            titleLabel.text = title
        }
        // Here, parse data to populate tableview
    }
    
    func configureViews(){
        // Round out the vards here
        // Configure cards
        self.cardWrapperView.layer.cornerRadius = 12.0
        self.cardWrapperView.clipsToBounds = true
        self.cardWrapperView.layer.borderWidth = 2.0
        self.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        self.profileInfoTableView.layer.cornerRadius = 12.0
        self.profileInfoTableView.clipsToBounds = true
        self.profileInfoTableView.layer.borderWidth = 2.0
        self.profileInfoTableView.layer.borderColor = UIColor.white.cgColor
        
        // Set shadow on the container view
                
        
        // Toolbar button config
        
        outreachChatButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        outreachMailButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        outreachCallButton.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir", size: 13)!], for: UIControlState.normal)
        
        
        
        // Config buttons
        // ** Email and call inverted
        smsButton.image = UIImage(named: "btn-chat-blue")
        callButton.image = UIImage(named: "btn-message-blue")
        
        // Hide call button
        emailButton.image = UIImage(named: "")
        emailButton.isEnabled = false
        outreachCallButton.isEnabled = false
        outreachCallButton.title = ""
        
    }

    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
