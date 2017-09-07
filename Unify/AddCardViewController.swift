//
//  AddCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 5/31/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class AddCardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    // Properties
    // ----------------------------------------
    
    let reuseIdentifier = "cardViewCell"
    var selectedUserCard = ContactCard()
    
    
    // IBOutlets
    // ----------------------------------------
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var contactPageControl: UIPageControl!

    @IBOutlet var editCardButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var deleteCardButton: UIButton!

    // IBActions
    // ----------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject){
    

        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addNewCard(_ sender: Any) {

        // Show add card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // Configure background image for collectionview
        
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        // Add observers 
        addObservers()
        
        // Set page control count 
        contactPageControl.numberOfPages = ContactManager.sharedManager.currentUserCards.count
            
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide buttons 
        doneButton.isHidden = true
        deleteCardButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // CollectionView DataSource && Delegate
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.cards.count
        if ContactManager.sharedManager.viewableUserCards.count > 0{
            return ContactManager.sharedManager.viewableUserCards.count
        }else{
            emptyMessage(collectionView: self.collectionView)
            return 0
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Set Page Control
        //self.contactPageControl.currentPage = indexPath.row
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        if indexPath.row == ContactManager.sharedManager.viewableUserCards.count{
            
            // AddNewCardCell
            // get a reference to our storyboard cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewCardCell", for: indexPath as IndexPath) as! CardCollectionViewCell
            
            //cell.cardWrapperView.backgroundColor = UIColor.blue
            
        }else{
            // get a reference to our storyboard cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
            
            //cell.backgroundColor = UIColor.clear
            
            // Find current card index
            let currentCard = ContactManager.sharedManager.viewableUserCards[indexPath.row]
            
            if currentCard.isVerified{
                //cell.cardWrapperView.layer.borderWidth = 1.5
                //cell.cardWrapperView.layer.borderColor = UIColor.yellow as! CGColor
            }
            
            // Populate text field data
            
            if currentCard.cardHolderName != nil {
                cell.cardDisplayName.text = currentCard.cardHolderName
            }
            if currentCard.cardProfile.titles.count > 0 {
                cell.cardTitle.text = currentCard.cardProfile.titles[0]["title"]!
            }
            if currentCard.cardProfile.emails.count > 0 {
                cell.cardEmail.text = currentCard.cardProfile.emails[0]["email"]!
            }
            if currentCard.cardProfile.phoneNumbers.count > 0 {
                cell.cardPhone.text = currentCard.cardProfile.phoneNumbers[0]["phone"]!
            }
            if currentCard.cardProfile.images.count > 0{
                // Populate image view
                let imageData = currentCard.cardProfile.images[0]["image_data"]
                cell.cardImage.image = UIImage(data: imageData as! Data)
            }
            if currentCard.cardName != ""{
                cell.cardName.text = currentCard.cardName
            }
            
            
            // Config social link buttons
            // Do that here
            
            // Get badge list
            cell.badgeList = self.parseCardForBagdes(card: currentCard)
            
            // Configure the card view
            configureViews(cell: cell)
        
        }
        
            
            return cell
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.contactPageControl.currentPage = indexPath.row
        
        if indexPath.row == ContactManager.sharedManager.viewableUserCards.count - 1{
            
            /*let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
             containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
             
             // Create section header buttons
             let imageName = "add-card"
             let image = UIImage(named: imageName)
             let imageView = UIImageView(image: image!)
             imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
             
             // Add subviews
             containerView.addSubview(imageView)*/
            
            let containerView = self.createAddNewCell(cell: cell)
            cell.addSubview(containerView)
        }
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if ContactManager.sharedManager.viewableUserCards.count == 0{
            
            // Show add new card
            
            // Show add card vc
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
            self.present(controller, animated: true, completion: nil)
            
        }else{
            
            print("You selected cell #\(indexPath.item)!")
            
            // Set selected card object
            selectedUserCard = ContactManager.sharedManager.viewableUserCards[indexPath.row]
            
            // Show Selected Card segue
            performSegue(withIdentifier: "CardSuiteSelection", sender: self)
        }
        
    }
    

    
    // Custom methods
    // ------------------------------------
    
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.refreshViewableCards), name: NSNotification.Name(rawValue: "RefreshViewable"), object: nil)

        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.refreshCollectionView), name: NSNotification.Name(rawValue: "AddNewCardFinished"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.cardUpdated), name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.cardDeleted), name: NSNotification.Name(rawValue: "CardDeleted"), object: nil)
        
        
        // Nofications for sending card from profile
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.showEmailCard), name: NSNotification.Name(rawValue: "EmailCardFromProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.showSMSCard), name: NSNotification.Name(rawValue: "SMSCardFromProfile"), object: nil)
        
    }
    
    // Selector for observer function
    func refreshViewableCards() {
        
        
        // Remove all from viewable
        ContactManager.sharedManager.viewableUserCards.removeAll()
        
        var viewableIndex = 0
        
        // Viewable cards
        for viewable in 0..<ContactManager.sharedManager.currentUserCards.count - 1{
            
            let viewableCard = ContactManager.sharedManager.currentUserCards[viewableIndex]
            
            print(viewableCard.cardName ?? "")
            print("Hidden = \(viewableCard.isHidden)")
            
            if viewableCard.isHidden != true{
                
                // Add to viewable
                ContactManager.sharedManager.viewableUserCards.append(viewableCard)
                
                
                print("Card To Add To Visbile -> \(viewableCard.cardName ?? "No Name") with count \(ContactManager.sharedManager.viewableUserCards.count)")
                print(viewableCard.cardName ?? "")
                
            }
            
            // Increment index
            viewableIndex = viewableIndex + 1
            
        }
        
        self.collectionView.reloadData()
        
        // Add dummy card back to end
        ContactManager.sharedManager.viewableUserCards.append(ContactCard())
        
        // Sync up with main queue
        DispatchQueue.main.async {
            
            print("Refreshing collectionview")
            // Reload table
            self.collectionView.reloadData()
        }
    }

    
    func cardDeleted() {
        
        DispatchQueue.main.async {
            // Update UI
            //KVNProgress.showSuccess(withStatus: "Card Removed Successfully")
        }
        
        
        print("New Card Added")
        print("\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.collectionView.backgroundView = bgImage
        
        // Refresh table data
        self.collectionView.reloadData()
    }
    
    func cardUpdated() {
        
        DispatchQueue.main.async {
            // Update UI
            //KVNProgress.showSuccess(withStatus: "Card Updated Successfully!")
        }
        
        print("New Card Added")
        print("\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.collectionView.backgroundView = bgImage
        
        // Refresh table data
        self.collectionView.reloadData()
    }
    
    /*func deleteCard() {
        
        // Create params with cardId
        let parameters = ["data": selectedUserCard.cardId]
        
         Connection(configuration: nil).deleteCardCall(parameters){ response, error in
            if error == nil {
            print("Card Created Response ---> \(String(describing: response))")
         
            
         
                // Delete from manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([self.card.toAnyObjectWithImage()], at: 0)
         
                // Set array to defualts
            
                UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
         
                // Hide HUD
            
                KVNProgress.dismiss()
         
                // Post notification for radar view to refresh
                //self.postNotification()
                // Dismiss VC
                self.dismiss(animated: true, completion: {
                // Send to database to update card with the new uuid
            
                print("Deleted to db")
        
            
            })
         
        
            } else {
            print("Card Created Error Response ---> \(error)")
            // Show user popup of error message
            KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }

    }*/
    
    func showEmailCard() {
        // Show VC
        print("EMAIL CARD SELECTED")
        // Set selected card
        ContactManager.sharedManager.selectedCard = ContactManager.sharedManager.currentUserCards[contactPageControl.currentPage]
        
        // Set toggle nav to true
        ContactManager.sharedManager.userEmailCard = true
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    func showSMSCard() {
        // Show VC
        print("EMAIL CARD SELECTED")
        // Set selected card
        ContactManager.sharedManager.selectedCard = ContactManager.sharedManager.currentUserCards[contactPageControl.currentPage]
        
        // Set toggle nav to true
        ContactManager.sharedManager.userSMSCard = true
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    
    func refreshCollectionView() {
        // Reset table background
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.collectionView.backgroundView = bgImage

        
        // reload data 
        self.collectionView.reloadData()
    }
    
    // Handle empty collection view
    func emptyMessage(collectionView:UICollectionView) {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width + 5, height: collectionView.frame.height + 5))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Create section header buttons
        let imageName = "add-card-1"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        
        // Add gesture action
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddCardViewController.addCards))
        
        // 2. add the gesture recognizer to a view
        containerView.addGestureRecognizer(tapGesture)
        
        
        // Add subviews
        containerView.addSubview(imageView)
        collectionView.backgroundView = containerView
        
        
        //collectionView.backgroundView = messageLabel;
    }
    
    func createAddNewCell(cell: UICollectionViewCell) -> UIView{
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        //containerView.layer.borderColor = UIColor.clear as? CGColor
        
        // Create section header buttons
        let imageName = "add-card-1"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        // Add gesture action
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddCardViewController.addCards))
        
        // 2. add the gesture recognizer to a view
        containerView.addGestureRecognizer(tapGesture)
        
        
        // Add subviews
        containerView.addSubview(imageView)
        
        return containerView
    }
    
    // Parse for incons in card profile
    func parseCardForBagdes(card: ContactCard) -> [UIImage] {
        // Execute from manager
        let list = ContactManager.sharedManager.parseContactCardForSocialIcons(card: card)
        print("The Badge List >> \(list)")
        
        return list
    }
    
    // Shows add card vc
    func addCards() {
        // Show alert view with form fields
        print("Add card button works!")
        // Show add new card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    func configureViews(cell: CardCollectionViewCell){
        // Add radius config & border color
        
        
        // Add radius config & border color
        cell.cardWrapperView.layer.cornerRadius = 12.0
        //cell.cardWrapperView.clipsToBounds = true
        cell.cardWrapperView.layer.borderWidth = 1
        cell.cardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Image config
        self.configureSelectedImageView(imageView: cell.cardImage)
        
        // Round edges at top of card cells
        cell.cardHeaderView.layer.cornerRadius = 8.0
        cell.cardHeaderView.clipsToBounds = true
        cell.cardHeaderView.layer.borderWidth = 1
        cell.cardHeaderView.layer.borderColor = UIColor.white.cgColor
        
        // Config shadow
        cell.shadowView.shadowRadius = 2
        cell.shadowView.shadowMask = YIInnerShadowMaskTop
        
        // Assign media buttons
        /*cell.mediaButton1.image = UIImage(named: "social-blank")
        cell.mediaButton2.image = UIImage(named: "social-blank")
        cell.mediaButton3.image = UIImage(named: "social-blank")
        cell.mediaButton4.image = UIImage(named: "social-blank")
        cell.mediaButton5.image = UIImage(named: "social-blank")
        cell.mediaButton6.image = UIImage(named: "social-blank")
        cell.mediaButton7.image = UIImage(named: "social-blank")*/

        // Config tool bar
        /*cell.mediaButtonToolBar.backgroundColor = UIColor.white
         // Set shadow on the container view
         cell.mediaButtonToolBar.layer.shadowColor = UIColor.black.cgColor
         cell.mediaButtonToolBar.layer.shadowOpacity = 1.5
         cell.mediaButtonToolBar.layer.shadowOffset = CGSize.zero
         cell.mediaButtonToolBar.layer.shadowRadius = 2*/
        
        
    }
    
    // When user selects from photoPicker, config image and set to sender view
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1.5
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CardSuiteSelection" {
            
            // Set desination and pass selected card object
            let nextVC = segue.destination as! CardSelectionViewController
            nextVC.selectedCard = self.selectedUserCard
            
        }
        
        
        
        
        
        
        
        
    }
    

}
