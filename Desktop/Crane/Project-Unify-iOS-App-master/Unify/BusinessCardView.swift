//
//  BusinessCardView.swift
//  Unify
//
//  Created by Kevin Fich on 5/30/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit

class BusinessCardView: UIView {

    // Properties
    // ==================================
    
    var name = ""
    
    // IBOutlets
    // ==================================
    @IBOutlet var view: UIView!

    
    // Imageview 
    @IBOutlet var contactImageView: UIImageView!
    
    // Labels
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    
    @IBOutlet var optionalLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!

    @IBOutlet var phoneIconImage: UIImageView!
    
    @IBOutlet var optionalIconImage: UIImageView!
    
    @IBOutlet var emailIconImage: UIImageView!
    
    @IBOutlet var cardTypeLabel: UILabel!
    // Social Media
    @IBOutlet var mediaButton1: UIButton!
    @IBOutlet var mediaButton2: UIButton!
    @IBOutlet var mediaButton3: UIButton!
    @IBOutlet var mediaButton4: UIButton!
    

    // Init 
    
    override func awakeFromNib() {
        print("awakeFromNib")
        super.awakeFromNib()
        //self.configureViews()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //self.configureViews()

        
        // Configure the view for display
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        //self.configureViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.configureViews()
        
        Bundle.main.loadNibNamed("BusinessCardView", owner: self, options: nil)
        self.addSubview(self.view)
        //view.frame = self.bounds
        self.configureViews()


    }
    
    
    // Loads a XIB file into a view and returns this view.
   /* private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        /* Usage for swift < 3.x
         let bundle = NSBundle(forClass: self.dynamicType)
         let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
         let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
         */
        
        return view
    }*/
    
    // Custom Methods
    // ==================================

    func configureViews(){
        
        
        // Test to see if view is being drawn 
        
        print("\n\nTHIS IS THE BUSINESS CARD\n\n")
        
        
        // Add radius config & border color
        self.contactImageView.layer.cornerRadius = 10.0
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.borderWidth = 1.0
        self.contactImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.phoneIconImage.layer.cornerRadius = 10.0
        self.phoneIconImage.clipsToBounds = true
        self.phoneIconImage.layer.borderWidth = 0.50
        self.phoneIconImage.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.emailIconImage.layer.cornerRadius = 10.0
        self.emailIconImage.clipsToBounds = true
        self.emailIconImage.layer.borderWidth = 0.50
        self.emailIconImage.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.optionalIconImage.layer.cornerRadius = 10.0
        self.optionalIconImage.clipsToBounds = true
        self.optionalIconImage.layer.borderWidth = 0.50
        self.optionalIconImage.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.cardTypeLabel.layer.cornerRadius = 10.0
        self.cardTypeLabel.clipsToBounds = true
        self.cardTypeLabel.layer.borderWidth = 2.0
        self.cardTypeLabel.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton1.layer.cornerRadius = 10.0
        self.mediaButton1.clipsToBounds = true
        self.mediaButton1.layer.borderWidth = 1.0
        self.mediaButton1.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton2.layer.cornerRadius = 10.0
        self.mediaButton2.clipsToBounds = true
        self.mediaButton2.layer.borderWidth = 1.0
        self.mediaButton2.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton3.layer.cornerRadius = 10.0
        self.mediaButton3.clipsToBounds = true
        self.mediaButton3.layer.borderWidth = 1.0
        self.mediaButton3.layer.borderColor = UIColor.lightGray.cgColor
        
        // Add radius config & border color
        self.mediaButton4.layer.cornerRadius = 10.0
        self.mediaButton4.clipsToBounds = true
        self.mediaButton4.layer.borderWidth = 1.0
        self.mediaButton4.layer.borderColor = UIColor.lightGray.cgColor
        
    }

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
