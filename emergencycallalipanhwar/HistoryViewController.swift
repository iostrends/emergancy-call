//
//  HistoryViewController.swift
//  emergencycallalipanhwar
//
//  Created by Mohammad ali panhwar on 5/29/18.
//  Copyright © 2018 Mohammad ali panhwar. All rights reserved.
//

import UIKit


class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    

    @IBAction func menu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
