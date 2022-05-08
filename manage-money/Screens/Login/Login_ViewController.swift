//
//  Login_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

class Login_ViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        txtPassword.isSecureTextEntry = true
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        let url = URL(string: Constants.loginUrl)
        var request =  URLRequest(url: url!)
        request.httpMethod = "POST"
        let data = "password=\(txtPassword.text!)&username=\(txtUsername.text!)".data(using: .utf8)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                print(err?.localizedDescription ?? "Login failed")
                return
            } else {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                        if(json["result"] as! Int == 1) {
                            print("user login succesful: \(json["token"] as! String)")
                            UserDefaults.standard.set(json["token"]! as! String,forKey: "token")
                            UserDefaults.standard.set(json["username"]! as! String,forKey: "username")
                            UserDefaults.standard.set(json["avatar"]! as! String,forKey: "avatar")
                            DispatchQueue.main.sync {
                                self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            print(json["data"] as! String)
                            DispatchQueue.main.sync {
                                let alertView = UIAlertController(title: "Infomation", message: "Login failed", preferredStyle: UIAlertController.Style.alert)
                                alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                                    self.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alertView, animated: true, completion: nil)
                            }
                        }
                    } catch let err {
                        print(err.localizedDescription)
                    }
                }
            }
        }.resume()
    }

    @IBAction func clickRegister(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let registerController = sb.instantiateViewController(withIdentifier: "REGISTER") as! Register_ViewController
        self.navigationController?.pushViewController(registerController, animated: true)
    }
}
