//
//  Extensions.swift
//  SpookyPexels
//
//  Created by Gina De La Rosa on 10/17/20.
//

import Foundation
import UIKit

extension UIViewController {
    //Basic alert with message, title, and ok action.
    func customAlertWithTitle(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
