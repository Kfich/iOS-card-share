//
//  RadarPullUpCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/2/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import MessageUI


class RadarPullUpCardViewController: UIViewController, ISHPullUpSizingDelegate, ISHPullUpStateDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Properties
    // ---------------------------------------
    var selectedUserCard = ContactCard()
    var currentUser = User()
    var selectedCardIndex = 0
    var transaction = Transaction()
    
    let reuseIdentifier = "cardViewCell"
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    
    // we allow the pullUp to snap to the half way point
    private var halfWayPoint = CGFloat(200)
    
    // IBOutlet
    // ---------------------------------------
    
    @IBOutlet var cardCollectionView: UICollectionView!
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var rootView: UIView!
    
    @IBOutlet var scrollView:UIScrollView!
    
    @IBOutlet var handleView: ISHPullUpHandleView!
    
    @IBOutlet var businessCardView: BusinessCardView!
    
    
    // IBActions / Buttons Pressed
    // ---------------------------------------
    @IBAction private func buttonTappedLearnMore(_ sender: AnyObject) {
        // for demo purposes we replace the bottomViewController with a web view controller
        // there is no way back in the sample app though
        // This also highlights the behaviour of the pullup view controller without a sizing and state delegate
        
        
        //let webVC = WebViewController()
        //webVC.loadURL(URL(string: "https://iosphere.de")!)
        pullUpController.bottomViewController = self
    }
    
    @IBAction private func buttonTappedLock(_ sender: AnyObject) {
        /*pullUpController.isLocked  = !pullUpController.isLocked
         buttonLock?.setTitle(pullUpController.isLocked ? "Unlock" : "Lock", for: .normal)*/
    }

    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure locked
        pullUpController.isLocked = true
        
        
        // Find cards from UserDefaults
        
        /*if let data = UserDefaults.standard.object(forKey: "contact_cards") as? NSData {
            
            
            let cards = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! [ContactCard]
            
            ContactManager.sharedManager.currentUserCards = cards
            for card in ContactManager.sharedManager.currentUserCards{
                card.printCard()
            }
            cardCollectionView.reloadData()
            print("User has cards")
            print(cards)
        }else{
            print("User has no cards")
        }*/
        
        // Clear Cards array 
        //ContactManager.sharedManager.currentUserCardsDictionaryArray.removeAll()
        
        // Parse for social links before fetching cards 
        ContactManager.sharedManager.parseForSocialIcons()
        
        
        if let cards = UDWrapper.getArray("contact_cards"){
            // Assign array to contact manager object

            ContactManager.sharedManager.currentUserCardsDictionaryArray = cards as! [[NSDictionary]]
            // Reload table data
            for card in ContactManager.sharedManager.currentUserCardsDictionaryArray {
                let contactCard = ContactCard(withSnapshotFromDefaults: card[0])
                //let profile = CardProfile(snapshot: card[0]["card_profile"])
                
                //print(profile)
                print("PROFILE PRINTING")
                ContactManager.sharedManager.currentUserCards.append(contactCard)
                //contactCard.printCard()
                
                let list = ContactManager.sharedManager.parseContactCardForSocialIcons(card: contactCard)
                ContactManager.sharedManager.cardBagdeLists["\(contactCard.cardId!)"] = list
                
            }
            
            // Add dummy card to array for 'Add Card' Cell
            let addCardView = ContactCard()
            // Append to current user 
            ContactManager.sharedManager.currentUserCards.append(addCardView)
            // Reload tableview data
            cardCollectionView.reloadData()
            // Set Selected card
            if ContactManager.sharedManager.currentUserCards.count > 0 {
              ContactManager.sharedManager.selectedCard = ContactManager.sharedManager.currentUserCards[0]
            }
            
            print("User has cards!")
            
        }else{
            print("User has no cards")
        }
        
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.cardCollectionView.backgroundView = bgImage
        
        // Add card to whatever the count is 
        //ContactManager.sharedManager.currentUserCards.append(ContactCard())
        
        // Add observers for notifications 
        addObservers()
        
        // Configure page control dots
        // Set page control count
        pageControl.numberOfPages = ContactManager.sharedManager.currentUserCards.count
        
        cardCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: "AddNewCardCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true;
    }
    
    // Custom Methods
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.newCardAdded), name: NSNotification.Name(rawValue: "CardCreated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.cardDeleted), name: NSNotification.Name(rawValue: "CardDeleted"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.cardUpdated), name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.addNewCard), name: NSNotification.Name(rawValue: "CreateCardSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.showEmailCard(_:)), name: NSNotification.Name(rawValue: "EmailCardFromRadar"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.showSMSCard(_:)), name: NSNotification.Name(rawValue: "SMSCardFromRadar"), object: nil)
    }
    
    // Selector for observer function
    func newCardAdded() {
        
        DispatchQueue.main.async {
            // Update UI
            KVNProgress.showSuccess(withStatus: "Card Created Successfully!")
        }
        
        
        print("New Card Added")
        print("\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.cardCollectionView.backgroundView = bgImage
        
        // Refresh table data
        cardCollectionView.reloadData()
    }
    
    func cardDeleted() {
        
        DispatchQueue.main.async {
            // Update UI
            KVNProgress.showSuccess(withStatus: "Card Removed Successfully")
        }
        
        
        print("New Card Added")
        print("\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.cardCollectionView.backgroundView = bgImage
        
        // Refresh table data
        cardCollectionView.reloadData()
    }
    
    func cardUpdated() {
        
        DispatchQueue.main.async {
            // Update UI
            KVNProgress.showSuccess(withStatus: "Card Updated Successfully!")
        }
        
        print("New Card Added")
        print("\(ContactManager.sharedManager.currentUserCards.count)")
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.cardCollectionView.backgroundView = bgImage
        
        // Clear card arrays 
        ContactManager.sharedManager.currentUserCards.removeAll()
        ContactManager.sharedManager.currentUserCardsDictionaryArray.removeAll()
        
        // Get cards again 
        self.parseForCards()
        
        // Refresh table data
        cardCollectionView.reloadData()
    }
    
    // Func to present addCardVC
    func addNewCard() {
        
        // Show add new card vc
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func parseForCards() {
        
        // Parese defaults for stored cards 
        
        if let cards = UDWrapper.getArray("contact_cards"){
            // Assign array to contact manager object
            
            ContactManager.sharedManager.currentUserCardsDictionaryArray = cards as! [[NSDictionary]]
            // Reload table data
            for card in ContactManager.sharedManager.currentUserCardsDictionaryArray {
                let contactCard = ContactCard(withSnapshotFromDefaults: card[0])
                //let profile = CardProfile(snapshot: card[0]["card_profile"])
                
                //print(profile)
                print("PROFILE PRINTING")
                ContactManager.sharedManager.currentUserCards.append(contactCard)
                contactCard.printCard()
            }
            
            // Reload tableview data
            cardCollectionView.reloadData()
            // Set Selected card
            if ContactManager.sharedManager.currentUserCards.count > 0 {
                ContactManager.sharedManager.selectedCard = ContactManager.sharedManager.currentUserCards[0]
            }
            
            print("User has cards!")
            
        }else{
            print("User has no cards")
        }
        
    }
    
    func createTransaction(type: String) {
        // Set type
        transaction.type = type
        // Show progress hud
        KVNProgress.show(withStatus: "Saving your follow up...")
        
        // Save card to DB
        let parameters = ["data": self.transaction.toAnyObject()]
        print(parameters)
        
        // Send to server
        
        Connection(configuration: nil).createTransactionCall(parameters as! [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(response)")
                
                // Set card uuid with response from network
               /* let dictionary : Dictionary = response as! [String : Any]
                self.transaction.transactionId = (dictionary["uuid"] as? String)!*/
                
                // Insert to manager card array
                //ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([card.toAnyObjectWithImage()], at: 0)
                
                // Hide HUD
                KVNProgress.dismiss()
                
            } else {
                print("Card Created Error Response ---> \(error)")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error with your follow up. Please try again.")
                
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
    }
    
    func fetchUserCards() {
        // Set current user 
        self.currentUser = ContactManager.sharedManager.currentUser
        
        // Fetch cards from server
        let parameters = ["uuid" : currentUser.userId]
        
        print("\n\nTHE CARD TO ANY - PARAMS")
        print(parameters)
        
        // Store current user cards to local device
        //let encodedData = NSKeyedArchiver.archivedData(withRootObject: ContactManager.sharedManager.currentUserCards)
        //UDWrapper.setData("contact_cards", value: encodedData)
        
        
        // Show progress hud
        //KVNProgress.show(withStatus: "Saving your new card...")
        
        // Save card to DB
        //let parameters = ["data": card.toAnyObject()]
        
        Connection(configuration: nil).getCardsCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Fetch Card Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : NSArray = response as! NSArray
                print("\n\nCard List")
                print(dictionary)
                
                
                
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error retrieving your cards. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        
    }
    
    
    // Tap Gesture Handler
    
    private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        if pullUpController.isLocked {
            return
        }
        
        pullUpController.toggleState(animated: true)
    }
    
    // CollectionView DataSource && Delegate
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    //
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.cards.count
        if ContactManager.sharedManager.currentUserCards.count > 0{
            return ContactManager.sharedManager.currentUserCards.count
        }else{
            emptyMessage(collectionView: cardCollectionView)
            return 0
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Set Page Control 
        self.pageControl.currentPage = indexPath.row
        
        
        // get a reference to our storyboard cell
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
    
        
        if indexPath.row == ContactManager.sharedManager.currentUserCards.count{
            
           // AddNewCardCell
            // get a reference to our storyboard cell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAddNewCardCell", for: indexPath as IndexPath) as! CardCollectionViewCell
            
            //cell.cardWrapperView.backgroundColor = UIColor.blue
        
        }else{
            
            // Find current card index
            let currentCard = ContactManager.sharedManager.currentUserCards[indexPath.row]
            
            // Get badge list
            cell.badgeList = self.parseCardForBagdes(card: currentCard)
            
            // Populate text field data
            
            if currentCard.cardHolderName != nil {
                cell.cardDisplayName.text = currentCard.cardHolderName
            }
            if currentCard.cardProfile.titles.count > 0 {
                cell.cardTitle.text = currentCard.cardProfile.titles[0]["title"]
            }
            if currentCard.cardProfile.emails.count > 0 {
                cell.cardEmail.text = currentCard.cardProfile.emails[0]["email"]!
            }
            if currentCard.cardProfile.phoneNumbers.count > 0 {
                cell.cardPhone.text = currentCard.cardProfile.phoneNumbers[0]["phone"]!
            }
            if currentCard.cardProfile.images.count > 0 {
                // Populate image view
                let imageData = currentCard.cardProfile.images[0]["image_data"]
                cell.cardImage.image = UIImage(data: imageData as! Data)
            }
            if currentCard.cardName != nil{
                cell.cardName.text = currentCard.cardName
            }
            
            // Configure the card view
            configureViews(cell: cell)

        }

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Set index
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.pageControl.currentPage = indexPath.row
        
        if indexPath.row == ContactManager.sharedManager.currentUserCards.count - 1{
            
            /*let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
            
            // Create section header buttons
            let imageName = "add-card"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            
            // Add subviews
            containerView.addSubview(imageView)*/
            
            //let containerView = self.createAddNewCell(cell: cell)
            //cell.addSubview(containerView)
        }
        
    }
    // center content 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(ContactManager.sharedManager.currentUserCards.count)
        
        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            
            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsetsMake(0, 40, 0, 40)
            }
        }
        
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let thisWidth = CGFloat(self.view.frame.width)
        return CGSize(width: thisWidth, height: 240)
    }
    
    
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if ContactManager.sharedManager.currentUserCards.count == 0{
            
            // Show add new card
            
            // Show add card vc
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CreateCardVC")
            self.present(controller, animated: true, completion: nil)
            
        }else{
            
            print("You selected cell #\(indexPath.item)!")
            
            // Set selected card object
            selectedUserCard = ContactManager.sharedManager.currentUserCards[indexPath.row]
            
            // Show Selected Card segue
            performSegue(withIdentifier: "showSelectedCard", sender: self)
        }
        
    }
    
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        
        let totalCellWidth = CellWidth * CellCount
        let totalSpacingWidth = CellSpacing * (CellCount - 1)
        
        let leftInset = (collectionViewWidth - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        
        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
    }*/

    
    
    
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        //let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        // we allow the pullUp to snap to the half way point
        // we "calculate" the cached value here
        // and perform the snapping in ..targetHeightForBottomViewController..
        //halfWayPoint = totalHeight / 2.0
        return 260
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
         /*topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height;*/
        return 260
        
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        // if around 30pt of the half way point -> snap to it
        if abs(height - halfWayPoint) < 100 {
            return halfWayPoint
        }
        
        // default behaviour
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
        // we update the scroll view's content inset
        // to properly support scrolling in the intermediate states
        scrollView.contentInset = edgeInsets;
    }
    
    // Custom Methods
    
    func parseCardForBagdes(card: ContactCard) -> [UIImage] {
        // Execute from manager
        let list = ContactManager.sharedManager.parseContactCardForSocialIcons(card: card)
        print("The Badge List >> \(list)")
        
        return list
    }
    
    func createAddNewCell(cell: UICollectionViewCell) -> UIView{
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        //containerView.layer.borderColor = UIColor.clear as? CGColor
        
        // Create section header buttons
        let imageName = "add-card"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        
        // Add gesture action
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RadarPullUpCardViewController.addNewCard))
        
        // 2. add the gesture recognizer to a view
        containerView.addGestureRecognizer(tapGesture)
        
        // Add subviews
        containerView.addSubview(imageView)

        return containerView
    }
    
    
    
    // Handle empty collection view 
    func emptyMessage(collectionView:UICollectionView) {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width + 5, height: collectionView.frame.height + 5))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        
        // Create section header buttons
        let imageName = "add-card"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height)
        
        // Add gesture action
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RadarPullUpCardViewController.addNewCard))
        
        // 2. add the gesture recognizer to a view
        containerView.addGestureRecognizer(tapGesture)
        
        
        // Add subviews
        containerView.addSubview(imageView)
        collectionView.backgroundView = containerView
        
        
        //collectionView.backgroundView = messageLabel;
    }

    
    
    func configureViews(cell: CardCollectionViewCell){
        // Add radius config & border color
        
        // Add radius config & border color
        cell.cardWrapperView.layer.cornerRadius = 12.0
        cell.cardWrapperView.clipsToBounds = true
        cell.cardWrapperView.layer.borderWidth = 1.5
        cell.cardWrapperView.layer.borderColor = UIColor.clear.cgColor
        // Make card wrapper full cell size
        //cell.backgroundColor = UIColor.white
        
        // Config imageview
        self.configureSelectedImageView(imageView: cell.cardImage)
        
        // Round edges at top of card cells
        cell.cardHeaderView.layer.cornerRadius = 8.0
        cell.cardHeaderView.clipsToBounds = true
        cell.cardHeaderView.layer.borderWidth = 1.5
        cell.cardHeaderView.layer.borderColor = UIColor.white.cgColor
        
        
        cell.cardWrapperView.backgroundColor = UIColor.blue
        
       /* // Assign media buttons
        cell.mediaButton1.image = UIImage(named: "social-blank")
        cell.mediaButton2.image = UIImage(named: "social-blank")
        cell.mediaButton3.image = UIImage(named: "social-blank")
        cell.mediaButton4.image = UIImage(named: "social-blank")
        cell.mediaButton5.image = UIImage(named: "social-blank")
        cell.mediaButton6.image = UIImage(named: "social-blank")
        cell.mediaButton7.image = UIImage(named: "social-blank")*/
        
    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45// Create container for image and name
        
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        //topLabel.text = textForState(state);
        //handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
    }
    
    private func textForState(_ state: ISHPullUpState) -> String {
        switch state {
        case .collapsed:
            return "Drag up or tap"
        case .intermediate:
            return "Intermediate"
        case .dragging:
            return "Hold on"
        case .expanded:
            return "Drag down or tap"
        }
    }
    
    
    // MARK - Navigation 
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find id 
        
        if segue.identifier ==  "showSelectedCard"{
            // Init destination VC
            let destination = segue.destination as! CardSelectionViewController
            // Set selected card
            destination.selectedCard = selectedUserCard
            print("Segue performed to show selected card")
        }
    }
    
    // Message Composer Delegate
    
    func showEmailCard(_ sender: Any) {
        
        print("EMAIL CARD SELECTED")
        // Set selected card
        ContactManager.sharedManager.selectedCard = ContactManager.sharedManager.currentUserCards[pageControl.currentPage]
        
        // Set toggle nav to true
        ContactManager.sharedManager.userEmailCard = true
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func showSMSCard(_ sender: Any) {
        // Set selected card
        ContactManager.sharedManager.selectedCard = ContactManager.sharedManager.currentUserCards[pageControl.currentPage]
        
        // Set toggle nav to true
        ContactManager.sharedManager.userSMSCard = true
        
        // Call the viewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "QuickShareVC")
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
}





