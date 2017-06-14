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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multivalued Examples"
        form +++
                MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Basic Info",
                                   footer: "") {
                                    $0.addButtonProvider = { section in
                                        return ButtonRow(){
                                            $0.title = "Add Basic Info"
                                            }.cellUpdate { cell, row in
                                                cell.textLabel?.textAlignment = .left
                                        }
                                    }
                                    $0.multivaluedRowToInsertAt = { index in
                                        return NameRow() {
                                            $0.placeholder = "Basic info"
                                        }
                                    }
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Name"
                                    }
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Email"
                                    }
                                    $0 <<< NameRow() {
                                        $0.placeholder = "Phone"
                                    }
                                    
                                    
                                    
        }
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Bio",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Bio Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Bio"
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Bio"
                                }
            }
            
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Work Info",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Work Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Work info"
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Work info"
                                }
        }
        
            +++
            
            MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                               header: "Social Media Links",
                               footer: "") {
                                $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add Media Info"
                                        }.cellUpdate { cell, row in
                                            cell.textLabel?.textAlignment = .left
                                    }
                                }
                                $0.multivaluedRowToInsertAt = { index in
                                    return NameRow() {
                                        $0.placeholder = "Link"
                                    }
                                }
                                $0 <<< NameRow() {
                                    $0.placeholder = "Link"
                                }
        }

    }
}
