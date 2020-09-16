//
//  LocationSelectionViewController.swift
//  Unify
//


import UIKit
import GooglePlaces

class LocationSelectionViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // Properties
    // ----------------------------------
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let locationManager = CLLocationManager()

    
    // IBActions
    // ----------------------------------
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        delay(0.1) { self.searchController?.searchBar.becomeFirstResponder() }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        //resultsViewController?.autocompleteBounds = GMSCoordinateBounds()
        resultsViewController?.delegate = self
        
        // Set a filter to return only addresses.
        //let filter = GMSAutocompleteFilter()
        //filter.type = .address
        //filter.country = "US"

        //filter.country =
        
        
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
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            print("Location is updating")
            locationManager.startUpdatingLocation()
        }
        
        

    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //
        print(searchBar.text ?? "No text")
    }
    
    
    // Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        // Test
        print("Showing")
        
        self.searchController?.searchBar.becomeFirstResponder()
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        // Get text
        if self.searchController?.searchBar.text != ""{
            // Get text results
            print("My results", self.searchController?.searchBar.text ?? "Nothing in the box douy")
            
            // Set manager intent
            ContactManager.sharedManager.userArrivedFromLocationVC = true
            
            // Set manager location
            ContactManager.sharedManager.selectedLocation = self.searchController?.searchBar.text ?? ""
            
            print("Dismissmal here when keyboard down")
            
            // Drop the quickshare vc
            self.dismiss(animated: true, completion: {
                
                // Drop VC
                self.dismiss(animated: true, completion: nil)
                
            })
        }
        
    }
    
    // Location manager
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        // Set coordinate bounds
        //resultsViewController?.autocompleteBounds = GMSCoordinateBounds(locValue)
        
        // Set bounds to inner-west Sydney Australia.
        let neBoundsCorner = CLLocationCoordinate2D(latitude: locValue.latitude,
                                                    longitude: locValue.longitude)
        let swBoundsCorner = CLLocationCoordinate2D(latitude: locValue.latitude + 1,
                                                    longitude: locValue.longitude + 1)
        let bounds = GMSCoordinateBounds(coordinate: neBoundsCorner,
                                         coordinate: swBoundsCorner)
        
        print("The AutoComplete Bounds", bounds)
        
        // Add coordinate bounds
        resultsViewController?.autocompleteBounds = bounds
        
        resultsViewController?.setEditing(true, animated: true)
        
        
    }
    
    // Custom methods
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
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
        
        // Set manager
        ContactManager.sharedManager.selectedLocation = place.name
        
        // Set manager nav
        ContactManager.sharedManager.userArrivedFromLocationVC = true
        
        // Drop results controller
        self.dismiss(animated: true) { 
            // Drop the quickshare vc
            self.dismiss(animated: true, completion: nil)
        }
        
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
