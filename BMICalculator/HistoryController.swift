//
//  HistoryController.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//

import UIKit
import Firebase
import FirebaseDatabase

class HistoryController: UITableViewController {

    let ref = Database.database().reference()
    var refObservers: [DatabaseHandle] = []
    private var bmiList: [BMITrackingModel] = []
    let cellIdentifier = "historyCell"
    
    var nameInLastEntry: String?
    var ageInLastEntry: String?
    var heightInLastEntry: String?
    var modeInLastEntry: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HistoryTableViewCell.self,
                               forCellReuseIdentifier: cellIdentifier)
        tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getLastEntry()
        loadData()
    }
    
    /// Get Last Added record
    func getLastEntry()
    {
        ref.queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { [self] (child) in
            if
                let snapshot = child as? DataSnapshot,
                let dataChange = snapshot.value as? [String:AnyObject],
                let name = dataChange["name"] as? String?,
                let age = dataChange["age"] as? String?,
                let height = dataChange["height"] as? String?,
                let mode = dataChange["mode"] as? String? {

                self.nameInLastEntry = name!
                self.ageInLastEntry = age!
                self.heightInLastEntry = height!
                self.modeInLastEntry = mode!
                
            }
        });
    }
    
    /// Load all record to show table view
    func loadData()
    {
        bmiList.removeAll()
        ref.observeSingleEvent(of: .value) {
            snapshot  in
            var bmiArr: [BMITrackingModel] = []
            //
            for child in snapshot.children {
                //
                if
                    let snapshot = child as? DataSnapshot,
                    let dataChange = snapshot.value as? [String:AnyObject],
                    let name = dataChange["name"] as? String?,
                    let age = dataChange["age"] as? String?,
                    let height = dataChange["height"] as? String?,
                    let weight = dataChange["weight"] as? String?,
                    let bmi = dataChange["bmi"] as? Double,
                    let mode = dataChange["mode"] as? String?,
                    let date = dataChange["date"] as? String?,
                    let category = dataChange["category"] as? String {

                    bmiArr.append(BMITrackingModel(name: name!, age: Int(age!)!, height: Double(height!)!, weight: Double(weight!)!, bmi: bmi, category: category, mode: mode!, date: date!))
                    
                }
            }
            self.bmiList.append(contentsOf: bmiArr)
            self.tableView.reloadData()
            self.ref.removeAllObservers()
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bmiList.count == 0 {
            self.tableView.setEmptyMessage("No History Available")
        } else {
            self.tableView.restore()
        }
        return bmiList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HistoryTableViewCell
        let rowData = bmiList[indexPath.row]
        
        if(rowData.mode == "Metric") {
            cell.weightLabel.text = "Weight: " + String(format: "%.1f", rowData.weight) + " kg"
        } else {
            cell.weightLabel.text = "Weight: " + String(format: "%.1f", rowData.weight) + " lbs"
        }
        cell.bmiLabel.text = "BMI: " + String(format: "%.1f", rowData.bmi)
        cell.categoryLabel.text = rowData.category
        cell.backgroundColor = getColor(bmi: rowData.bmi)
        cell.dateLabel.text = rowData.date
        return cell
    }
    
    /// New Record Add Handler
    /// - Parameter sender: <#sender description#>
    @IBAction func onAdd(_ sender: Any) {
        if(heightInLastEntry == nil){
            var dialogMessage = UIAlertController(title: "Alert", message: "Please Provide Personal information", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                
             })
            
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true, completion: nil)
            return
        }
        let senderData: [String: Any?] = ["name": self.nameInLastEntry, "height": self.heightInLastEntry , "mode": self.modeInLastEntry, "age": self.ageInLastEntry]
        self.performSegue(withIdentifier: "showHistoryModifier", sender: senderData)
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
    
    /// Record Edit Handler
    /// - Parameter index: <#index description#>
    func onEdit(index: Int){
        let alert = UIAlertController(title: "Update Weight", message: "", preferredStyle: .alert)
        var currentMode = self.bmiList[index].mode as? String
        alert.addTextField{field in
            
            if(currentMode == "Metric") {
                field.placeholder = "Enter weight(in kg))"
            } else {
                field.placeholder = "Enter weight(in lbs)"
            }
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self](_) in
            if let field = alert.textFields?.first {
                if let weight = field.text, !weight.isEmpty {
                    let ref = self!.ref.child(self!.bmiList[index].date)
                    let result = calculateBMI(weight: Double(weight)!, height: Double(self!.heightInLastEntry!)!, mode: currentMode!)
                    let bmi = result.bmi
                    let category = result.category
                    ref.updateChildValues([
                        "weight": weight,
                        "bmi": bmi,
                        "category": category
                    ])

                    DispatchQueue.main.async {
                        self?.bmiList[index].bmi = bmi
                        self?.bmiList[index].weight = Double(weight)!
                        self?.bmiList[index].category = category
                        self?.tableView.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {
            (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let rowData = self.bmiList[indexPath.row]
            self.bmiList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.remove(child: rowData.date)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    
    func remove(child: String) {
        let ref = self.ref.child(child)
        ref.removeValue { error, _ in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let historyModifyVC =  segue.destination as! HistoryModifyController
        let object = sender as! [String: Any?]
        historyModifyVC.name = object["name"] as? String
        historyModifyVC.age = object["age"] as? String
        historyModifyVC.height = object["height"] as? String
        historyModifyVC.mode = object["mode"] as? String
        
    }

}


extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}



