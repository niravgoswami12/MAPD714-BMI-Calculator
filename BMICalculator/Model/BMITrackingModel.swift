//
//  UserModel.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//  Nirav Goswami (Student ID: 301252385)

import Foundation

class BMITrackingModel
{
     var name: String
     var age: Int
     var height: Double
     var weight: Double
     var bmi: Double
     var category: String
     var mode: String
     var date: String
    
    init( name: String, age:Int = 1, height: Double = 0.0, weight: Double = 0.0, bmi: Double = 0.0, category: String = "", mode: String = "", date: String = "")
    {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.bmi = bmi
        self.category = category
        self.mode = mode
        self.date = date
    }
    
}
