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
    
    var count = 0
    
    // IBOutlets
    // ----------------------------------
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign profile image val
        
        
        
        // Parse card for profile info
        
        // Parse bio info
         if currentUser.userProfile.bios.count > 0{
            // Iterate throught array and append available content
            for bio in currentUser.userProfile.bios{
                bios.append(bio["bio"]!)
            }
         }
        // Parse work info
         if currentUser.userProfile.workInformationList.count > 0{
            for info in currentUser.userProfile.workInformationList{
                workInformation.append(info["info"]!)
            }
         }
         if currentUser.userProfile.phoneNumbers.count > 0{
            for number in currentUser.userProfile.phoneNumbers{
                phoneNumbers.append(number["phone"]!)
            }
         }
        // Parse emails
         if currentUser.userProfile.emails.count > 0{
            for email in currentUser.userProfile.phoneNumbers{
                emails.append(email["email"]!)
            }
         }
        // Parse websites
         if currentUser.userProfile.websites.count > 0{
            for site in currentUser.userProfile.websites{
                websites.append(site["website"]!)
            }
         }
        // Parse organizations
         if currentUser.userProfile.organizations.count > 0{
            for org in currentUser.userProfile.organizations{
                organizations.append(org["organization"]!)
            }
         }
        // Parse Tags
         if currentUser.userProfile.tags.count > 0{
            for hashtag in currentUser.userProfile.tags{
                tags.append(hashtag["tag"]!)
            }
         }
        // Parse notes
         if currentUser.userProfile.notes.count > 0{
            for note in currentUser.userProfile.notes{
                notes.append(note["note"]!)
            }
         }
        // Parse socials links
         if currentUser.userProfile.socialLinks.count > 0{
            for link in currentUser.userProfile.socialLinks{
                notes.append(link["link"]!)
            }
         }
        

        
        // Really, we parse the card and profile infos to extract the list
        // Fill profile with example info
       
        /*emails = ["example@gmail.com", "test@aol.com", "sample@gmail.com" ]
        phoneNumbers = ["1234567890", "6463597308", "3036558888"]
        socialLinks = ["facebook-link", "snapchat-link", "insta-link"]
        organizations = ["crane.ai", "Example Inc", "Sample LLC", "Boys and Girls Club"]
        bios = ["Created a company for doing blank for example usecase", "Full Stack Engineer at Crane.ai", "College Professor at the University of Application Building"]
        websites = ["example.co", "sample.ai", "excuse.me"]
        titles = ["Entrepreneur", "Salesman", "Full Stack Engineer"]
        workInformation = ["Job 1", "Job 2", "Example Job", "Sample Job"]*/
        
        
        
        title = "Multivalued Examples"
        form +++
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete], header: "Bio Information", footer: "") {
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Bio Info"
                                            //$0.tag = "Add Bio"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow("bioRow_\(index)") {
                                            $0.placeholder = "Bio"
                                            self.count = self.count + 1
                                            //$0.tag = "Add Bio"
                                            
                                        }
                                    }
                    
                                    // Iterate through array and set val
                                    /*
                                    for val in bios{
                                        $0 <<< NameRow("bio_\(count+=1)") {
                                         $0.placeholder = "Bio"
                                        $0.value = val
                                        //$0.tag = "Add Bio"
                                         }
                                    }*/
                
                    
                                    
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Titles",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Title"
                                        //$0.tag = "Add Titles"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("titlesRow_\(index)") {
                                        $0.placeholder = "Title"
                                    }
                                }
                                // Iterate through array and set val
                                /*for val in titles{
                                $0 <<< NameRow("title_\(count+1)") {
                                    $0.placeholder = "Title"
                                    $0.value = val
                                }
                                }*/
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Phone Numbers",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Phone Numbers"
                                        //$0.tag = "Phone Numbers"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("numbersRow_\(index)") {
                                        $0.placeholder = "Number"
                                        //$0.tag = "Phone Numbers"
                                    }
                                }
                                // Iterate through array and set val
                                /*for val in phoneNumbers{
                                    $0 <<< NameRow() {
                                     $0.placeholder = "Number"
                                        $0.value = val
                                        //$0.tag = "Phone Numbers"
                                     }
                                }*/
                                
            }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Email Addresses",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Email"
                                        //$0.tag = "Add Emails"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("emailsRow_\(index)") {
                                        $0.placeholder = "Address"
                                        //$0.tag = "Add Emails"
                                    }
                                }
                                
                                // Iterate through array and set val
                               /* for val in emails{
                                    $0 <<< NameRow() {
                                    $0.placeholder = "Address"
                                    //$0.tag = "Add Emails"
                                    $0.value = val
                                  }
                                }*/
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Work Info",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Work Info"
                                        //$0.tag = "Add Work Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("workRow_\(index)") {
                                        $0.placeholder = "Work info"
                                        //$0.tag = "Add Work Info"
                                    }
                                }
                                // Iterate through array and set val
                                /*for val in workInformation{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Work info"
                                        $0.value = val
                                        //$0.tag = "Add Work Info"
                                    }
                                }*/
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Websites",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Websites"
                                        //$0.tag = "Add Websites"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("websitesRow_\(index)") {
                                        $0.placeholder = "Site"
                                        //$0.tag = "Add Websites"
                                    }
                                }
                                // Iterate through array and set val

                               /* for val in websites{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Site"
                                        $0.value = val
                                        //$0.tag = "Add Websites"
                                }
                            }*/
                }
        
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Social Media Links",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Media Info"
                                        //$0.tag = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("socialLinkRow_\(index)") {
                                        $0.placeholder = "Link"
                                        //$0.tag = "Add Media Info"
                                    }
                                }
                                
                                // Iterate through array and set val
                               /* for val in socialLinks{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Link"
                                        $0.value = val
                                        //$0.tag = "Add Media Info"
                                   }
                                }*/
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Organizations",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Organizations"
                                        //$0.tag = "Add Organizations"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow("organizationRow_\(index)") {
                                        $0.placeholder = "Name"
                                        $0.tag = "Add Organizations"
                                    }
                                }
                                
                                // Iterate through array and set val
                               /* for val in organizations{
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Name"
                                        $0.value = val
                                        //$0.tag = "Add Organizations"
                                        
                                }
                            }*/
                
        }
        
        

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let values = form.values()
        
        
        //let vals = form.values()
        
        
        
        print(values)
        
        //print("The Form Values ")
        print(values)
        // Assign all the items in each list to the contact profile on manager 
        /*
        for bio in bios {
            print("Bio --> \(bio)")
        }
        for work in workInformation {
            print("Work --> \(work)")
        }
        for org in organizations {
            print("Orgs --> \(bio)")
        }
        for bio in bios {
            print("Bio --> \(bio)")
        }
        for bio in bios {
            print("Bio --> \(bio)")
        }*/
        
    }
    
    
    
    
    
    
    
    
    
    
}
