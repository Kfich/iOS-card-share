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


    // IBActions
    // ----------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject){
    

        dismiss(animated: true, completion: nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // CollectionView DataSource && Delegate
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.cards.count
        if ContactManager.sharedManager.currentUserCards.count > 0{
            return ContactManager.sharedManager.currentUserCards.count
        }else{
            emptyMessage(collectionView: self.collectionView)
            return 0
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Set Page Control
        //self.contactPageControl.currentPage = indexPath.row
        
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        //cell.backgroundColor = UIColor.clear
        
        
        if indexPath.row == ContactManager.sharedManager.currentUserCards.count{
            
            // Add card to whatever the count is
            ContactManager.sharedManager.currentUserCards.append(ContactCard())
            
            collectionView.cellForItem(at: indexPath)?.backgroundView = createAddNewCell()
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
            
            // Create section header buttons
            let imageName = "add-card"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            
            // Add subviews
            containerView.addSubview(imageView)
            
            return cell
        }else{
            
            // Find current card index
            let currentCard = ContactManager.sharedManager.currentUserCards[indexPath.row]
            
            // Populate text field data
            
            if currentCard.cardHolderName != nil {
                cell.cardDisplayName.text = currentCard.cardHolderName
            }
            if currentCard.cardProfile.title != nil {
                cell.cardTitle.text = currentCard.cardProfile.getTitle()
            }
            if currentCard.cardProfile.emails[0]["email"] != nil {
                cell.cardEmail.text = currentCard.cardProfile.emails[0]["email"]
            }
            if currentCard.cardProfile.phoneNumbers[0]["phone"] != nil {
                cell.cardEmail.text = currentCard.cardProfile.emails[0]["email"]
            }
            if let imageData = currentCard.cardProfile.images[0]["image_data"] {
                // Populate image view
                cell.cardImage.image = UIImage(data: imageData as! Data)
            }
            if currentCard.cardName != nil{
                cell.cardName.text = currentCard.cardName
            }
            
            
            // Config social link buttons
            // Do that here
            
            
            // Configure the card view
            configureViews(cell: cell)
            
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.contactPageControl.currentPage = indexPath.row
        
        if ContactManager.sharedManager.currentUserCards.count == 0{
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
            
            // Create section header buttons
            let imageName = "add-card"
            let image = UIImage(named: imageName)
            let imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            
            // Add subviews
            containerView.addSubview(imageView)
            
            cell.addSubview(containerView)
        }
        
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

    
    // Custom methods
    // ------------------------------------
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(AddCardViewController.refreshCollectionView), name: NSNotification.Name(rawValue: "AddNewCardFinished"), object: nil)
        
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
        let imageName = "add-card"
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
    
    func createAddNewCell() -> UIView{
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.collectionView.frame.width + 5, height: self.collectionView.frame.height + 5))
        containerView.backgroundColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        //containerView.layer.borderColor = UIColor.clear as? CGColor
        
        // Create section header buttons
        let imageName = "add-card"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        
        // Add gesture action
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddCardViewController.addCards))
        
        // 2. add the gesture recognizer to a view
        containerView.addGestureRecognizer(tapGesture)
        
        
        // Add subviews
        containerView.addSubview(imageView)
        
        return containerView
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CardSuiteSelection" {
            
            // Set desination and pass selected card object
            
        }
        
        
        
        
        
        
        
        
    }
    

}
