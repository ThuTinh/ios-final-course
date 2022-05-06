//
//  AddExpense_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 01/05/2022.
//

import UIKit

class AddExpense_ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtWallet: UITextField!
    @IBOutlet weak var txtCost: UITextField!
    @IBOutlet weak var txtCostType: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    weak var pickerView: UIPickerView?
    let datepickerView: UIDatePicker = UIDatePicker()
    
    var names = ["Shopping","Cafe" ,"Others"]
    var wallets = ["NEC", "PLAY", "EDU", "FFA", "LTSS", "GIVE", "ALL"]
    var costTypes = ["MUST_HAVE", "NICE_TO_HAVE", "WASTED"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        txtCost.keyboardType = .asciiCapableNumberPad
        datepickerView.frame = CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.size.width, height: 100)
        
        //allow tap on screen to remove text field input from screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //UIPICKER
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtName.delegate = self
        txtWallet.delegate = self
        txtCostType.delegate = self
        
        txtName.inputView = pickerView
        txtWallet.inputView = pickerView
        txtCostType.inputView = pickerView
        
        self.pickerView = pickerView
        
    }
    
    
    @IBAction func onAddExpense(_ sender: Any) {
        let name = txtName.text
        let costType = txtCostType.text
        let cost = Int(txtCost.text!)
        let date = txtDate.text
        let wallet = txtWallet.text
        let username = UserDefaults.standard.string(forKey: "username") ?? ""
        let token = UserDefaults.standard.string(forKey: "token") ?? ""

        let url = URL(string: Constants.addExpense)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postData = "name=\(name!)&date=\(date!)&costType=\(costType!)&cost=\(cost!)&username=\(username)&type=\(wallet!)".data(using: .utf8)
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                DispatchQueue.main.sync {
                    let alertView = UIAlertController(title: "Infomation", message: "Add Expense failed", preferredStyle: UIAlertController.Style.alert)
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
                            let alertView = UIAlertController(title: "Infomation", message: "Add Expense Success ", preferredStyle: UIAlertController.Style.alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alertView, animated: true, completion: nil)
                            self.txtName.text = ""
                            self.txtCostType.text = ""
                            self.txtDate.text = ""
                            self.txtCost.text = ""
                            self.txtWallet.text = ""
                        }
                        
                    } else {
                        DispatchQueue.main.sync {
                            let alertView = UIAlertController(title: "Infomation", message: "Add Expense failed", preferredStyle: UIAlertController.Style.alert)
                            alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alertView, animated: true, completion: nil)
                        }
                    }
                } catch let err {
                    DispatchQueue.main.sync {
                        let alertView = UIAlertController(title: "Infomation", message: "Add Expense failed", preferredStyle: UIAlertController.Style.alert)
                        alertView.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action : UIAlertAction!) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        }.resume()
   
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
           } else if txtCostType.isFirstResponder{
               return costTypes.count
           } else if txtWallet.isFirstResponder {
               return wallets.count
           }
               return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           if txtName.isFirstResponder{
               return names[row]
           }else if txtCostType.isFirstResponder{
               return costTypes[row]
           } else if txtWallet.isFirstResponder {
               return wallets[row]
           }
           return nil
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           if txtName.isFirstResponder{
               let itemselected = names[row]
               txtName.text = itemselected
           }else if txtCostType.isFirstResponder{
               let itemselected = costTypes[row]
               txtCostType.text = itemselected
           } else if txtWallet.isFirstResponder {
               let itemselected = wallets[row]
               txtWallet.text = itemselected
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


}
