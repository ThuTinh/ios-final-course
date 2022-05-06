//
//  AddIncome_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 01/05/2022.
//

import UIKit

class AddIncome_ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtIncome: UITextField!
    @IBOutlet weak var txtType: UITextField!
    
    weak var pickerView: UIPickerView?
    let datepickerView: UIDatePicker = UIDatePicker()
    
    var names = ["Salary", "Others"]
    var types = ["NEC", "PLAY", "EDU", "FFA", "LTSS", "GIVE", "ALL"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtIncome.keyboardType = .asciiCapableNumberPad
        datepickerView.frame = CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.size.width, height: 100)
        setDatePicker()
        //allow tap on screen to remove text field input from screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //UIPICKER
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtName.delegate = self
        txtType.delegate = self
        
        txtName.inputView = pickerView
        txtType.inputView = pickerView
        
        //It is important that goes after de inputView assignation
        self.pickerView = pickerView
        

    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView?.reloadAllComponents()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if txtName.isFirstResponder{
               return names.count
           } else if txtType.isFirstResponder{
               return types.count
           }
               return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if txtName.isFirstResponder{
               return names[row]
           }else if txtType.isFirstResponder{
               return types[row]
           }
           return nil
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if txtName.isFirstResponder{
               let itemselected = names[row]
               txtName.text = itemselected
           }else if txtType.isFirstResponder{
               let itemselected = types[row]
               txtType.text = itemselected
           }
       }
    
    func setDatePicker() {
        //Format Date
        datepickerView.datePickerMode = .date

        //ToolBar
        let toolbar = UIToolbar();
        toolbar.frame = CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.size.width, height: 100)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//        datepickerView.center.x = toolbar.center.x
        txtDate.inputAccessoryView = toolbar
        txtDate.inputView = datepickerView
    }

    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDate.text = formatter.string(from: datepickerView.date)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }

    
    @IBAction func onAddIncome(_ sender: Any) {
        let name = txtName.text
        let type = txtType.text
        let income = Int(txtIncome.text!)
        let date = txtDate.text
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""

        let url = URL(string: Constants.addIncome)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postData = "name=\(name!)&date=\(date!)&type=\(type!)&income=\(income!)&username=\(username)".data(using: .utf8)
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                DispatchQueue.main.sync {
                    let alertView = UIAlertController(title: "Infomation", message: "Add income failed", preferredStyle: UIAlertController.Style.alert)
                    alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alertView, animated: true, completion: nil)
                }

            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data,  options: .mutableContainers) as! [String: Any]
                    if json["result"] as! Int == 1 {
                        
                        DispatchQueue.main.sync {
                            let alertView = UIAlertController(title: "Infomation", message: "Add income Success ", preferredStyle: UIAlertController.Style.alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alertView, animated: true, completion: nil)
                            self.txtName.text = ""
                            self.txtType.text = ""
                            self.txtDate.text = ""
                            self.txtIncome.text = ""
                        }
                        
                    } else {
                        DispatchQueue.main.sync {
                            let alertView = UIAlertController(title: "Infomation", message: "Add income failed", preferredStyle: UIAlertController.Style.alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                } catch let err {
                    DispatchQueue.main.sync {
                        let alertView = UIAlertController(title: "Infomation", message: "Add income failed", preferredStyle: UIAlertController.Style.alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        }.resume()
   
    }
}
