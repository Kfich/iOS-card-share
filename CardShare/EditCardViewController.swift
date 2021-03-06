//
//  EditCardViewController.swift
//  Unify
//


import UIKit
import MBPhotoPicker
import Alamofire

class EditCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, RSKImageCropViewControllerDelegate {
    
    // Properties
    // ----------------------------
    var card = ContactCard()
    var currentUser = User()
    
    var selectedCells = [NSIndexPath]()
    
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var phoneNumberLabels = [String]()
    var emails = [String]()
    var emailLabels = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    var addresses = [String]()
    var addressLabels = [String]()
    var addressObjects = [NSDictionary]()
    var corpBadges : [CardProfile.Bagde] = []

    // Profile pics
    var profileImagelist = [UIImage]()
    
    // Selected Items 
    var selectedBios = [String]()
    var selectedWorkInformation = [String]()
    var selectedOrganizations = [String]()
    var selectedTitles = [String]()
    var selectedPhoneNumbers = [String]()
    var selectedEmails = [String]()
    var selectedWebsites = [String]()
    var selectedSocialLinks = [String]()
    var selectedNotes = [String]()
    var selectedTags = [String]()
    var selectedAddress = [String]()
    var selectedAddressObjects = [NSDictionary]()
    var selectedCorpBadges: [CardProfile.Bagde] = []
    var selectedCorpLinks = [String]()
    
    // Store image icons
    var socialLinkBadges = [[String : Any]]()
    var links = [String]()
    var socialBadges = [UIImage]()
    var userDidEditProfile = false
    
    var sections = [String]()
    var tableData = [String: [String]]()
    
    var isSimulator = false
    
    // Photo picker variable
    var photoPicker = MBPhotoPicker()
    
    // Struct to check if user selected for radar
    struct Check {
        var index: Int
        var isSelected: Bool // selection state
        
        init(arrayIndex: Int, selected: Bool) {
            index = arrayIndex
            isSelected = selected
        }
    }
    
    var selectedSocialLinkList = [Check]()
    
    var selectedCorpBadgeList = [Check]()
    
    // IBOutlets
    // ----------------------------
    @IBOutlet var cardOptionsTableView: UITableView!
    
    @IBOutlet var profileCardWrapperView: UIView!
    @IBOutlet var profileCardWrapperViewSingle: UIView!
    @IBOutlet var profileCardWrapperViewEmpty: UIView!
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var socialMediaToolBar: UIToolbar!
    
    
    @IBOutlet var cardNameButton: UIButton!
    @IBOutlet var cardNameButtonSingleWrapper: UIButton!
    @IBOutlet var cardNameButtonEmptyWrapper: UIButton!
    // Action buttons
    
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var deleteCardButton: UIButton!
    @IBOutlet var addImageButtonSingleWrapper: UIButton!
    @IBOutlet var deleteCardButtonSingleWrapper: UIButton!
    @IBOutlet var addImageButtonEmptyWrapper: UIButton!
    @IBOutlet var deleteCardButtonEmptyWrapper: UIButton!
    
    // Badge carosel
    @IBOutlet var singleCollectionView: UICollectionView!
    @IBOutlet var socialBadgeCollectionView: UICollectionView!
    @IBOutlet var badgeCollectionView: UICollectionView!
    @IBOutlet var profileImageCollectionView: UICollectionView!
    @IBOutlet var shadowView: YIInnerShadowView!
    @IBOutlet var pencilIcon: UIImageView!
    @IBOutlet var pencilIconSingleWrapper: UIImageView!
    @IBOutlet var pencilIconEmptyWrapper: UIImageView!
    
    
    // Card info outlets for single
    @IBOutlet var nameLabelSingleWrapper: UILabel!
    @IBOutlet var titleLabelSingleWrapper: UILabel!
    @IBOutlet var emailLabelSingleWrapper: UILabel!
    @IBOutlet var numberLabelSingleWrapper: UILabel!
    @IBOutlet var profileImageViewSingleWrapper: UIImageView!
    @IBOutlet var cardNameLabelSingleWrapper: UILabel!
    
    // Labels for empty wrapper
    @IBOutlet var nameLabelEmptyWrapper: UILabel!
    @IBOutlet var titleLabelEmptyWrapper: UILabel!
    @IBOutlet var emailLabelEmptyWrapper: UILabel!
    @IBOutlet var numberLabelEmptyWrapper: UILabel!
    @IBOutlet var profileImageViewEmptyWrapper: UIImageView!
    @IBOutlet var cardNameLabelEmptyWrapper: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Set current user 
        currentUser = ContactManager.sharedManager.currentUser
        // Set Selected card
        card = ContactManager.sharedManager.selectedCard
        
        // Parse bio info
        self.parseDataFromProfile()
        
        // Parse card for profile info
        self.parseCardForSelections()
        
        // Add dummy badge to list
        let badge = CardProfile.Bagde()
        ContactManager.sharedManager.currentUser.userProfile.badgeList.append(badge)
        
        // Populate the card 
        self.populateCards()
        

        
        // View config
        configureViews()
        
        
        // Photo picker config
        configurePhotoPicker()
        
        
        // Get images
        self.parseAccountForImages()
        
        //self.profileInfoTableView.tableHeaderView = profileImageCollectionView
        
        //let container = UIView(frame: CGRect(x: 0, y: 0, width: self.cardOptionsTableView.frame.width, height: 3))
        //container.backgroundColor = UIColor.gray
        //container.addSubview(self.profileImageCollectionView)
        
        
        
        self.cardOptionsTableView.tableFooterView = self.profileImageCollectionView
        
        // Set shadow 
        //self.shadowView.shadowRadius = 3
        //self.shadowView.shadowMask = YIInnerShadowMaskTop
        
        // Do any additional setup after loading the view.
        
        
        // Parse the users profile for info
        /*
         emails = ["example@gmail.com", "test@aol.com", "sample@gmail.com" ]
         phoneNumbers = ["1234567890", "6463597308", "3036558888"]
         socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
         organizations = ["crane.ai", "Example Inc", "Sample LLC", "Boys and Girls Club"]
         bios = ["Created a company for doing blank for example usecase", "Full Stack Engineer at Crane.ai", "College Professor at the University of Application Building"]
         websites = ["example.co", "sample.ai", "excuse.me"]
         titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
         workInformation = ["Job 1", "Job 2", "Example Job", "Sample Job"]
         */
        
        // Set button 
        self.cardNameButton.setTitle(card.cardName ?? "", for: .normal)
        self.cardNameButtonSingleWrapper.setTitle(card.cardName ?? "", for: .normal)
        self.cardNameButtonEmptyWrapper.setTitle(card.cardName ?? "", for: .normal)
        
        // Add gesture tp pencil icon 
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        self.pencilIcon.isUserInteractionEnabled = true
        self.pencilIcon.addGestureRecognizer(tapGestureRecognizer)
        self.pencilIconSingleWrapper.isUserInteractionEnabled = true
        self.pencilIconSingleWrapper.addGestureRecognizer(tapGestureRecognizer)
        self.pencilIconEmptyWrapper.isUserInteractionEnabled = true
        self.pencilIconEmptyWrapper.addGestureRecognizer(tapGestureRecognizer)
        
        // If user only has one card, hide button
        if ContactManager.sharedManager.viewableUserCards.count == 2{
            // Hide
            self.deleteCardButton.isHidden = true
            ///self.deleteCardButtonSingleWrapper.isHidden = true
            //self.deleteCardButtonEmptyWrapper.isHidden = true
        }else{
            // Show
            self.deleteCardButton.isHidden = false
            //self.deleteCardButtonSingleWrapper.isHidden = false
            //self.deleteCardButtonEmptyWrapper.isHidden = false
        }
        
        
        // Config header view based on counts
        if self.currentUser.userProfile.socialLinks.count > 0 && ContactManager.sharedManager.badgeList.count > 0{
            print("The contact has both social and corp badges")
            // Set double collection wrapper as header
            cardOptionsTableView.tableHeaderView = self.profileCardWrapperView
            
        }else if (self.currentUser.userProfile.socialLinks.count > 0 && self.currentUser.userProfile.badgeDictionaryList.count == 0) || (self.currentUser.userProfile.socialLinks.count == 0 && self.currentUser.userProfile.badgeDictionaryList.count > 0){
            print("The contact has one list populated")
            // Set single collection wrapper as header
            cardOptionsTableView.tableHeaderView = self.profileCardWrapperViewSingle
            
        }else{
            print("The contact has neither list populated")
            // Set empty collection wrapper as header
            cardOptionsTableView.tableHeaderView = self.profileCardWrapperViewEmpty
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        if self.userDidEditProfile{
            print("Already removed")
        }else{
            // Remove dummy badge
            ContactManager.sharedManager.currentUser.userProfile.badgeList.removeLast()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    // --------------------------------------------
    
    @IBAction func cancelCardCreation(_ sender: Any) {
        // Drop modal view
        dismiss(animated: true, completion: nil)
    }
    
    
    // Adding prof pic
    
    @IBAction func selectProfileImage(_ sender: Any) {
        
        
        photoPicker.onPhoto = { (image: UIImage?) -> Void in
            print("Selected image")
            
            // Change button text
            self.addImageButton.titleLabel?.text = "Change Image"
            
            // Set image to view
            self.profileImageView.image = image
            
            // Pull image data
            /*
             let imageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.75)
             // Test image data
             print(imageData!)*/
            
            // Previous place for image handling and assingment
            
            //global_image = image
            //self.addProfilePictureBtn.setImage(image, for: UIControlState.normal)
        }
        
        photoPicker.onCancel = {
            print("Cancel Pressed")
        }
        photoPicker.onError = { (error) -> Void in
            print("Photo selection Error")
            print("Error: \(error.rawValue)")
        }
        
        photoPicker.present(self)
        
    }
    
    
    @IBAction func addCardName(_ sender: Any) {
        // Call custom func
        
        showAlertWithTextField(description: "Add Card Name", placeholder: "Enter Name", actionType: "Add Name")
    }
    
    @IBAction func addTags(_ sender: Any) {
        // Call custom func w parameters
        showAlertWithTextField(description: "Add Hashtags to Card", placeholder: "#hastag", actionType: "Add Tag")
    }
    
    @IBAction func addNotes(_ sender: Any) {
        // Call custom func w parameters
        showAlertWithTextField(description: "Add Card Notes", placeholder: "Enter Note", actionType: "Add Note")
    }
    
    
    
    // Sending card to server
    @IBAction func doneCreatingCard(_ sender: Any) {
        
        // Toggle bool 
        self.userDidEditProfile = true
        
        // Remove dummy badge
        ContactManager.sharedManager.currentUser.userProfile.badgeList.removeLast()
        
        // Assign image for card
        // Image data png
        let imageData = UIImagePNGRepresentation(self.profileImageView.image!)
        print(imageData!)
        
        let idString = currentUser.randomString(length: 20)
        
        // Assign asset name and type
        let fname = idString
        let mimetype = "image/png"
        
        // Create image dictionary
        let imageDict = ["image_id":idString, "image_data": imageData!, "file_name": idString, "type": mimetype] as [String : Any]
        
        
        // Overwrite index
        //self.card.cardProfile.images[0] = imageDict
        
        
        if self.card.cardProfile.images.count > 0 {
            // Overwrite index
            self.card.cardProfile.images[0] = imageDict
            print("Index Overridden ", self.card.cardProfile.images[0])
        }else{
            
            // Add image to contact card profile images
            self.card.cardProfile.images.append(imageDict)
            print("Index appended ", self.card.cardProfile.images)
           // print(imageDict)
        }
        
        // Init imageURLS
        let urls = ImageURLS()
        
        // Create URL For Prod
        //let prodURL = urls.uploadToStagingURL
        
        // Create URL For Test
        let testURL = urls.uploadToDevelopmentURL
        
        
        // Upload image with Alamo
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData!, withName: "files", fileName: "\(fname).jpg", mimeType: "image/jpg")
            
            print("Multipart Data >>> \(multipartFormData)")
            /*for (key, value) in parameters {
             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }*/
            
            // Currently Set to point to Prod Server
        }, to:testURL)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print("\n\n\n\n successfully uploaded the image...")
                    print(response.result.value ?? "Successful upload")
                    
                    // Dismiss hud
                    //KVNProgress.dismiss()
                }
                
            case .failure(let encodingError):
                print("\n\n\n\n error....")
                print(encodingError)
                // Show error message
                KVNProgress.showError(withStatus: "There was an error generating your profile. Please try again.")
            }
        }

        
        // Clear arrays for badges
        self.card.cardProfile.badgeDictionaryList.removeAll()
        self.card.cardProfile.socialLinks.removeAll()
        
        
        // Counter to iterate
        var index = 0
        // Iterate over list and append selected badges
        for item in self.selectedCorpBadgeList {
            // Check if selected
            if item.isSelected {
                // Append to card badge list
                self.card.cardProfile.badgeDictionaryList.append(self.corpBadges[index].toAnyObject())
                print("Badge Added :: > :: \(self.corpBadges[index].toAnyObject())")
            }
            // Incremement index
            index = index + 1
        }
        
        
        // Counter to iterate
        var socialIndex = 0
        // Iterate over list and append selected badges
        for item in self.selectedSocialLinkList {
            // Check if selected
            if item.isSelected {
                // Append to card badge list
                self.card.cardProfile.socialLinks.append(["link": self.socialLinks[socialIndex]])
                print("Social Added :: > :: \(self.socialLinks[socialIndex])")
            }
            // Incremement index
            socialIndex = socialIndex + 1
        }

        
        
        // Set user name to card
        card.cardHolderName = currentUser.fullName
        // Assign card image id
        card.cardProfile.imageIds[0] = ["card_image_id": idString]
        
        print("Card ID List", card.cardProfile.imageIds[0])
        
        // Set ownerid on card
        card.ownerId = currentUser.userId
        
        // Print card to see if generated
        card.printCard()
        //card.cardProfile.printProfle()
        
        // Overwrite card to current user object card suite
        
        // Remove original from array
        ContactManager.sharedManager.deleteCardFromArray(cardIdString: self.card.cardId!)
        
        // Insert to manager card array
        ContactManager.sharedManager.currentUserCardsDictionaryArray.insert([self.card.toAnyObjectWithImage()], at: 0)
        
        // Set array to defualts
        UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
        
        // Send to server
        let parameters = ["data" : card.toAnyObject(), "uuid" : card.cardId] as [String : Any]
         print("\n\nTHE CARD TO ANY - PARAMS")
         print(parameters)
        
        // Connection to DB
        Connection(configuration: nil).updateCardCall(parameters as [AnyHashable : Any]){ response, error in
            if error == nil {
                print("Card Created Response ---> \(String(describing: response))")
                
                // Set card uuid with response from network
                let dictionary : Dictionary = response as! [String : Any]
                self.card.cardId = dictionary["uuid"] as? String
                
                // Overwrite original card
                
                
                // Set array to defualts
                //UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
                
                // Hide HUD
                KVNProgress.dismiss()
                
                // Post notification for radar view to refresh
                self.postDeleteNotification()
                
            } else {
                print("Card Created Error Response ---> \(String(describing: error))")
                // Show user popup of error message
                KVNProgress.showError(withStatus: "There was an error creating your card. Please try again.")
            }
            // Hide indicator
            KVNProgress.dismiss()
        }
        // Dismiss VC
        self.dismiss(animated: true, completion: {
            // Send to database to update card with the new uuid
            print("Send to db from done call")
            
        })
        
    }
    
    @IBAction func deleteCard(_ sender: Any) {
        
        if ContactManager.sharedManager.viewableUserCards.count == 1 {
            // Show alert
            // Configure alertview
            let alertView = UIAlertController(title: "", message: "You must have at least one card", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Ok", style: .default, handler: { (alert) in
                
                // Dismiss alert
                self.dismiss(animated: true, completion: nil)
                
            })
            // Add actions
            alertView.addAction(cancel)

            // Present controller
            self.present(alertView, animated: true, completion: nil)
        }else{
            
            // Configure alertview
            let alertView = UIAlertController(title: "Are you sure you want to delete this card?", message: "You are about to delete this card.", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in
                
                // Dismiss alert
                self.dismiss(animated: true, completion: nil)
                
            })
            
            let ok = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
                
                // Delete card from local storage
                ContactManager.sharedManager.deleteCardFromArray(cardIdString: self.card.cardId!)
                
                // Set array to defualts
                UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
                
                // Delete card
                
                // Send to server
                let parameters = ["uuid" : self.card.cardId]
                print("\n\nTHE CARD TO ANY - PARAMS")
                print(parameters)
                
                // Show alert
                KVNProgress.show(withStatus: "Deleting current card ...")
                
                // Connect to server
                Connection(configuration: nil).deleteCardCall(parameters){ response, error in
                    if error == nil {
                        print("Card Created Response ---> \(String(describing: response))")
                        
                        // Set card uuid with response from network
                        let dictionary : Dictionary = response as! [String : Any]
                        print(dictionary)
                        
                        // Remove from manager card array
                        //ContactManager.sharedManager.deleteCardFromArray(cardIdString: self.card.cardId!)
                        
                        // Reset array to defualts
                        //UDWrapper.setArray("contact_cards", value: ContactManager.sharedManager.currentUserCardsDictionaryArray as NSArray)
                        
                        // Hide HUD
                        KVNProgress.dismiss()
                        
                        // Post notification for radar view to refresh
                        self.postDeleteNotification()
                        // Dismiss VC
                        /*self.dismiss(animated: true, completion: {
                         // Send to database to update card with the new uuid
                         print("Send to db")
                         })*/
                        
                    } else {
                        print("Card Created Error Response ---> \(String(describing: error))")
                        // Show user popup of error message
                        KVNProgress.showError(withStatus: "There was an error deleting your card. Please try again.")
                    }
                    // Hide indicator
                    KVNProgress.dismiss()
                }
                // Dismiss VC
                self.dismiss(animated: true, completion: {
                    // Send to database to update card with the new uuid
                    print("Send to db")
                })
                
                
            })
            
            // Add actions 
            alertView.addAction(cancel)
            alertView.addAction(ok)
            // Show Alert
            self.present(alertView, animated: true, completion: nil)
            
        }
        

    }
    
    func configureSelectedImageView(imageView: UIImageView) {
        // Config imageview
        
        // Configure borders
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 45    // Create container for image and name
        
    }
    
    // RSKImageCropperDelegate Methods
    
    // When user selects from photoPicker, config image and set to sender view
    func configureSelectedImageView(selectedImage: UIImage) -> UIImageView{
        // Config imageview
        
        // Set image to imageview
        let imageView = UIImageView(image: selectedImage)
        
        // Configure borders
        //imageView.layer.borderColor = UIColor.red.cgColor
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 59    // Create container for image and name
        
        // Changed the image rendering size
        imageView.frame = CGRect(x: 10, y: 0 , width: 125, height: 125)
        
        return imageView
    }
    
    // Image Cropper Delegates
    
    func showCropper(withImage: UIImage) {
        // Show image cropper
        let cropper = RSKImageCropViewController()
        // Set Cropper Image
        cropper.originalImage = withImage
        // Set mode
        cropper.cropMode = RSKImageCropMode.circle
        // Set Delegate
        cropper.delegate = self
        
        self.present(cropper, animated: true, completion: nil)
    }
    
    /*
     func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
     // Configure custom rect
     var size = CGSize()
     // Set size
     size.height = 150
     size.width = 150
     
     // Config view size
     let viewWidth = self.view.frame.width
     let viewHeight = self.view.frame.height
     
     // Make rect
     let rect = CGRect(x: (viewWidth - size.width) * 0.5, y: (viewHeight - size.height) * 0.5, width: size.width, height: size.height)
     
     return rect
     
     }*/
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        // Drop vc
        self.dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        // Set image to view
       // self.profileImageView.image = croppedImage
        
        // Test
        print("Cropped Image >> \n\(croppedImage)")
        
        self.profileImageView.addSubview(self.configureSelectedImageView(selectedImage: croppedImage))
        // Dismiss vc
        dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
        // Set image to view
        //self.profileImageContainerView.image = originalImage
        
        // Test
        print("Selected Image >> \n\(originalImage)")
    }
    
    
    
    
    // Photo Picker Delegate Methods
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        // Set view to selected image
        self.profileImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // Collection view Delegate && Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == self.badgeCollectionView {
            // Return count
            return self.corpBadges.count //self.card.cardProfile.badgeList.count
        }else if collectionView == self.socialBadgeCollectionView{
            
            return self.socialBadges.count
        }else if collectionView == self.profileImageCollectionView{
            // Profile collection view
            return self.profileImagelist.count
        }else{
            
            if self.socialBadges.count > 0 {
                // Assign the socials to single collection
                return self.socialBadges.count
            }else{
                // The corp badges are the move
                return corpBadges.count
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath)
        
        
        if collectionView == self.badgeCollectionView {
            // Badge config
            
            self.configureBadges(cell: cell)
            
            ///cell.contentView.backgroundColor = UIColor.red
            self.configureBadges(cell: cell)
            
             let fileUrl = NSURL(string:self.corpBadges[indexPath.row].pictureUrl /*ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl*/)

            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWith(fileUrl! as URL)
            
            // Init add image
            let addView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
            
            if self.selectedCorpBadgeList[indexPath.row].isSelected {
                // Add minus sign
                
                let addImage = UIImage(named: "icn-minus-red")
                addView.image = addImage
                
            }else{
                // Add plus sign
                let addImage = UIImage(named: "icn-plus-green")
                addView.image = addImage
                
            }
            
            // Add to imageview
            imageView.addSubview(addView)
            
            
            // Add subview
            cell.contentView.addSubview(imageView)
            //print("Execiting!!")
            
            
        }else if collectionView == self.socialBadgeCollectionView{
            
            cell.contentView.backgroundColor = UIColor.red
            
            self.configureBadges(cell: cell)
            
            // Configure corner radius
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let image = self.socialBadges[indexPath.row]
            
            
            // Init add image
            let addView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
            
            if self.selectedSocialLinkList[indexPath.row].isSelected {
                // Add minus sign
                
                let addImage = UIImage(named: "icn-minus-red")
                addView.image = addImage
                
            }else{
                // Add plus sign
                let addImage = UIImage(named: "icn-plus-green")
                addView.image = addImage
                
            }
            
            // Set image
            imageView.image = image
            // Add to imageview
            imageView.addSubview(addView)
            
            
            // Add subview
            cell.contentView.addSubview(imageView)
            
        }else if collectionView == profileImageCollectionView{
            
           // cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            ///cell.contentView.backgroundColor = UIColor.red
            //self.configureBadges(cell: cell)
            
            self.configurePhoto(cell: cell)
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
            let image = self.profileImagelist[indexPath.row]
            imageView.layer.masksToBounds = true
            // Set image to view
            imageView.image = image
            // Add to collection
            cell.contentView.addSubview(imageView)
        }else{
            
            // Check which list populated
            if self.socialBadges.count > 0 {
                
                cell.contentView.backgroundColor = UIColor.red
                
                self.configureBadges(cell: cell)
                
                // Configure corner radius
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                let image = self.socialBadges[indexPath.row]
                
                
                // Init add image
                let addView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
                
                if self.selectedSocialLinkList[indexPath.row].isSelected {
                    // Add minus sign
                    
                    let addImage = UIImage(named: "icn-minus-red")
                    addView.image = addImage
                    
                }else{
                    // Add plus sign
                    let addImage = UIImage(named: "icn-plus-green")
                    addView.image = addImage
                    
                }
                
                // Set image
                imageView.image = image
                // Add to imageview
                imageView.addSubview(addView)
                
                
                // Add subview
                cell.contentView.addSubview(imageView)
                
            }else{
                
                // Badge config
                
                self.configureBadges(cell: cell)
                
                ///cell.contentView.backgroundColor = UIColor.red
                self.configureBadges(cell: cell)
                
                let fileUrl = NSURL(string:self.corpBadges[indexPath.row].pictureUrl /*ContactManager.sharedManager.currentUser.userProfile.badgeList[indexPath.row].pictureUrl*/)
                
                
                // Configure corner radius
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.setImageWith(fileUrl! as URL)
                
                // Init add image
                let addView = UIImageView(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
                
                if self.selectedCorpBadgeList[indexPath.row].isSelected {
                    // Add minus sign
                    
                    let addImage = UIImage(named: "icn-minus-red")
                    addView.image = addImage
                    
                }else{
                    // Add plus sign
                    let addImage = UIImage(named: "icn-plus-green")
                    addView.image = addImage
                    
                }
                
                // Add to imageview
                imageView.addSubview(addView)
                
                
                // Add subview
                cell.contentView.addSubview(imageView)
                //print("Execiting!!")
                
            }
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.badgeCollectionView {
            
            // Badge cell
            //card.cardProfile.badgeList.append(corpBadges[indexPath.row])
            // Highlight cell
            //print("Badge Card List >> \(card.cardProfile.badgeList)")
            
            if self.selectedCorpBadgeList[indexPath.row].isSelected == true {
                // Remove
                self.selectedCorpBadgeList[indexPath.row].isSelected = false
                print("Selected crop badge list > \(self.selectedCorpBadgeList)")
                // Add social to card
                //card.cardProfile.badgeList.remove(at: indexPath.row)
            }else{
                // Set selected index
                self.selectedCorpBadgeList[indexPath.row].isSelected = true
                
                print("Selected crop badge list > \(self.selectedCorpBadgeList)")
                
                // Add social to card
                //card.cardProfile.badgeList.append(corpBadges[indexPath.row])
                
            }
            
            // Check if in array
            /*if self.selectedCorpLinks.contains(corpBadges[indexPath.row].website) {
                // Already in list
                print("Item already in list")
                self.selectedCorpBadges.remove(at: indexPath.row)
                self.corpBadges.remove(at: indexPath.row)
                self.selectedCorpLinks.remove(at: indexPath.row)
            }else{
                // Append to array
                card.cardProfile.badgeList.append(corpBadges[indexPath.row])
                // Print for test
                print(card.cardProfile.badgeList as Any)
            }*/

        }else if collectionView == self.socialBadgeCollectionView{
            
            if self.selectedSocialLinkList[indexPath.row].isSelected == true {
                // Remove
                self.selectedSocialLinkList[indexPath.row].isSelected = false
                print("Selected media list > \(self.selectedSocialLinkList)")
                // Add social to card
                //card.cardProfile.socialLinks.remove(at: indexPath.row)
            }else{
                // Set selected index
                self.selectedSocialLinkList[indexPath.row].isSelected = true
                print("Selected media list > \(self.selectedSocialLinkList)")
                
                // Add social to card
                //card.cardProfile.socialLinks.append(["link" : socialLinks[indexPath.row]])
                
            }
            // Reload for index
            self.socialBadgeCollectionView.reloadData()
            
        }else if collectionView == profileImageCollectionView{
            // Set profile image
            self.profileImageView.image = profileImagelist[indexPath.row]
            self.profileImageViewSingleWrapper.image = profileImagelist[indexPath.row]
            self.profileImageViewEmptyWrapper.image = profileImagelist[indexPath.row]
            
        }else{
            
            // Check which list populated
            if self.socialBadges.count > 0 {
                
                if self.selectedSocialLinkList[indexPath.row].isSelected == true {
                    // Remove
                    self.selectedSocialLinkList[indexPath.row].isSelected = false
                    print("Selected media list > \(self.selectedSocialLinkList)")
                    // Add social to card
                    //card.cardProfile.socialLinks.remove(at: indexPath.row)
                }else{
                    // Set selected index
                    self.selectedSocialLinkList[indexPath.row].isSelected = true
                    print("Selected media list > \(self.selectedSocialLinkList)")
                    
                    // Add social to card
                    //card.cardProfile.socialLinks.append(["link" : socialLinks[indexPath.row]])
                    
                }
                
                
            }else{
                // Config for badges
                if self.selectedCorpBadgeList[indexPath.row].isSelected == true {
                    // Remove
                    self.selectedCorpBadgeList[indexPath.row].isSelected = false
                    print("Selected crop badge list > \(self.selectedCorpBadgeList)")
                    // Add social to card
                    //card.cardProfile.badgeList.remove(at: indexPath.row)
                }else{
                    // Set selected index
                    self.selectedCorpBadgeList[indexPath.row].isSelected = true
                    
                    print("Selected crop badge list > \(self.selectedCorpBadgeList)")
                    
                    // Add social to card
                    //card.cardProfile.badgeList.append(corpBadges[indexPath.row])
                    
                }
                
            }
            
            
        }
        // Reload to show changes
        collectionView.reloadData()

        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // Init view
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "CollectionHeader",
                                                                         for: indexPath)
        return headerView
    }

    
    func configureBadges(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 20.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        //cell.contentView.layer.borderColor = UIColor.blue.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    
    func configurePhoto(cell: UICollectionViewCell){
        // Add radius config & border color
        
        cell.contentView.layer.cornerRadius = 45.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 0.5
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        
        // Set shadow on the container view
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowRadius = 0.5
        
    }
    


    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[sections[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        containerView.backgroundColor = UIColor.white
        
        // Add label to the view
        var lbl = UILabel(frame: CGRect(8, 3, 180, 15))
        lbl.text = sections[section]
        lbl.textAlignment = .left
        lbl.textColor = UIColor(red: 3/255.0, green: 77/255.0, blue: 135/255.0, alpha: 1.0)
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium) //UIFont(name: "Avenir", size: CGFloat(14))
        
        // Add subviews
        containerView.addSubview(lbl)
        
        return containerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        // Set checkmark
        cell.accessoryType = selectedCells.contains(indexPath as NSIndexPath) ? .checkmark : .none
        
        
        switch sections[indexPath.section] {
        case "Bios":
            //cell.titleLabel.text = "Bio \(indexPath.row)"
            cell.descriptionLabel.text = bios[indexPath.row]
            
            if selectedBios.contains(bios[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case "Work":
            //cell.titleLabel.text = "Work \(indexPath.row)"
            cell.descriptionLabel.text = workInformation[indexPath.row]
            
            // Check if in list
            if selectedWorkInformation.contains(workInformation[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }

            return cell
        case "Titles":
            //cell.titleLabel.text = "Title \(indexPath.row)"
            cell.descriptionLabel.text = titles[indexPath.row]
            
            // Check if in list
            if selectedTitles.contains(titles[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }

            return cell
        case "Emails":
            //cell.titleLabel.text = "Email \(indexPath.row)"
            cell.descriptionLabel.text = emails[indexPath.row]
            //cell.textLabel?.text = emailLabels[indexPath.row]
            
            // Check if in list
            if selectedEmails.contains(emails[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            
            return cell
        case "Phone Numbers":
            //cell.titleLabel.text = "Phone \(indexPath.row)"
            cell.descriptionLabel.text = phoneNumbers[indexPath.row]
            //cell.textLabel?.text = phoneNumberLabels[indexPath.row]
            
            // Check if in list
            if selectedPhoneNumbers.contains(phoneNumbers[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case "Tags":
            //cell.titleLabel.text = "Social Media Link \(indexPath.row)"
            cell.descriptionLabel.text = tags[indexPath.row]
            
            // Check if in list
            if selectedTags.contains(tags[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case "Websites":
            //cell.titleLabel.text = "Website \(indexPath.row)"
            cell.descriptionLabel.text = websites[indexPath.row]
            
            // Check if in list
            if selectedWebsites.contains(websites[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            
            return cell
        case "Company":
            //cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = organizations[indexPath.row]
            
            // Check if in list
            if selectedOrganizations.contains(organizations[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
        case "Notes":
            //cell.titleLabel.text = "Organization \(indexPath.row)"
            cell.descriptionLabel.text = notes[indexPath.row]
            
            // Check if in list
            if selectedNotes.contains(notes[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell
            
        case "Addresses":
            //cell.titleLabel.text = "Organization \(indexPath.row)"
            
            if addresses.count > 0{
                // Set addy
                cell.descriptionLabel.text = addresses[indexPath.row]
                //cell.textLabel?.text = addressLabels[indexPath.row]
            }
            
            // Check if in list
            if selectedAddressObjects.contains(addressObjects[indexPath.row]) {
                // Set to selected cells list
                selectedCells.append(indexPath as NSIndexPath)
                // Set cell accessory type
                cell.accessoryType = .checkmark
            }
            return cell

        default:
            return cell
        }
        
        
        
    }
    
    
    //MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Create Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileBioInfoCell", for: indexPath) as! CardOptionsViewCell
        
        cell.selectionStyle = .none
        
        // Deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        cardOptionsTableView.deselectRow(at: indexPath, animated: true)
        
        // Set bg to white to make sure
        //cell.backgroundColor = UIColor.white
        
        // Reset label value
        cell.descriptionLabel.text = tableData[sections[indexPath.section]]?[indexPath.row]
        
        // Set Checkmark
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        selectedCells.append(indexPath as NSIndexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            
            selectedCells = selectedCells.filter {$0 as IndexPath != indexPath}
            
        } else {
            
            selectedCell?.accessoryType = .checkmark
        }
        
        // Switch case to find right section
        switch sections[indexPath.section]{
        case "Bios":
            //card.cardProfile.bio = bios[indexPath.row]
            
            if self.selectedBios.contains(bios[indexPath.row]) {
                // Print Already selected
                print("Item already selected", selectedBios)
                // Most likely show an alert
                selectedBios = selectedBios.filter{$0 != bios[indexPath.row]}
                
                // Print Already selected
                print("List after removal", selectedBios)
                
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory 
                selectedCell?.accessoryType = .none
                
                print("Card Bios Before Removal\n", card.cardProfile.bios)
                // Remove the item from card by filtering list
                card.cardProfile.bios = card.cardProfile.bios.filter{ $0["bio"] != bios[indexPath.row]}
  
                print("Card Bios Post Removal\n", card.cardProfile.bios)
                
                // Reload data
                cardOptionsTableView.reloadData()
                
            }else{
                // Add to selected list
                selectedBios.append(bios[indexPath.row])
                
                // Append bio to list if not selected
                card.cardProfile.setBioRecords(emailRecords: ["bio" : bios[indexPath.row]])
                
                print("The card added bio", card.cardProfile.bios)
            }
            
        case "Work":
            //card.cardProfile.workInfo = workInformation[indexPath.row]
            
            if self.selectedWorkInformation.contains(workInformation[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedWorkInformation.remove(at: indexPath.row)
                // Remove from array 
                workInformation.remove(at: indexPath.row)
            }else{
                // Append to work list
                card.cardProfile.setWorkRecords(emailRecords: ["work" : workInformation[indexPath.row]])
            }
            
        case "Titles":
            //card.cardProfile.title = titles[indexPath.row]
            
            // Check if already selected
            if self.selectedTitles.contains(titles[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedTitles = selectedTitles.filter{$0 != titles[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.titles = card.cardProfile.titles.filter{ $0["title"] != titles[indexPath.row]}
                
                print("Card Titles Post Removal\n", card.cardProfile.titles)
                
                // Check if title is populated in card wrapper
                if self.titleLabel.text == titles[indexPath.row] || self.titleLabelSingleWrapper.text == titles[indexPath.row] || self.titleLabelEmptyWrapper.text == titles[indexPath.row] {
                    // Remove text
                    self.titleLabel.text = ""
                    self.titleLabelSingleWrapper.text = ""
                    self.titleLabelEmptyWrapper.text = ""
                }
                
                // Reload data
                cardOptionsTableView.reloadData()
                
                
            }else{
                // Add to list
                //card.cardProfile.setTitleRecords(emailRecords: ["title" : titles[indexPath.row]])
                
                // Add to selected list
                self.selectedTitles.append(titles[indexPath.row])
                
                
                if card.cardProfile.titles.count > 0 {
                    card.cardProfile.titles[0] = ["title" : titles[indexPath.row]]
                }else{
                    
                    // Overwrite the selection to keep it only one selectable
                    card.cardProfile.titles.append(["title" : titles[indexPath.row]])
                    
                }
                
                // Assign label value
                self.titleLabel.text = titles[indexPath.row]
                self.titleLabelSingleWrapper.text = titles[indexPath.row]
                self.titleLabelEmptyWrapper.text = titles[indexPath.row]
            }
            
        case "Emails":
            // Check if in array already
            if self.selectedEmails.contains(emails[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedEmails = selectedEmails.filter{ $0 != emails[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.emails = card.cardProfile.emails.filter{ $0["email"] != emails[indexPath.row]}
                
                print("Card Emails Post Removal\n", card.cardProfile.emails)
                
                // Check if title is populated in card wrapper
                if self.emailLabel.text == emails[indexPath.row] || self.emailLabelSingleWrapper.text == emails[indexPath.row] || self.emailLabelEmptyWrapper.text == emails[indexPath.row]{
                    // Remove text
                    self.emailLabel.text = ""
                    self.emailLabelSingleWrapper.text = ""
                    self.emailLabelEmptyWrapper.text = ""
                }
                
                // Reload data
                cardOptionsTableView.reloadData()
                
                
                
            }else{
                
                // Add to selected
                self.selectedEmails.append(emails[indexPath.row])
                
                // Append to list
                card.cardProfile.emails.append(["email" : emails[indexPath.row]])
                
                // Test
                print(card.cardProfile.emails as Any)
                
                // Assign label value
                if emails.count != 0{
                    self.emailLabel.text = emails[indexPath.row]
                    self.emailLabelSingleWrapper.text = emails[indexPath.row]
                    self.emailLabelEmptyWrapper.text = emails[indexPath.row]
                }
                
                
            }
            
            //self.emailLabel.text = emails[indexPath.row]
            
        case "Phone Numbers":
            
            // Check if in array
            if self.selectedPhoneNumbers.contains(phoneNumbers[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedPhoneNumbers = selectedPhoneNumbers.filter{ $0 != phoneNumbers[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.phoneNumbers = card.cardProfile.phoneNumbers.filter{ $0.values.first! != phoneNumbers[indexPath.row]}
                
                print("Card Phones Post Removal\n", card.cardProfile.phoneNumbers)
                
                // Check if title is populated in card wrapper
                if self.numberLabel.text == phoneNumbers[indexPath.row] || self.numberLabelSingleWrapper.text == phoneNumbers[indexPath.row] || self.numberLabelEmptyWrapper.text == phoneNumbers[indexPath.row]{
                    // Remove text
                    self.numberLabel.text = ""
                    self.numberLabelSingleWrapper.text = ""
                    self.numberLabelEmptyWrapper.text = ""
                }
                
                // Reload data
                cardOptionsTableView.reloadData()
                
                
                
            }else{
                // Add to selected list
                selectedPhoneNumbers.append(phoneNumbers[indexPath.row])
                
                // Add dictionary value to cardProfile
                card.cardProfile.setPhoneRecords(phoneRecords: ["phone" : phoneNumbers[indexPath.row]])
                // Print for testing
                print(card.cardProfile.phoneNumbers as Any)
                
                // Assign label value
                self.numberLabel.text = phoneNumbers[indexPath.row]
                self.numberLabelSingleWrapper.text = phoneNumbers[indexPath.row]
                self.numberLabelEmptyWrapper.text = phoneNumbers[indexPath.row]
            }
            
        case "Tags":
            // Check if in array 
            if self.selectedTags.contains(tags[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedTags = selectedTags.filter{ $0 != tags[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.tags = card.cardProfile.tags.filter{ $0["tag"] != tags[indexPath.row]}
                
                print("Card Tags Post Removal\n", card.cardProfile.tags)
                
                
                // Reload data
                cardOptionsTableView.reloadData()
                
                
            }else{
                
                // Add to selected
                selectedTags.append(tags[indexPath.row])
                
                // Append to array
                card.cardProfile.tags.append(["tag" : tags[indexPath.row]])
                // Print for test
                print(card.cardProfile.tags as Any)
            }
            
        case "Websites":
            // Check if in array 
            if self.selectedWebsites.contains(websites[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedWebsites = selectedWebsites.filter{ $0 != websites[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.websites = card.cardProfile.websites.filter{ $0["website"] != websites[indexPath.row]}
                
                print("Card Websites Post Removal\n", card.cardProfile.websites)
                
                
                // Reload data
                cardOptionsTableView.reloadData()
                
                
            }else{
                
                // Add to selected array
                selectedWebsites.append(websites[indexPath.row])
                
                // Append to array
                card.cardProfile.websites.append(["website" : websites[indexPath.row]])
                // Print for test
                print(card.cardProfile.websites as Any)
            }
            
        case "Company":
            
            if self.selectedOrganizations.contains(organizations[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedOrganizations = selectedOrganizations.filter{ $0 != organizations[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.organizations = card.cardProfile.organizations.filter{ $0["organization"] != organizations[indexPath.row]}
                
                print("Card Websites Post Removal\n", card.cardProfile.websites)
                
                
                // Reload data
                cardOptionsTableView.reloadData()
                
            }else{
                // Append to array
                //card.cardProfile.organizations.append(["organization" : organizations[indexPath.row]])
                
                // Set selected
                selectedOrganizations.append(organizations[indexPath.row])
                
                if card.cardProfile.organizations.count > 0 {
                    // Overwrite object
                    card.cardProfile.organizations[0] = ["organization" : organizations[indexPath.row]]
                    
                }else{
                    // Add organizartion
                    card.cardProfile.organizations.append(["organization" : organizations[indexPath.row]])
                }
                
                // Print for test
                print(card.cardProfile.organizations as Any)
            }
        case "Notes":
            
            if self.selectedNotes.contains(notes[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedNotes = selectedNotes.filter { $0 != notes[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.notes = card.cardProfile.notes.filter{ $0["note"] != notes[indexPath.row]}
                
                print("Card Notes Post Removal\n", card.cardProfile.notes)
                
                // Reload data
                cardOptionsTableView.reloadData()
                
                
            }else{
                // Add to selected list
                selectedNotes.append(notes[indexPath.row])
                
                // Append to array
                card.cardProfile.notes.append(["note" : notes[indexPath.row]])
                // Print for test
                print(card.cardProfile.notes as Any)
            }
        case "Addresses":
            if self.selectedAddressObjects.contains(addressObjects[indexPath.row]) {
                // Already in list
                print("Item already in list")
                self.selectedAddressObjects = selectedAddressObjects.filter { $0 != addressObjects[indexPath.row]}
                
                // Remove cell from selected list
                selectedCells = selectedCells.filter{ $0 as IndexPath != indexPath}
                
                // Set accessory
                selectedCell?.accessoryType = .none
                
                // Remove the item from card by filtering list
                card.cardProfile.addresses = card.cardProfile.addresses.filter{ $0 != addressObjects[indexPath.row] as! [String : String]}
                
                
                print("Card Addresse Post Removal\n", card.cardProfile.addresses)
                
                
                // Reload data
                cardOptionsTableView.reloadData()
                
            }else{
                
                // Add to selected list
                selectedAddressObjects.append(addressObjects[indexPath.row])
                
                // Append to array
                card.cardProfile.addresses.append(addressObjects[indexPath.row] as! [String : String])
                // Print for test
                print(card.cardProfile.addresses as Any)
            }

        default:
            print("Nothing doing here..")
        }
        
        // Deselect cell
        //Change the selected background view of the cell.
        cardOptionsTableView.deselectRow(at: indexPath, animated: true)
        
        // reload data
        cardOptionsTableView.reloadData()
        
        // Print card to test
        //card.printCard()
    }
    
    // Custom Methods
    
    func parseAccountForImages() {
        
        // Clear all from list
        self.profileImagelist.removeAll()
        
        // Check for image, set to imageview
        if ContactManager.sharedManager.currentUser.profileImages.count > 0{
            // Add section
            //sections.append("Photos")
            for img in ContactManager.sharedManager.currentUser.profileImages {
                let image = UIImage(data: img["image_data"] as! Data)
                // Append to list
                self.profileImagelist.append(image!)
            }
            // Create section data
            //self.tableData["Photos"] = profileImagelist
        }
        
    }
    

    
    
    func postContactListRefresh() {
        // Post notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: self)
    }
    
    // Configuration
    func configureViews(){
        
        // Configure cards
        self.profileCardWrapperView.layer.cornerRadius = 12.0
        self.profileCardWrapperView.clipsToBounds = true
        self.profileCardWrapperView.layer.borderWidth = 0.5
        self.profileCardWrapperView.layer.borderColor = UIColor.clear.cgColor
        
        // Config imageview
        self.configureSelectedImageView(imageView: self.profileImageView)
        self.configureSelectedImageView(imageView: self.profileImageViewSingleWrapper)
        self.configureSelectedImageView(imageView: self.profileImageViewEmptyWrapper)
        
        // Round borders on table
        self.cardOptionsTableView.layer.cornerRadius = 12.0
        self.cardOptionsTableView.clipsToBounds = true
        self.cardOptionsTableView.layer.borderWidth = 2.0
        self.cardOptionsTableView.layer.borderColor = UIColor.white.cgColor
        
        // Assign media buttons
        /*mediaButton1.image = UIImage(named: "social-blank")
        mediaButton2.image = UIImage(named: "social-blank")
        mediaButton3.image = UIImage(named: "social-blank")
        mediaButton4.image = UIImage(named: "social-blank")
        mediaButton5.image = UIImage(named: "social-blank")
        mediaButton6.image = UIImage(named: "social-blank")
        mediaButton7.image = UIImage(named: "social-blank")*/
        
    }
    
    func configurePhotoPicker() {
        //Initial setup
        photoPicker.disableEntitlements = false // If you don't want use iCloud entitlement just set this value True
        photoPicker.alertTitle = "Select Card Image"
        photoPicker.alertMessage = ""
        photoPicker.resizeImage = CGSize(width: 150, height: 150)
        photoPicker.allowDestructive = false
        photoPicker.allowEditing = false
        // Set front facing camera
        photoPicker.cameraDevice = .front
        photoPicker.cameraFlashMode = .auto
        
        photoPicker.actionTitleLibrary = "Photo Library"
        photoPicker.actionTitleLastPhoto = "Last Photo"
        photoPicker.actionTitleTakePhoto = "Take Photo"
        photoPicker.actionTitleCancel = "Cancel"
        photoPicker.actionTitleOther = "Import From..."
    }
    
    // Parse card for selected values
    func parseCardForSelections() {

        // Parse card for profile info
        
        if card.cardProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in card.cardProfile.bios{
                selectedBios.append(bio["bio"]!)
                print(selectedBios.count)
            }
            
        }
        // Parse work info
        if card.cardProfile.workInformationList.count > 0{
            for info in card.cardProfile.workInformationList{
                selectedWorkInformation.append(info["work"]!)
            }
        }
        
        // Parse work info
        if card.cardProfile.titles.count > 0{
            for info in card.cardProfile.titles{
                selectedTitles.append((info["title"])!)
            }
        }

        if card.cardProfile.phoneNumbers.count > 0{
            for number in card.cardProfile.phoneNumbers{
                selectedPhoneNumbers.append(number.values.first!)
            }
        }
        
        if card.cardProfile.emails.count > 0{
            for email in card.cardProfile.emails{
                selectedEmails.append(email["email"]! )
            }
        }
        if card.cardProfile.websites.count > 0{
            for site in card.cardProfile.websites{
                selectedWebsites.append(site["website"]! )
            }
        }
        if card.cardProfile.organizations.count > 0{
            for org in card.cardProfile.organizations{
                selectedOrganizations.append(org["organization"]! )
            }
        }
        if card.cardProfile.tags.count > 0{
            for hashtag in card.cardProfile.tags{
                selectedTags.append(hashtag["tag"]! )
            }
        }
        if card.cardProfile.notes.count > 0{
            for note in card.cardProfile.notes{
                selectedNotes.append(note["note"]! )
            }
        }
        
        
        // Parse card for badges
        if card.cardProfile.badgeDictionaryList.count > 0{
            
            for corp in card.cardProfile.badgeDictionaryList {
                // Init badge
                let badge = CardProfile.Bagde(snapshot: corp)
                
                // Add to list
                //self.corpBadges.append(badge)
                
                self.selectedCorpLinks.append(badge.website)
            }

        }
        
        // Parse for addresses
        if card.cardProfile.addresses.count > 0{
            for add in card.cardProfile.addresses{
                selectedAddress.append(add.values.first!)
                selectedAddressObjects.append(add as NSDictionary)
            }
        }

    }
    
    
    func parseDataFromProfile() {
        
        // Reset arrays
        self.bios = [String]()
        self.titles = [String]()
        self.emails = [String]()
        self.phoneNumbers = [String]()
        self.socialLinks = [String]()
        self.organizations = [String]()
        self.websites = [String]()
        self.workInformation = [String]()
        self.corpBadges.removeAll()
        self.addresses.removeAll()
        self.notes.removeAll()
        self.tags.removeAll()
        self.sections.removeAll()
        self.tableData.removeAll()
        
        // Parse work info
        if ContactManager.sharedManager.currentUser.userProfile.titles.count > 0{
            // Add section
            sections.append("Titles")
            for info in ContactManager.sharedManager.currentUser.userProfile.titles{
                titles.append((info["title"])!)
            }
            // Create section data
            self.tableData["Titles"] = titles
        }
        
        // Parse organizations
        if ContactManager.sharedManager.currentUser.userProfile.organizations.count > 0{
            // Add section
            sections.append("Company")
            for org in ContactManager.sharedManager.currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
            // Create section data
            self.tableData["Company"] = organizations
        }
        
        // Parse bio info
        if ContactManager.sharedManager.currentUser.userProfile.bios.count > 0{
            // Add section
            sections.append("Bios")
            // Iterate throught array and append available content
            for bio in ContactManager.sharedManager.currentUser.userProfile.bios{
                bios.append((bio["bio"])!)
            }
            // Create section data
            self.tableData["Bios"] = bios
        }
        
        // Parse work info
        
        /*
        
        if ContactManager.sharedManager.currentUser.userProfile.workInformationList.count > 0{
            // Add section
            sections.append("Work")
            for info in ContactManager.sharedManager.currentUser.userProfile.workInformationList{
                workInformation.append((info["work"])!)
            }
            // Create section data
            self.tableData["Work"] = workInformation
        }*/
        
        if ContactManager.sharedManager.currentUser.userProfile.phoneNumbers.count > 0{
            // Add section
            sections.append("Phone Numbers")
            for number in ContactManager.sharedManager.currentUser.userProfile.phoneNumbers{
                // Format phone number
                phoneNumbers.append(self.format(phoneNumber:(number.values.first ?? "")) ?? "")
                phoneNumberLabels.append(number.keys.first!)
            }
            // Create section data
            self.tableData["Phone Numbers"] = phoneNumbers
            
        }
        // Parse emails
        
        if ContactManager.sharedManager.currentUser.userProfile.emails.count > 0{
            // Add section
            sections.append("Emails")
            for email in ContactManager.sharedManager.currentUser.userProfile.emails{
                emails.append(email["email"] ?? "")
                emailLabels.append(email["type"] ?? "")
            }
            // Create section data
            self.tableData["Emails"] = emails
        }
        
        // Parse websites
        if ContactManager.sharedManager.currentUser.userProfile.websites.count > 0{
            // Add section
            sections.append("Websites")
            for site in ContactManager.sharedManager.currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
            // Create section data
            self.tableData["Websites"] = websites
        }
        // Parse Tags
        if ContactManager.sharedManager.currentUser.userProfile.tags.count > 0{
            // Add section
            sections.append("Tags")
            for hashtag in ContactManager.sharedManager.currentUser.userProfile.tags{
                
                tags.append(hashtag["tag"]!)
                
            }
            // Create section data
            self.tableData["Tags"] = tags
        }
        
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.notes.count > 0{
            // Add section
            sections.append("Notes")
            for note in ContactManager.sharedManager.currentUser.userProfile.notes{
                
                notes.append(note["note"]!)
                
            }
            // Create section data
            self.tableData["Notes"] = notes
        }

        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                
                //socialLinks.append(link["link"]!)
                print("Executing parse call from edit card")
            }
        }
        
        /*
        if ContactManager.sharedManager.currentUser.userProfile.badgeList.count > 0{
            
            for badge in ContactManager.sharedManager.currentUser.userProfile.badgeList{
                // Check if hidden
                if badge.isHidden == false {
                    // Append badges from proile
                    corpBadges.append(badge)
                    print("Executing parse call from edit card")
                }
            }
        }*/
        
        // Parse notes
        if ContactManager.sharedManager.currentUser.userProfile.addresses.count > 0{
            // Add section
            sections.append("Addresses")
            for add in ContactManager.sharedManager.currentUser.userProfile.addresses{
                
                // Set all values for the cells
                let street = add["street"] ?? ""
                let city = add["city"] ?? ""
                let state = add["state"] ?? ""
                let zip = add["zip"] ?? ""
                let country = add["country"] ?? ""
                
                // Create Address String
                let addressString = "\(street) \(city) \(state) \(zip) \(country)"
                
                // Append values
                addresses.append(addressString)
                addressLabels.append(add["type"] ?? "")
                addressObjects.append(add as NSDictionary)
                
            }
            // Create section data
            self.tableData["Addresses"] = addresses
        }
        
        // Parse card for selected badges
        if card.cardProfile.badgeDictionaryList.count > 0{
            
            for corp in card.cardProfile.badgeDictionaryList {
                // Init badge
                let badge = CardProfile.Bagde(snapshot: corp)
                // Add to selected crop link list
                self.selectedCorpLinks.append(badge.website)
            }
            
        }

        
        // Init counter
        var index = 0
        
        // Iterate over list to parse for corp badges
        if ContactManager.sharedManager.currentUser.userProfile.badgeList.count > 0{
            
            for badge in ContactManager.sharedManager.currentUser.userProfile.badgeList{
                
                // Check if visible
                // Append badges from proile
                corpBadges.append(badge)
                print("Creating badge list on create card >> \(corpBadges.count)")
                
                var selectedIndex : Check
                
                if selectedCorpLinks.contains(badge.website){
                    // Create selected index
                    selectedIndex = Check(arrayIndex: index, selected: true)
                }else{
                    // Create selected index
                    selectedIndex = Check(arrayIndex: index, selected: false)
                }
                
                // Set Selected index
                self.selectedCorpBadgeList.append(selectedIndex)
                
                //Increment index
                index = index + 1
            }
        }
        

        
        
        // Parse for corp 
        //self.parseForCorpBadges()

        // Parse for social badges 
        self.parseForSocialIcons()
        
        // Get images
        self.parseAccountForImages()
        
        // Refresh table
        cardOptionsTableView.reloadData()
        badgeCollectionView.reloadData()
    }

    
    
    // Alert Controller to Add CardName
    
    func showAlertWithTextField(description: String, placeholder: String, actionType: String){
        
        // Init alert
        let alertVC = PMAlertController(title: "", description: description, image: nil, style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = placeholder
        }
        
        // Add 'cancel' action
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        // Add 'done' action
        alertVC.addAction(PMAlertAction(title: "Done", style: .default, action: { () in
            print("Capture action OK")
            if alertVC.textFields[0].text != nil{
                
                // Switch Case here to do the appropriate action
                switch actionType {
                case "Add Name":
                    // Take text and add it to the card
                    self.card.cardName = alertVC.textFields[0].text
                    // Set Card Name label text
                    self.cardNameButton.titleLabel?.text = alertVC.textFields[0].text
                    self.cardNameButtonSingleWrapper.titleLabel?.text = alertVC.textFields[0].text
                    self.cardNameButtonEmptyWrapper.titleLabel?.text = alertVC.textFields[0].text
                case "Add Tag":
                    // Take text and add it to the card
                    self.card.cardProfile.setTags(tagRecords: ["tag" : alertVC.textFields[0].text!])
                    // Show alert confirmation
                    
                case "Add Note":
                    // Append text to notes
                    self.card.cardProfile.setNotes(noteRecords: ["note" : alertVC.textFields[0].text!])
                    // Show confirmation alert
                    
                default:
                    print("")
                }
            }
        }))
        // Show VC
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // Custom Methods
    // -------------------------------------------
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        // Set action to set name for card 
        self.addCardName(self)
    }
    
    func initializeBadgeList() {
        // Image config
        // Test data config
        let img1 = UIImage(named: "Facebook.png")
        let img2 = UIImage(named: "Twitter.png")
        let img3 = UIImage(named: "instagram.png")
        let img4 = UIImage(named: "Pinterest.png")
        let img5 = UIImage(named: "Linkedin.png")
        let img6 = UIImage(named: "GooglePlus.png")
        let img7 = UIImage(named: "Crunchbase.png")
        let img8 = UIImage(named: "Youtube.png")
        let img9 = UIImage(named: "Soundcloud.png")
        let img10 = UIImage(named: "Flickr.png")
        let img11 = UIImage(named: "AboutMe.png")
        let img12 = UIImage(named: "Angellist.png")
        let img13 = UIImage(named: "Foursquare.png")
        let img14 = UIImage(named: "Medium.png")
        let img15 = UIImage(named: "Tumblr.png")
        let img16 = UIImage(named: "Quora.png")
        let img17 = UIImage(named: "Reddit.png")
        let img18 = UIImage(named: "Snapchat.png")
        let img19 = UIImage(named: "social-blank")
        // Hash images
        
        self.socialLinkBadges = [["facebook" : img1!], ["twitter" : img2!], ["instagram" : img3!], ["pinterest" : img4!], ["linkedin" : img5!], ["plus.google" : img6!], ["crunchbase" : img7!], ["youtube" : img8!], ["soundcloud" : img9!], ["flickr" : img10!], ["about.me" : img11!], ["angel.co" : img12!], ["foursquare" : img13!], ["medium" : img14!], ["tumblr" : img15!], ["quora" : img16!], ["reddit" : img17!], ["snapchat" : img18!], ["other" : img19!]]
        
        
    }
    
    func parseForCorpBadges() {
        // Test
        print("Looking for corp icons on card edit view")
        
        // Index for selection
        var counter = 0
        
        // Parse socials links
        if ContactManager.sharedManager.badgeList.count > 0/*card.cardProfile.badgeList.count*/{
            for badge in ContactManager.sharedManager.badgeList{
                
                // Create selected index
                let selectedIndex = Check(arrayIndex: counter, selected: false)
                // Set Selected index
                self.selectedCorpBadgeList.append(selectedIndex)
                
                // Append to selected list
                self.corpBadges.append(badge)
                // Test
                print("Corp Badges Count >> \(self.corpBadges.count)")
                
            }
            // Increment
            counter = counter + 1
        }
        
       /* if card.cardProfile.badgeList.count > 0{
            for badge in card.cardProfile.badgeList{
                
                // Create selected index
                let selectedIndex = Check(arrayIndex: counter, selected: false)
                // Set Selected index
                self.selectedCorpBadgeList.append(selectedIndex)
                
                // Append to selected list
                selectedCorpBadges.append(badge)
                // Test
                print("Count >> \(socialLinks.count)")
                
                // Increment
                counter = counter + 1
            }
        }*/


    }
    
    
    func parseForSocialIcons() {
        
        // Create list containing link info
        self.initializeBadgeList()
        
        // Remove all items from badges
        self.socialBadges.removeAll()
        self.socialLinks.removeAll()
        
        
        // Iterate using index to set selected list
        
        if card.cardProfile.socialLinks.count > 0{
            
            for link in card.cardProfile.socialLinks{
                // Append link to list
                selectedSocialLinks.append(link["link"]! )
            }
        }

        
        print("Looking for social icons on card selection view")
       
        // Index for selection
        var counter = 0
        
        // Parse socials links
        if ContactManager.sharedManager.currentUser.userProfile.socialLinks.count > 0{
            for link in ContactManager.sharedManager.currentUser.userProfile.socialLinks{
                socialLinks.append(link["link"]!)
                // Test
                print("Count >> \(socialLinks.count)")
                
                // Init selected index
                var selectedIndex : Check
                
                if self.selectedSocialLinks.contains(link["link"]!) {
                    // Set index selected to true
                    selectedIndex = Check(arrayIndex: counter, selected: true)
                }else{
                    // Set index selected to true
                    selectedIndex = Check(arrayIndex: counter, selected: false)
                }
                
                // Set Selected index
                self.selectedSocialLinkList.append(selectedIndex)
            }
        }
        
    

        
        // Add plus icon to list
        
        // Iterate over links[]
        for link in self.socialLinks {
            // Check if link is a key
            print("Link >> \(link)")
            for item in self.socialLinkBadges {
                // Test
                //print("Item >> \(item.first?.key)")
                // temp string
                let str = item.first?.key
                //print("String >> \(str)")
                // Check if key in link
                if link.lowercased().range(of:str!) != nil {
                    print("exists")
                    
                    // Append link to list
                    self.socialBadges.append(item.first?.value as! UIImage)
                    
                    /*if !socialBadges.contains(item.first?.value as! UIImage) {
                     print("NOT IN LIST")
                     // Append link to list
                     self.socialBadges.append(item.first?.value as! UIImage)
                     }else{
                     print("ALREADY IN LIST")
                     }*/
                    // Append link to list
                    //self.socialBadges.append(item.first?.value as! UIImage)
                    
                    
                    
                    //print("THE IMAGE IS PRINTING")
                    //print(item.first?.value as! UIImage)
                    print("SOCIAL BADGES COUNT")
                    print(self.socialBadges.count)
                    
                    
                }
            }
            
            
            // Reload table
            self.socialBadgeCollectionView.reloadData()
        }
        
        // Add image to the end of list
        //let image = UIImage(named: "icn-plus-blue")
        //self.socialBadges.append(image!)
        
        // Reload table
        self.socialBadgeCollectionView.reloadData()
        
    }
    
    func populateCards(){
        // Senders card config
        
        // Populate image view
        if card.cardProfile.images.count > 0{
            profileImageView.image = UIImage(data: card.cardProfile.images[0]["image_data"] as! Data)
            profileImageViewSingleWrapper.image = UIImage(data: card.cardProfile.images[0]["image_data"] as! Data)
            profileImageViewEmptyWrapper.image = UIImage(data: card.cardProfile.images[0]["image_data"] as! Data)
        
        }else if card.cardProfile.imageIds.count > 0{
            
            print("Profile image id not nil on selection", card.cardProfile.imageIds[0]["card_image_id"] as! String)
            print(card.cardProfile.imageIds)
            
            // Init id
            let idString = card.cardProfile.imageIds[0]["card_image_id"] as! String
            
            print("ID String :", idString)
            
            // Set image for contact
            let url = URL(string: "\(ImageURLS.sharedManager.getFromDevelopmentURL)\(idString).jpg")!
            let placeholderImage = UIImage(named: "profile")!
            
            print("URL String :", url)
            
            // Set image from url
            profileImageView.setImageWith(url, placeholderImage: placeholderImage)
            profileImageViewSingleWrapper.setImageWith(url, placeholderImage: placeholderImage)
            profileImageViewEmptyWrapper.setImageWith(url, placeholderImage: placeholderImage)
        }else{
            print("Profile met neither on selection")
            
            profileImageView.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            profileImageViewSingleWrapper.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            profileImageViewEmptyWrapper.image = UIImage(data: ContactManager.sharedManager.currentUser.profileImages[0]["image_data"] as! Data)
            print(card.cardProfile.imageId)
            print(card.imageId)
        }
        
        
        
        
        
        // Populate label fields
        if let name = card.cardHolderName{
            nameLabel.text = name
            nameLabelSingleWrapper.text = name
            nameLabelEmptyWrapper.text = name
        }
        if card.cardProfile.phoneNumbers.count > 0{
            numberLabel.text = self.format(phoneNumber: card.cardProfile.phoneNumbers[0].values.first!)
            numberLabelSingleWrapper.text = self.format(phoneNumber: card.cardProfile.phoneNumbers[0].values.first!)
            numberLabelEmptyWrapper.text = self.format(phoneNumber: card.cardProfile.phoneNumbers[0].values.first!)
        }
        if card.cardProfile.emails.count > 0{
            emailLabel.text = card.cardProfile.emails[0]["email"]
            emailLabelSingleWrapper.text = card.cardProfile.emails[0]["email"]
            emailLabelEmptyWrapper.text = card.cardProfile.emails[0]["email"]
        }
        if let title = card.cardProfile.title{
            titleLabel.text = title
            titleLabelSingleWrapper.text = title
            titleLabelEmptyWrapper.text = title
        }
        // Here, parse data to populate tableview
    }
    
    // Format textfield for phone numbers
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard /*length == 7 ||*/ length == 10 || (length == 11 && hasLeadingOne) else {
            return sourcePhoneNumber ?? ""
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }

    
    // Notifications
    
    func postNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardFinishedEditing"), object: self)
        
        
    }
    
    
    func postDeleteNotification() {
        
        // Notification for radar screen
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CardDeleted"), object: self)
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
