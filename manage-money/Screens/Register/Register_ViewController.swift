//
//  Register_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

extension UIViewController {
    func showSpinner(v: UIView) {
        let spinnerView = UIView.init(frame: v.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.center = spinnerView.center
        
        
    }
}

class Register_ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
 
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {
        txtUsername.text = "demo"
        txtPassword.text = "1234"
        txtPhone.text = "28357845"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegister(_ sender: Any) {
        print("on Register")
        uploadImageAndRegisterUser()
    }
    
    
    @IBAction func onTapAvatar(_ sender: UITapGestureRecognizer) {
        print("on Tap Imange")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgAvatar.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageAndRegisterUser()  {
        print("upload")
        var url = URL(string: Constants.uploadFileUrl)
        let boundary = UUID().uuidString
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
       urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"avatar-\(txtUsername.text!)\"; filename=\"avatar-\(txtUsername.text!).png\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append((imgAvatar.image?.pngData())!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, err in
            print("Upload task")
            if err == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String:Any] {
                    print(json)
                    if json["result"] as! Int == 1 {
                        let filename = json["filename"] as? String
                        print(filename)
                        DispatchQueue.main.async {
//                        var parameters = [
//                            "username": self.txtUsername.text,
//                            "password": self.txtPassword.text,
//                            "phone": self.txtPhone.text,
//                            "avatar": filename
//                        ]
                        url = URL(string: Constants.registerUrl)
                        var request = URLRequest(url: url!)
                        request.httpMethod = "POST"
//                        do {
//                            request.httpBody =  try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//                        } catch let err {
//                            print(err.localizedDescription)
//                        }
//                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//                        request.addValue("application/json", forHTTPHeaderField: "Accept")
                        let postData = "username=\(self.txtUsername.text!)&password=\(self.txtPassword.text!)&phone=\(self.txtPhone.text!)&avatar=\(filename!)".data(using: .utf8)
                            request.httpBody = postData
                        let taskRegister = URLSession.shared.dataTask(with: request) { data, response, err in
                            guard err == nil else { return }
                            guard let data = data else { return }
                            do {
                                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {return }
                                if json["result"] as? Int == 1 {
                                    DispatchQueue.main.sync {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                } else {
                                    print("Register faile")
                                    DispatchQueue.main.sync {
                                        let alertView = UIAlertController(title: "Infomation", message: "Register failed", preferredStyle: UIAlertController.Style.alert)
                                        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                                            self.navigationController?.popViewController(animated: true)
                                        }))
                                        self.present(alertView, animated: true, completion: nil)
                                    }
                                }
                            } catch let err {
                                print(err.localizedDescription)
                            }
                        }
                        taskRegister.resume()
                        }
                    }
                    
                }
                
            } else {
                print(err?.localizedDescription)
            }
            
        }).resume()
    }
    
}
