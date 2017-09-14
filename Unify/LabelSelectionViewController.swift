//
//  LabelSelectionViewController.swift
//  Unify
//
//  Created by Kevin Fich on 9/13/17.
//  Copyright © 2017 Crane by Elly. All rights reserved.
//

import UIKit
import Eureka

class LabelSelectionViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multivalued examples"
        form +++
            Section("Select Label")
            <<< ButtonRow(){
                $0.title = "Home"
                
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                
                }.onCellSelection({ (cell, row) in
                self.dismiss(animated: true, completion: { 
                    // Print to test
                    print("Home selected")
                })
            })
            <<< ButtonRow(){
                $0.title = "Work"
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    
                }.onCellSelection({ (cell, row) in
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Work selected")
                    })
                })
            <<< ButtonRow(){
                $0.title = "Personal"
                
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    
                }.onCellSelection({ (cell, row) in
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Personal selected")
                    })
                })
            <<< ButtonRow(){
                $0.title = "Mobile"
        
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    
                }.onCellSelection({ (cell, row) in
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Mobile selected")
                    })
                })
            <<< ButtonRow(){
                $0.title = "Other"
                
                }.cellUpdate { cell, row in
                    cell.textLabel?.textAlignment = .left
                    
                }.onCellSelection({ (cell, row) in
                    self.dismiss(animated: true, completion: {
                        // Print to test
                        print("Other selected")
                    })
                })

    }
    
    
}

