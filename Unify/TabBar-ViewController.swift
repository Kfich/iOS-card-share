//
//  TabBar-ViewController.swift
//  Unify
//
//  Created by Ryan Hickman on 4/4/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import Foundation
import UIKit


class TabBarViewController: UITabBarController{
    
    // Properties
    // ----------------------------------------
    
    
    // IBOutlets
    // ----------------------------------------
    
    // Page Configuration
    // ----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.selectedIndex = 2
        
        
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = UIColor.white
        
        // Sets the default color of the background of the UITabBar
        //UITabBar.appearance().barTintColor = UIColor(rgb: 0x1B386F)
        
        // Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        UITabBar.appearance().selectionIndicatorImage = UIImage().makeImageWithColorAndSize(color: UIColor(rgb: 0x1F4181), size: CGSize(tabBar.frame.width/5, tabBar.frame.height))

        
        // Set tab bar icon images
        
        //self.tabBar.items?[0].selectedImage = resizeImage(image: UIImage(named: "introicon")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)
        //self.tabBar.items?[0].image = resizeImage(image: UIImage(named: "introicon")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)

        
        self.tabBar.items?[0].selectedImage = UIImage(named: "contact-full")
        self.tabBar.items?[0].image = UIImage(named: "contact")
        
        self.tabBar.items?[1].selectedImage = UIImage(named: "intro-full")
        self.tabBar.items?[1].image = UIImage(named: "intro")
        
        /*self.tabBar.items?[1].selectedImage = resizeImage(image: UIImage(named: "introicon")!, newWidth: 20)?.withRenderingMode(.automatic)
        self.tabBar.items?[1].image = resizeImage(image: UIImage(named: "introicon")!, newWidth: 20)?.withRenderingMode(.automatic)*/
        /*
        self.tabBar.items?[2].selectedImage = resizeImage(image: UIImage(named: "icn-location")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = resizeImage(image: UIImage(named: "icn-location")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)*/
        
        self.tabBar.items?[2].selectedImage = UIImage(named: "home-full")
        self.tabBar.items?[2].image = UIImage(named: "home")
        
        //self.tabBar.items?[2].selectedImage = UIImage(named: "icn-location")
        //self.tabBar.items?[2].image = UIImage(named: "icn-location")
        
        self.tabBar.items?[3].selectedImage = UIImage(named: "profile-full")
        self.tabBar.items?[3].image = UIImage(named: "profile")
        
        self.tabBar.items?[4].selectedImage = UIImage(named: "bell-full")
        self.tabBar.items?[4].image = UIImage(named: "bell")
        
       /* self.tabBar.items?[2].selectedImage = resizeImage(image: UIImage(named: "icn-location")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = resizeImage(image: UIImage(named: "icn-location")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)

        self.tabBar.items?[3].selectedImage = resizeImage(image: UIImage(named: "profile")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[3].image = resizeImage(image: UIImage(named: "profile")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)
        
        self.tabBar.items?[4].selectedImage = resizeImage(image: UIImage(named: "bell")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[4].image = resizeImage(image: UIImage(named: "bell")!, newWidth: 20)?.withRenderingMode(.alwaysOriginal)*/
        
        
    }
    
    
}

// Custom Methods

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}


extension UIImage {
    func makeImageWithColorAndSize(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
