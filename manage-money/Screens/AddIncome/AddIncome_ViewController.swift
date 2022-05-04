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
//    let datepickerView: UIDatePicker = UIDatePicker()
    
    var names = ["Salary", "Others"]
    var types = ["NEC", "PLAY", "EDU", "FFA", "LTSS", "GIVE", "ALL"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setDatePicker()
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
    
//    func setDatePicker() {
//        //Format Date
//        datepickerView.datePickerMode = .date
//
//        //ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
//
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
//
//        txtDate.inputAccessoryView = toolbar
//        txtDate.inputView = datepickerView
//    }
//
//    @objc func doneDatePicker(){
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy"
//        txtDate.text = formatter.string(from: datepickerView.date)
//        self.view.endEditing(true)
//    }
//
//    @objc func cancelDatePicker(){
//        self.view.endEditing(true)
//    }
}
