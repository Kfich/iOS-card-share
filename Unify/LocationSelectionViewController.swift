//
//  LocationSelectionViewController.swift
//  Unify
//
//  Created by Kevin Fich on 10/1/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSelectionViewController: UIViewController, UISearchBarDelegate {
    
    // Properties
    // ----------------------------------
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    // IBActions
    // ----------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: self.view.frame.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        
        // Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //
        print(searchBar.text ?? "No text")
    }
    
    
    // Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        // Test
        print("Showing")
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // Get text
        if self.searchController?.searchBar.text != ""{
            // Get text results
            print("My results", self.searchController?.searchBar.text ?? "Nothing in the box douy")
            
            // Set manager intent
            ContactManager.sharedManager.userArrivedFromLocationVC = true
            
            print("Dismissmal here when keyboard down")
            
            // Drop the quickshare vc
            self.dismiss(animated: true, completion: {
                
                // Drop VC
                self.dismiss(animated: true, completion: nil)
                
            })
        }
        
    }
    
    
    
    
}

// Handle the user's selection.
extension LocationSelectionViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
        
        
        
        self.searchController?.dismiss(animated: true, completion: {
            print("figured it out")
        })
        
        //self.navigationController?.popViewController(animated: true)
        
        //dismiss(animated: true, completion: nil)
        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        //
     
        return true
    }
    
    
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        // Complete action if search hit
        
        print("Search button hit >> Text", searchBar.text ?? "")
        
    }
    
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        
        print("An error here")
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
