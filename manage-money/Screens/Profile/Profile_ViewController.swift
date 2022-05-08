//
//  Profile_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

class Profile_ViewController: UIViewController {

    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        imgAvatar.layer.borderWidth = 1
        imgAvatar.layer.masksToBounds = false
        imgAvatar.layer.borderColor = UIColor.black.cgColor
        imgAvatar.layer.cornerRadius = imgAvatar.frame.height/2
        imgAvatar.clipsToBounds = true
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let token = UserDefaults.standard.string(forKey: "token")
        let username = UserDefaults.standard.string(forKey: "username")
        let avatar = UserDefaults.standard.string(forKey: "avatar")
        if let token = token, let username = username, let avatar = avatar  {
            checkAuthen()
            lbUsername.text = username
            print(Constants.host + "/" + avatar)
            imgAvatar.imageFrom(url: URL(string: Constants.host + "/" + avatar)!)
   
        } else {
            navigationToLogin()
        }
    }
    
    @IBAction func onLogout(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "avatar")
        self.navigationToLogin()
    }
}



extension UIImageView{
  func imageFrom(url:URL){
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url){
        if let image = UIImage(data:data){
          DispatchQueue.main.async{
            self?.image = image
          }
        }
      }
    }
  }
}
