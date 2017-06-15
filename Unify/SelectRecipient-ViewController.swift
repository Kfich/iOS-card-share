//
//  Contacts-TableViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import AlgoliaSearch
import InstantSearchCore
import Firebase
import UIKit
import PopupDialog
import CoreLocation
import Skeleton


class SelectRecipientViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UISearchBarDelegate, UISearchResultsUpdating, SearchProgressDelegate   {
    
    // Properties
    // ----------------------------------------------
    
    
    var searchController: UISearchController!
    
    var searchProgressController: SearchProgressController!
    
    var contactSearcher: Searcher!
    var contactsHits: [JSONObject] = []
    var originIsLocal: Bool = false
    
    let placeholder = UIImage(named: "white")
    
    
    // IBOutlets
    // ----------------------------------------------
    @IBOutlet var contactsTableView: UITableView!
    
    @IBOutlet var listSegmentController: UISegmentedControl!
    
    
    // IBActions
    // ----------------------------------------------
    
    @IBAction func switchContactList(_ sender: AnyObject) {
        
        print("LIST ALTERNATING")
    }
    
    
    
    // View Config
    
    fileprivate static let kRowHeight: CGFloat = 85
    
    override func viewWillAppear(_ animated: Bool) {
        // Show nav bar
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Contacts"
        
        
        // Add observers
        
        addObservers()
        
        // Tableview settings
        //contactsTableView.isScrollEnabled = false
        contactsTableView.separatorStyle = .none
        
        let nib = UINib(nibName: String(describing: SkeletonCell.self), bundle: nil)
        contactsTableView.register(nib, forCellReuseIdentifier: String(describing: SkeletonCell.self))
        
        
        UIGraphicsBeginImageContext(self.contactsTableView.frame.size)
        UIImage(named: "backgroundGradient")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.contactsTableView.backgroundColor = UIColor(patternImage: image)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        DispatchQueue.main.async {
            //self.tableView.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
        }
        
        
        // Algolia Search
        contactSearcher = Searcher(index: AlgoliaManager.sharedInstance.contactsIndex, resultHandler: self.handleSearchResults)
        contactSearcher.params.hitsPerPage = 15
        contactSearcher.params.attributesToRetrieve = ["givenName", "image", "rating", "year"]
        contactSearcher.params.attributesToHighlight = ["givenName"]
        
        // Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = NSLocalizedString("search_bar_placeholder", comment: "")
        
        // Add the search bar
        contactsTableView.tableHeaderView = self.searchController!.searchBar
        definesPresentationContext = true
        searchController!.searchBar.sizeToFit()
        
        searchController!.searchBar.barStyle = UIBarStyle.black
        
        // Configure search progress monitoring.
        searchProgressController = SearchProgressController(searcher: contactSearcher)
        //searchProgressController.delegate = self
        
        
        // First load
        
        let delayInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.updateSearchResults(for: self.searchController)
            
        }
        
        print("\n\n\n THIS IS THE CONTACT LIST COUNT\n\n")
        print(contactsHits.count)
        print(contactsHits)
        print("\n\n\n THIS IS THE CONTACT LIST COUNT\n\n")
        
        
        
    }
    
    // Cleanup
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    // MARK: - Search completion handlers
    
    private func handleSearchResults(results: SearchResults?, error: Error?) {
        guard let results = results else { return }
        if results.page == 0 {
            contactsHits = results.hits
        } else {
            contactsHits.append(contentsOf: results.hits)
        }
        originIsLocal = results.content["origin"] as? String == "local"
        self.contactsTableView.reloadData()
    }
    
    
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //MARK: - UITableViewDataSource
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        
       /* if contactsHits.count == 0
        {
            return Int(view.bounds.height/SelectRecipientViewController.kRowHeight) + 1
            
        } else {
            
            return contactsHits.count
        }*/
        
        return 3
        
    }
    
    /*
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SelectRecipientViewController.kRowHeight
    }*/
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if contactsHits.count == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SkeletonCell.self), for: indexPath) as! SkeletonCell
            
            //pre loader
            cell.gradientLayers.forEach { gradientLayer in
                
                //rcell.backgroundColor = .clear
                
                let baseColor = cell.titlePlaceholderView.backgroundColor!
                gradientLayer.colors = [baseColor.cgColor,
                                        baseColor.brightened(by: 0.93).cgColor,
                                        baseColor.cgColor]
            }
            
            return cell
            
        } else {
            
            //real contact cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
            
            cell.backgroundColor = .clear
            
            // Load more?
            if indexPath.row + 5 >= contactsHits.count {
                contactSearcher.loadMore()
            }
            
            // Configure the cell...
            //let contact = ContactRecord(json: contactsHits[indexPath.row])
            
            //cell.titleLabel.text = contact.givenName
            
            // Temp config for testing
            
            cell.backgroundColor = .clear
            
            // Load more?
            if indexPath.row + 5 >= contactsHits.count {
                contactSearcher.loadMore()
            }
            
            // Configure the cell...
            //let contact = ContactRecord(json: contactsHits[indexPath.row])
            
            //cell.titleLabel.text = contact.givenName
            
            // Temp config for testing
            
            cell.posterImageView.image = UIImage(named: "search.png")
            cell.bio.text = "Sally May"
            cell.titleLabel.text = "This is the BIO Label"
            cell.email.text = "kev@crane.ai"
            cell.phone.text = "+1(347)-234-7890"
            cell.mediaButton1.image = UIImage(named: "icn-social-twitter.png")
            cell.mediaButton2.image = UIImage(named: "icn-social-facebook.png")
            cell.mediaButton3.image = UIImage(named: "icn-social-harvard.png")
            cell.mediaButton4.image = UIImage(named: "icn-social-instagram.png")
            cell.mediaButton5.image = UIImage(named: "icn-social-pinterest.png")
            cell.mediaButton6.image = UIImage(named: "icn-social-twitter.png")
            cell.mediaButton7.image = UIImage(named: "icn-social-facebook.png")
            
            // Round out images
            configureViews(cell: cell)

            
            
            
            /*
             cell.textLabel?.text = contact.givenName
             
             cell.detailTextLabel?.text = contact.year != nil ? "\(contact.year!)" : nil
             cell.imageView?.cancelImageDownloadTask()
             if let url = contact.imageUrl {
             cell.imageView?.setImageWith(url, placeholderImage: placeholder)
             }
             else {
             cell.imageView?.image = nil
             }
             cell.backgroundColor = originIsLocal ? AppDelegate.colorForLocalOrigin : UIColor.white
             */
            
            return cell
        }
        
    }
    
    //MARK: - UITableViewDelegate
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if contactsHits.count == 0
        {
            let skeletonCell = cell as! SkeletonCell
            skeletonCell.slide(to: .right)
            
        } else {
            
            //real contact cell
            //let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "background")?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            
            
            
            cell.contentView.backgroundColor = UIColor.clear
            
            let whiteRoundedView : UIView = UIView(frame: CGRect(5, 10, self.view.frame.size.width - 10, SelectRecipientViewController.kRowHeight - 10))
            
            whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 1.0])
            whiteRoundedView.layer.masksToBounds = false
            //whiteRoundedView.layer.cornerRadius = 2.0
            // whiteRoundedView.layer.shadowOffset = CGSize(-1, 1)
            // whiteRoundedView.layer.shadowOpacity = 0.2
            
            cell.contentView.addSubview(whiteRoundedView)
            cell.contentView.sendSubview(toBack: whiteRoundedView)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set arrival from contacts to true

        ContactManager.sharedManager.userArrivedFromRecipients = true

        if ContactManager.sharedManager.userArrivedFromIntro{
            // Perform information transfer
            // -> Give contact record to the manager
            
            
            // Navigate appropriately
            
            navigationController?.popViewController(animated: true)
        }else{
            
            dismiss(animated: true, completion: nil)
            
            // Testing to show the card on the intro page after selection
            ContactManager.sharedManager.userArrivedFromRecipients = true
            
            
            //self.performSegue(withIdentifier: "showContactProfile", sender: indexPath.row)
        }
        
        
    }
    
    
    
    
    
    // MARK: - Search
    
    func updateSearchResults(for searchController: UISearchController) {
        contactSearcher.params.query = searchController.searchBar.text
        contactSearcher.search()
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    }
    
    // MARK: - Activity indicator
    
    // MARK: - SearchProgressDelegate
    
    func searchDidStart(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func searchDidStop(_ searchProgressController: SearchProgressController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    // Custom Methods
    
    func configureViews(cell: ContactCell){
        // Add radius config & border color
        
        // Add radius config & border color
        cell.cardWrapperView.layer.cornerRadius = 12.0
        cell.cardWrapperView.clipsToBounds = true
        cell.cardWrapperView.layer.borderWidth = 1.5
        cell.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        // Config tool bar
        cell.mediaButtonToolBar.backgroundColor = UIColor.white
        // Set shadow on the container view
        cell.mediaButtonToolBar.layer.shadowColor = UIColor.black.cgColor
        cell.mediaButtonToolBar.layer.shadowOpacity = 1.5
        cell.mediaButtonToolBar.layer.shadowOffset = CGSize.zero
        cell.mediaButtonToolBar.layer.shadowRadius = 2
        
        
    }

    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(ContactsTableViewController.showIntroViewController), name: NSNotification.Name(rawValue: "ContactIntroSelected"), object: nil)
        
    }
    
    func showIntroViewController(){
        
        // Set manager bool to true to signal nav patterns according to user path
        ContactManager.sharedManager.userArrivedFromContactList = true
        
        // Initialize VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IntroVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    // Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        // Prepare info to pass on segue
        
        
        if segue.identifier == "showContactProfile"{
            
            let nextScene =  segue.destination as! ContactProfileViewController
            
            nextScene.active_card_unify_uuid = "\(sender!)" as String?
            
            print(">Passed Contact Card ID")
            print(sender)
            
        }
    }
}



extension UIColor {
    func brightened(by factor: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * factor, alpha: a)
    }
}
