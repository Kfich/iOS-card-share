//
//  EditProfileContainerViewController.swift
//  Unify
//
//  Created by Kevin Fich on 6/13/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka

class EditProfileContainerViewController: FormViewController {
    
    // Properties
    // ----------------------------------
    
    var currentUser = User()
    
    // Parsed profile arrays
    var bios = [String]()
    var workInformation = [String]()
    var organizations = [String]()
    var titles = [String]()
    var phoneNumbers = [String]()
    var emails = [String]()
    var websites = [String]()
    var socialLinks = [String]()
    var notes = [String]()
    var tags = [String]()
    
    
    // IBOutlets
    // ----------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign profile image val
        
        
        
        // Parse card for profile info
        
        /*
         if card.cardProfile.bio != ""{
         bios.append(card.cardProfile.bio!)
         }
         if card.cardProfile.workInfo != ""{
         workInformation.append(card.cardProfile.bio!)
         }
         if card.cardProfile.phoneNumbers.count > 0{
         for number in card.cardProfile.phoneNumbers{
         phoneNumbers.append(number["phone"]!)
         }
         }
         if card.cardProfile.emails.count > 0{
         for email in card.cardProfile.phoneNumbers{
         emails.append(email["email"]!)
         }
         }
         if card.cardProfile.websites.count > 0{
         for site in card.cardProfile.websites{
         websites.append(site["website"]!)
         }
         }
         if card.cardProfile.organizations.count > 0{
         for org in card.cardProfile.organizations{
         organizations.append(org["organization"]!)
         }
         }
         if card.cardProfile.tags.count > 0{
         for hashtag in card.cardProfile.tags{
         tags.append(hashtag["tag"]!)
         }
         }
         if card.cardProfile.notes.count > 0{
         for note in card.cardProfile.notes{
         notes.append(note["note"]!)
         }
         }
         if card.cardProfile.socialLinks.count > 0{
         for link in card.cardProfile.socialLinks{
         notes.append(link["link"]!)
         }
         }
         */

        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
        emails = ["example@gmail.com", "test@aol.com", "sample@gmail.com" ]
        phoneNumbers = ["1234567890", "6463597308", "3036558888"]
        socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
        organizations = ["crane.ai", "Example Inc", "Sample LLC", "Boys and Girls Club"]
        bios = ["Created a company for doing blank for example usecase", "Full Stack Engineer at Crane.ai", "College Professor at the University of Application Building"]
        websites = ["example.co", "sample.ai", "excuse.me"]
        titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
        workInformation = ["Job 1", "Job 2", "Example Job", "Sample Job"]
        
        
        
        title = "Multivalued Examples"
        form +++
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "Bio Information", footer: "") {
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Bio Info"
                                            $0.tag = "Add Bio"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow() {
                                            $0.placeholder = "Bio"
                                            
                                        }
                                    }
                    
                                    // Iterate through array and set val
                                    for val in bios{
                                        $0 <<< NameRow() {
                                         $0.placeholder = "Bio"
                                        $0.value = val
                                         }
                                    }
                    
                                    
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Titles",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Title"
                                        $0.tag = "Add Titles"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Title"
                                    }
                                }
                                // Iterate through array and set val
                                for val in titles{
                                $0 <<< NameRow() {
                                    $0.placeholder = "Title"
                                    $0.value = val
                                }
                                }
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Phone Numbers",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Phone Numbers"
                                        $0.tag = "Phone Numbers"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Number"
                                    }
                                }
                                // Iterate through array and set val
                                for val in phoneNumbers{
                                    $0 <<< NameRow() {
                                     $0.placeholder = "Number"
                                        $0.value = val
                                     }
                                }
                                
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Email Addresses",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Email"
                                        $0.tag = "Add Emails"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Address"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in emails{
                                    $0 <<< NameRow() {
                                    $0.placeholder = "Address"
                                    $0.value = val
                                  }
                                }
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Work Info",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Work Info"
                                        $0.tag = "Add Work Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Work info"
                                    }
                                }
                                // Iterate through array and set val
                                for val in workInformation{
                                    $0 <<< NameRow() {
                                     $0.placeholder = "Work info"
                                        $0.value = val
                                    }
                                }
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Websites",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Websites"
                                        $0.tag = "Add Websites"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Site"
                                    }
                                }
                                // Iterate through array and set val

                                for val in websites{
                                    $0 <<< NameRow() {
                                    $0.placeholder = "Site"
                                        $0.value = val
                                }
                            }
                }
        
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Social Media Links",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Media Info"
                                        $0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Link"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in socialLinks{
                                    $0 <<< NameRow() {
                                    $0.placeholder = "Link"
                                    $0.value = val
                                   }
                                }
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Organizations",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Organizations"
                                        $0.tag = "Add Organizations"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Name"
                                    }
                                }
                                
                                // Iterate through array and set val
                                for val in organizations{
                                    $0 <<< NameRow() {
                                    $0.placeholder = "Name"
                                    $0.value = val
                                        
                                }
                            }
                
        }
        
        

    }
}
