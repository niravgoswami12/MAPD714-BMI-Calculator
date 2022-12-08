//
//  HistoryModifyController.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//  Nirav Goswami (Student ID: 301252385)

import UIKit
import Firebase
import FirebaseDatabase

class HistoryModifyController: UIViewController {
    let ref = Database.database().reference()
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var weightPlaceholder: UILabel!
    var currentItem: Any?
    var name: String?
    var age: String?
    var height: String?
    var mode: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUnitLabel()
    }
    
    func updateUnitLabel(){
        if(mode == "Metric") {
            weightPlaceholder.text = "(in kg)"
        } else {
            weightPlaceholder.text = "(in lbs)"
            
        }
    }

    @IBAction func onSave(_ sender: Any) {
        
        if(!weight.text!.isEmpty && Double(weight.text!) != nil) {
            let result = calculateBMI(weight: Double(weight.text!)!, height: Double(height!)!, mode: mode!)
            var bmi = result.bmi
            
            let currentDate = datePicker.date
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = df.string(from: currentDate)
            let name = name
            let age = age
            let height = height
            let weight = weight.text
            let category = result.category
            self.ref.child(dateString).setValue([
                "name": name!,
                "age": age!,
                "height": height!,
                "weight": weight!,
                "bmi": bmi,
                "category": category,
                "mode": mode,
                "date": dateString
            ])
            navigationController?.popViewController(animated: true)
        }
    }
}
