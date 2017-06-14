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
    
    let card1 = BusinessCardView()
    let card2 = BusinessCardView()
    let card3 = BusinessCardView()
    
    var cards = [BusinessCardView()]
    //cards = [card1, card2, card3]

    
    // IBOutlets
    // ----------------------------------------
    
    // IBActions / Buttons pressed
    // ----------------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject){
    

        dismiss(animated: true, completion: nil)
    }
    
    // Page Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configure done button in nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCards))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // CollectionView DataSource && Delegate
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return self.cards.count
        return 4
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! CardCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.businessCardView = self.cards[indexPath.item]
        // Add radius config & border color
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.clipsToBounds = true
        cell.contentView.layer.borderWidth = 2.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    // Custom methods
    // ------------------------------------
    
    func addCards() {
        // Show alert view with form fields
        print("Add card button works!")
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
