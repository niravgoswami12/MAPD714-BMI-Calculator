//
//  HistoryController.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//

import UIKit

class HistoryController: UITableViewController {

    let tableViewData = Array(repeating: "Item", count: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self,
                               forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                 for: indexPath)
        cell.textLabel?.text = self.tableViewData[indexPath.row]
        return cell
    }
    
    @IBAction func onAdd(_ sender: Any) {
        self.performSegue(withIdentifier: "showHistoryModifier", sender: index)
    }
    
    
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
                                            self?.onEdit(index: indexPath.row)
                                            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }


    override func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
                                        self?.onRemove(index: indexPath.row)
                                            completionHandler(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func onEdit(index: Int){
        self.performSegue(withIdentifier: "showHistoryModifier", sender: index)
    }
    
    func onRemove(index: Int){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let historyModifyVC =  segue.destination as! HistoryModifyController
    }

}
