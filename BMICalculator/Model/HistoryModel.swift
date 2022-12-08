//
//  HistoryModel.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//

import Foundation

class HistoryModel
{
     var id: String
     var height: Double
     var weight: Double
     var bmi: Double
     var category: String
     var mode: String
     var date: String
    
    // initializer (constructor)
    init(id: String, height: Double = 0.0, weight: Double = 0.0, bmi: Double = 0.0, category: String = "", mode: String = "", date: String = "")
    {
        self.id = id
        self.height = height
        self.weight = weight
        self.bmi = bmi
        self.category = category
        self.mode = mode
        self.date = date
    }
    
}
