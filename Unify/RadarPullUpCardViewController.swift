//
//  RadarPullUpCardViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/2/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit


class RadarPullUpCardViewController: UIViewController, ISHPullUpSizingDelegate, ISHPullUpStateDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // Properties
    // ---------------------------------------
    var selectedUserCard = ContactCard()
    
    
    let reuseIdentifier = "cardViewCell"
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!
    
    // we allow the pullUp to snap to the half way point
    private var halfWayPoint = CGFloat(200)
    
    // IBOutlet
    // ---------------------------------------
    
    @IBOutlet var cardCollectionView: UICollectionView!
    
    
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
        
        // Set background image on collectionview
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "backgroundGradient");
        bgImage.contentMode = .scaleToFill
        self.cardCollectionView.backgroundView = bgImage
        
        
        // Add observers for notifications 
        addObservers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true;
    }
    
    // Custom Methods
    // For sending notifications to the default center for other VC's that are listening
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(RadarPullUpCardViewController.newCardAdded), name: NSNotification.Name(rawValue: "CardCreated"), object: nil)
    }
    
    // Selector for observer function
    func newCardAdded() {
        
        print("New Card Added")
        print("\(ContactManager.sharedManager.currentUserCards.count)")
        // Refresh table data
        cardCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.cards.count
        return ContactManager.sharedManager.currentUserCards.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        //cell.backgroundColor = UIColor.clear
        
        
        /*if currentUserCards.count == 0{
            let addNew = UIImage(named: "add-card")
            
        }*/
        // Find current card index
        let currentCard = ContactManager.sharedManager.currentUserCards[indexPath.row]
        
        
        
        // Populate text field data
        cell.cardDisplayName.text = currentCard.cardHolderName
        cell.cardTitle.text = currentCard.cardProfile.getTitle()
        cell.cardEmail.text = currentCard.cardProfile.emails[0]["email"]
        cell.cardPhone.text = currentCard.cardProfile.phoneNumbers[0]["phone"]
        
        // Populate image view
        let imageData = currentCard.cardProfile.images[0]["image_data"]
        cell.cardImage.image = UIImage(data: imageData as! Data)
        
        // Config social link buttons
        // Do that here
        
        
        // Configure the card view
        configureViews(cell: cell)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        // Set selected card object 
        selectedUserCard = ContactManager.sharedManager.currentUserCards[indexPath.row]
        
        // Show Selected Card segue
        performSegue(withIdentifier: "showSelectedCard", sender: self)
    }

    
    
    
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        //let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
        // we allow the pullUp to snap to the half way point
        // we "calculate" the cached value here
        // and perform the snapping in ..targetHeightForBottomViewController..
        //halfWayPoint = totalHeight / 2.0
        return 225
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
         /*topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height;*/
        return 225
        
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
    
    func configureViews(cell: CardCollectionViewCell){
        // Add radius config & border color
        
        // Add radius config & border color
        cell.cardWrapperView.layer.cornerRadius = 12.0
        cell.cardWrapperView.clipsToBounds = true
        cell.cardWrapperView.layer.borderWidth = 1.5
        cell.cardWrapperView.layer.borderColor = UIColor.white.cgColor
        
        cell.mediaButton1.image = UIImage(named: "social-blank")
        cell.mediaButton2.image = UIImage(named: "social-blank")
        cell.mediaButton3.image = UIImage(named: "social-blank")
        cell.mediaButton4.image = UIImage(named: "social-blank")
        cell.mediaButton5.image = UIImage(named: "social-blank")
        cell.mediaButton6.image = UIImage(named: "social-blank")
        cell.mediaButton7.image = UIImage(named: "social-blank")
        
        // Config tool bar
        /*cell.mediaButtonToolBar.backgroundColor = UIColor.white
         // Set shadow on the container view
         cell.mediaButtonToolBar.layer.shadowColor = UIColor.black.cgColor
         cell.mediaButtonToolBar.layer.shadowOpacity = 1.5
         cell.mediaButtonToolBar.layer.shadowOffset = CGSize.zero
         cell.mediaButtonToolBar.layer.shadowRadius = 2*/
        
        
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
    
    
}






