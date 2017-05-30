//
//  SingleActivity-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/5/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import PopupDialog
import UIDropDown


class SingleActivityViewController: UIViewController {
    
    
    var active_card_unify_uuid: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "background")?.draw(in: self.view.bounds)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        self.view.backgroundColor = UIColor(patternImage: image)
        
       
        
        
}

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print(">Passed Contact Card ID")
        print(sender!)
        
        if segue.identifier == "activityFollowUpSegue"
        {
            
            let nextScene =  segue.destination as! FollowUpViewController
            
            nextScene.active_card_unify_uuid = "\(self.active_card_unify_uuid!)" as! String?
            
        }
        
        
        
        
        
    }

    
    @IBAction func followUpBtn_click(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "activityFollowUpSegue", sender: self)

    }

    
    
    


}
