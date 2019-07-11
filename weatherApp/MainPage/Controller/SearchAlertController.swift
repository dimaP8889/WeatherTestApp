//
//  AlertController.swift
//  weatherApp
//
//  Created by Dmytro Pogrebniak on 7/10/19.
//  Copyright © 2019 Dmytro Pogrebniak. All rights reserved.
//

import Foundation
import UIKit

protocol SearchAlertProtocol {
    
    func presentAlert()
}

class SearchAlert : SearchAlertProtocol {
    
    private let delegate : UIViewController
    private let action : (String?)->()
    private var alert : UIAlertController?
    
    init(vc : UIViewController, action : @escaping (String?) -> ()) {
        
        self.delegate = vc
        self.action = action
        createAlert()
    }
    
    private func createAlert() {
        
        alert = UIAlertController(title: "Add city", message: "Type city to add it", preferredStyle: .alert) // create alert controller
        let action = UIAlertAction(title: "Add", style: .default) { (alertAction) in // add action
            
            guard let textField = self.alert?.textFields![0] else { return } // text from textField
            self.action(textField.text)
        }
        alert?.addTextField { (textField) in // add placeholder
            textField.placeholder = "Enter city"
        }
        
        alert?.addAction(action) // add action
    }
    
    func presentAlert() {
        
        guard let presentAlert = alert else { return }
        delegate.present(presentAlert, animated: true, completion: nil)
    }
}
