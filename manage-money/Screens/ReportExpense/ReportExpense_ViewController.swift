//
//  ReportExpense_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 01/05/2022.
//

import UIKit

class ReportExpense_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tbReport: UITableView!
    @IBOutlet weak var tbHeader: UIView!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var lbTotalMustHave: UILabel!
    @IBOutlet weak var lbTotalNiceTohave: UILabel!
    @IBOutlet weak var lbTotalWasted: UILabel!
    
    weak var pickerView: UIPickerView?
    
    var costs: [Dictionary<String, Any>]  = []
    var months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbReport.delegate = self
        tbReport.dataSource = self
        
        //allow tap on screen to remove text field input from screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        //UIPICKER
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        txtMonth.delegate = self
        txtMonth.inputView = pickerView
        self.pickerView = pickerView
        
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        txtMonth.text = "\(components.month!)"
        getCostByMonth(month: components.month ?? 1)

    }
    
    
    @IBAction func onReport(_ sender: Any) {
        var month = Int(txtMonth.text!) ?? 1
       self.getCostByMonth(month: month)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return costs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! Report_TableViewCell
        cell.lbContent.text = costs[indexPath.row]["name"] as! String
        cell.lbDate.text = costs[indexPath.row]["date"] as! String
        let typeCost = costs[indexPath.row]["costType"] as! String
        let money = convertCurrency(money: costs[indexPath.row]["cost"] as! Double)
        switch typeCost {
            case "MUST_HAVE":
            cell.lbMustHave.text = money
            cell.lbNiceToHave.text = ""
            cell.lbWasted.text = ""

        case "NICE_TO_HAVE":
            cell.lbNiceToHave.text = money
            cell.lbMustHave.text = ""
            cell.lbWasted.text = ""
        default:
            cell.lbWasted.text = money
            cell.lbNiceToHave.text = ""
            cell.lbMustHave.text = ""
        }
        return cell
    }
    
    func getCostByMonth(month: Int) {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year
        
        let url = URL(string: Constants.getCostByMonth + "\(month)/\(year!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                print(err?.localizedDescription)
            } else if let data = data {
                print("Test : \(month) , \(data)")
      
                do {
                    let json = try JSONSerialization.jsonObject(with: data,  options: .mutableContainers) as! [String: Any]
                    
                    if(json["result"] as! Int == 1) {
                        DispatchQueue.main.sync {
                            let i =  json["data"] as!  [Dictionary<String, Any>]
                            self.costs = i
                            var totalWasted = 0.0
                            var totalNiceToHave = 0.0
                            var totalMustHave = 0.0
                            i.forEach { c in
                                let typeCost = c["costType"] as! String
                                let money =  c["cost"] as! Double
                                switch typeCost {
                                    case "MUST_HAVE":
                                    totalMustHave += money
                                case "NICE_TO_HAVE":
                                    totalNiceToHave += money
                                default:
                                    totalWasted += money
                                }
                            }
                            self.lbTotalWasted.text = self.convertCurrency(money: totalWasted)
                            self.lbTotalMustHave.text = self.convertCurrency(money: totalMustHave)
                            self.lbTotalNiceTohave.text = self.convertCurrency(money: totalNiceToHave)
                            self.tbReport.reloadData()
                            
                        }
                    } else {
                        print("Get cost by month failed")
                        
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
            
        }.resume()
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return "\(months[row])"
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           txtMonth.text = "\(months[row])"
       }
    
}
