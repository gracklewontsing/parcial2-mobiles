//
//  Top10ViewController.swift
//  FredGame
//
//  Created by user188455 on 3/15/21.
//

import UIKit

class Top10ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var scoreTableView: UITableView!
    
    func configureView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    var top10data : Top10? {
        didSet {

        }
    }
    
    // MARK: Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return top10data?.getList().count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let score = top10data?.getList()[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-DD"
            let formattedDate = dateFormatter.string(from: score!.date)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel!.text = formattedDate + " " + score!.name + " " + String(score!.points)
            
            return cell
        }
}
