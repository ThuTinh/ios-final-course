//
//  ReportExpense_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 01/05/2022.
//

import UIKit

class ReportExpense_ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    

    @IBOutlet weak var tbReport: UITableView!
    @IBOutlet weak var tbHeader: UIView!
    
    
    @IBOutlet weak var lbTotalMustHave: UILabel!
    @IBOutlet weak var lbTotalNiceTohave: UILabel!
    @IBOutlet weak var lbTotalWasted: UILabel!
    
    var costs: [Dictionary<String, Any>]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbReport.delegate = self
        tbReport.dataSource = self
        getCostByMonth()

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
        case "NICE_TO_HAVE":
            cell.lbNiceToHave.text = money
        default:
            cell.lbWasted.text = money
        }
        return cell
    }
    
    func getCostByMonth() {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let year = components.year
        let month = components.month
        
        let url = URL(string: Constants.getCostByMonth + "\(month!)/\(year!)")
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
                            self.tbReport.reloadData()
                            print(i[0]["name"]!)
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
    
}
