//
//  UserInfoController.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//  Nirav Goswami (Student ID: 301252385)

import UIKit
import Firebase
import FirebaseDatabase

class UserInfoController: UIViewController {
    let ref = Database.database().reference()
    var mode = "Metric"
    private var bmiScores: [BMITrackingModel] = []
    @IBOutlet weak var heightPlaceHolder: UILabel!
    @IBOutlet weak var weightPlaceHolder: UILabel!

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var categorylabel: UILabel!
    
    @IBOutlet weak var resultView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = ""
        categorylabel.text = ""
        updateUnitLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func updateUnitLabel(){
        if(mode == "Metric") {
            heightPlaceHolder.text = "(in m)"
            weightPlaceHolder.text = "(in kg)"
        } else {
            heightPlaceHolder.text = "(in inch)"
            weightPlaceHolder.text = "(in lbs)"
            
        }
    }
    
    /// Unit mode switch Handler
    /// - Parameter sender: <#sender description#>
    @IBAction func onModeswitchChnage(_ sender: UISwitch) {
        if(sender.isOn) {
            mode = "Metric"
        } else {
            mode = "Imperial"
        }
        self.heightTF.text = ""
        self.weightTF.text = ""
        updateUnitLabel()
    }
    
    /// Calculate Button Click Handler
    /// - Parameter sender: <#sender description#>
    @IBAction func onCalculate(_ sender: Any) {
        if(!heightTF.text!.isEmpty && !weightTF.text!.isEmpty) {
            if(Double(heightTF.text!) != nil && Double(weightTF.text!) != nil) {
                // calculate BMI
                let result = calculateBMI(weight: Double(weightTF.text!)!, height: Double(heightTF.text!)!, mode: mode)
                var bmi = result.bmi
                scoreLabel.text = String(format: "%.1f", bmi)
                categorylabel.text = result.category
                let currentDate = Date()
                let df = DateFormatter()
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateString = df.string(from: currentDate)
                let name = nameTF.text
                let age = ageTF.text
                let height = heightTF.text
                let weight = weightTF.text
                let category = categorylabel.text
                resultView.backgroundColor = result.color
                self.ref.child(dateString).setValue([
                    "name": name!,
                    "age": age!,
                    "height": height!,
                    "weight": weight!,
                    "bmi": bmi,
                    "category": category!,
                    "mode": mode,
                    "date": dateString
                ])
            }
        } else {
            scoreLabel.text = ""
            categorylabel.text = ""
        }
    }
    
    /// Done Btn Click Handler
    /// - Parameter sender: <#sender description#>
    @IBAction func onGo(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    /// Load last added data to show User Information
    func loadData()
    {
        ref.queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { [self] (child) in
            if
                let snapshot = child as? DataSnapshot,
                let dataChange = snapshot.value as? [String:AnyObject],
                let name = dataChange["name"] as? String?,
                let age = dataChange["age"] as? String?,
                let height = dataChange["height"] as? String?,
                let weight = dataChange["weight"] as? String?,
                let mode = dataChange["mode"] as? String?,
                let bmi = dataChange["bmi"] as? Double?,
                let category = dataChange["category"] as? String {

                
                self.nameTF.text = name
                self.ageTF.text = age
                self.heightTF.text = height
                self.weightTF.text = weight
                self.scoreLabel.text = String(format: "%.1f", bmi!)
                self.categorylabel.text = category
                self.mode = mode!
                
                resultView.backgroundColor = getColor(bmi: bmi!)
                self.updateUnitLabel()
            }
        });
    }
}

