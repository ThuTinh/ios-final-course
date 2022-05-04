//
//  Manage_ViewController.swift
//  manage-money
//
//  Created by Thu Tinh on 20/04/2022.
//

import UIKit

class Manage_ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tbInOutMonney: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbInOutMonney.dataSource = self
        tbInOutMonney.delegate = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InOut") as! InOutMoney_TableViewCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
