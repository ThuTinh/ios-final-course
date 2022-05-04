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
    override func viewDidLoad() {
        super.viewDidLoad()
        tbReport.delegate = self
        tbReport.dataSource = self

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! Report_TableViewCell
        return cell
    }
    
}
