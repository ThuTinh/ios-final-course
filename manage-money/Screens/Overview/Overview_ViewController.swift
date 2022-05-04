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
    override func viewDidLoad() {
        tbWallet.delegate = self
        tbWallet.dataSource  = self
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let token = UserDefaults.standard.string(forKey: "token")
        if let userToken = token {
            print("User logged")
            let pieChart = FLPieChart(title: "Platforms",
                                             data: [FLPiePlotable(value: 51.7, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                                    FLPiePlotable(value: 25.2, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                                    FLPiePlotable(value: 14.7, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                                    FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))],
                                             border: .full,
                                             formatter: .percent,
                                             animated: true)
                   
                   runOnMain(after: 2) {
                       pieChart.updateData([FLPiePlotable(value: 52, key: Key(key: "Desktop", color: FLColor(hex: "138CFD"))),
                                            FLPiePlotable(value: 34, key: Key(key: "Mobile", color: FLColor(hex: "4DA8FF"))),
                                            FLPiePlotable(value: 66, key: Key(key: "Table", color: FLColor(hex: "A7CBF6"))),
                                            FLPiePlotable(value: 10.8, key: Key(key: "Other", color: FLColor(hex: "F0F4FA")))], animated: true)
                   }
            chartView.addSubview(pieChart)
            pieChart.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                pieChart.centerYAnchor.constraint(equalTo: chartView.centerYAnchor),
                pieChart.centerXAnchor.constraint(equalTo: chartView.centerXAnchor),
                pieChart.heightAnchor.constraint(equalToConstant: 100),
                pieChart.widthAnchor.constraint(equalToConstant: 100)
            ])
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let loginController = sb.instantiateViewController(withIdentifier: "LOGIN") as! Login_ViewController
            self.navigationController?.pushViewController(loginController, animated: true)
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell") as! WalletCell_TableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
