//
//  Manage_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

class Manage_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbInOutMonney: UITableView!
    var costs: [Dictionary<String, Any>]  = []
    var incomes: [Dictionary<String, Any>]  = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbInOutMonney.dataSource = self
        tbInOutMonney.delegate = self
        setIncomesToday()
        setCostsByTodayDate()

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
            cell.lbMoney.text = String(costs[index]["cost"] as! Double)
            
        } else {
            cell.lbInOut.text = "In"
            cell.lbName.text = incomes[indexPath.row]["name"] as! String
            cell.lbDate.text = incomes[indexPath.row]["date"] as! String
            cell.lbType.text = incomes[indexPath.row]["type"] as! String
            cell.lbMoney.text = String(incomes[indexPath.row]["income"] as! Double)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func setIncomesToday()  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let url = URL(string: Constants.getIncomeByDate + date)
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
                            print(i[0]["name"]!)
                        }
                    } else {
                        print("tb")
                        
                    }
                } catch let err {
                    print("tbb")
                }
            }
            
        }.resume()
        
    }
    
    func setCostsByTodayDate() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: Date())
        
        let url = URL(string: Constants.getCostByDate + date)
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
                            self.costs = i
                            self.tbInOutMonney.reloadData()
                            print(i[0]["costType"]!)
                        }
                    } else {
                        print("tb")
                        
                    }
                } catch let err {
                    print("tbb")
                }
            }
            
        }.resume()
        
    }
    
    

}
