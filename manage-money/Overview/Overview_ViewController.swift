//
//  Overview_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

class Overview_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let token = UserDefaults.standard.string(forKey: "token")
        if let userToken = token {
            print("User logged")
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginController = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(loginController, animated: true)
        }
        
    }
    

}
