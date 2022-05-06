//
//  Overview_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit
import FLCharts

class Overview_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    @IBOutlet weak var tbWallet: UITableView!
    
    @IBOutlet weak var chartView: UIView!
    
    @IBOutlet weak var lbIncome: UILabel!
    
    @IBOutlet weak var lbCost: UILabel!
    
    @IBOutlet weak var lbSum: UILabel!
    
    var data: [Dictionary<String, Any>] = []
    
    var dataChart: Dictionary<String, Any> = Dictionary<String, Any>()
    
    var pieChart = FLPieChart(title: "Platforms",
                                     data: [FLPiePlotable(value: 50, key: Key(key: "Cost", color: FLColor(hex: "f54242"))),
                                            FLPiePlotable(value: 50, key: Key(key: "Income", color: FLColor(hex: "21b024")))],
                                     border: .full,
                                     formatter: .percent,
                                     animated: true)
    
    override func viewDidLoad() {
       
        tbWallet.delegate = self
        tbWallet.dataSource  = self
        getWallets()
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let token = UserDefaults.standard.string(forKey: "token")
        if let userToken = token {
            chartView.addSubview(pieChart)
            self.pieChart.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.pieChart.centerYAnchor.constraint(equalTo: chartView.centerYAnchor),
                self.pieChart.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
                self.pieChart.heightAnchor.constraint(equalToConstant: 100),
                self.pieChart.widthAnchor.constraint(equalToConstant: 100)
            ])
            getDataChart()
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginController = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(loginController, animated: true)
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell") as! WalletCell_TableViewCell
        cell.lbWalletType.text = data[indexPath.row]["type"] as! String
        cell.lbAmount.text = String(data[indexPath.row]["total"] as! Double)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func getWallets(){
        let url = URL(string: Constants.getWallets)
        var request = URLRequest(url: url!)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                print(err?.localizedDescription)
            } else if let data = data {
                do {
                    let json =   try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                    DispatchQueue.main.async {
                        self.data = json["data"] as! [Dictionary<String, Any>]
                        self.tbWallet.reloadData()
                        print(self.data)
                    }
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }.resume()
    }
    
    func getDataChart(){
        let url = URL(string: Constants.getDataChart)
        var request = URLRequest(url: url!)
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, err in
            if err != nil {
                print(err?.localizedDescription)
            } else if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any]
                    if(json["result"] as! Int == 1) {
                        DispatchQueue.main.async {
                            self.dataChart = json["data"] as! [String: Any]
                            self.lbIncome.text = String(self.dataChart["income"] as! Double)
                            self.lbCost.text = String(self.dataChart["cost"] as! Double)
                            let total = (self.dataChart["income"] as! Double) + (self.dataChart["cost"] as! Double )
                            self.lbSum.text = String(total)
                            self.runOnMain(after: 2) {
                                self.pieChart.updateData([FLPiePlotable(value: self.dataChart["cost"] as! Double, key: Key(key: "Cost", color: FLColor(hex: "f54242"))),
                                                     FLPiePlotable(value: self.dataChart["income"] as! Double, key: Key(key: "Income", color: FLColor(hex: "21b024")))], animated: true)
                            }
                        }
                    } else {
                        print("Get data chart failed")
                    }
                 
                } catch let err {
                    print(err.localizedDescription)
                }
            }
        }.resume()
    }
}
