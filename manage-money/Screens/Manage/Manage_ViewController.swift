//
//  Manage_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

class Manage_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbInOutMonney: UITableView!
    @IBOutlet weak var txtDate: UITextField!
    let datepickerView: UIDatePicker = UIDatePicker()
    
    var costs: [Dictionary<String, Any>]  = []
    var incomes: [Dictionary<String, Any>]  = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        txtDate.text = date
        tbInOutMonney.dataSource = self
        tbInOutMonney.delegate = self
        
        setDatePicker()
        datepickerView.frame = CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.size.width, height: 100)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataScreen()
    }
    
    
    @IBAction func onInOutClick(_ sender: Any) {
        getDataScreen()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costs.count + incomes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InOut") as! InOutMoney_TableViewCell
        if indexPath.row >= incomes.count {
            let index = indexPath.row - incomes.count
            cell.lbInOut.text = "Out"
            cell.lbName.text = costs[index]["name"] as! String
            cell.lbDate.text = costs[index]["date"] as! String
            cell.lbType.text = costs[index]["type"] as! String
            cell.lbMoney.text = convertCurrency(money: costs[index]["cost"] as! Double)
            
        } else {
            cell.lbInOut.text = "In"
            cell.lbName.text = incomes[indexPath.row]["name"] as! String
            cell.lbDate.text = incomes[indexPath.row]["date"] as! String
            cell.lbType.text = incomes[indexPath.row]["type"] as! String
            cell.lbMoney.text = convertCurrency(money: incomes[indexPath.row]["income"] as! Double)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func setIncomesToday()  {
        
        let url = URL(string: Constants.getIncomeByDate + txtDate.text!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                print("tbbbbb")
            } else if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data,  options: .mutableContainers) as! [String: Any]
                    
                    if(json["result"] as! Int == 1) {
                        DispatchQueue.main.sync {
                            let i =  json["data"] as!  [Dictionary<String, Any>]
                            self.incomes = i
                            self.tbInOutMonney.reloadData()
                        }
                    } else {
                        print("get Income by date failed")
                        
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }.resume()
        
    }
    
    func setCostsByTodayDate() {
        let url = URL(string: Constants.getCostByDate + txtDate.text!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                print(err?.localizedDescription)
            } else if let data = data {
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data,  options: .mutableContainers) as! [String: Any]
                    
                    if(json["result"] as! Int == 1) {
                        DispatchQueue.main.sync {
                            let i =  json["data"] as!  [Dictionary<String, Any>]
                            self.costs = i
                            self.tbInOutMonney.reloadData()
                        }
                    } else {
                        print("Get cost by date failed")
                        
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }.resume()
        
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
    
    func getDataScreen() {
        let token = UserDefaults.standard.string(forKey: "token")
        let username = UserDefaults.standard.string(forKey: "username")
        let avatar = UserDefaults.standard.string(forKey: "avatar")
        if let token = token, let username = username, let avatar = avatar  {
            checkAuthen()
            setIncomesToday()
            setCostsByTodayDate()
            
        } else {
            navigationToLogin()
            
        }
    }

}
