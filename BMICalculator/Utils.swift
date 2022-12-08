//
//  Utils.swift
//  BMICalculator
//
//  Created by Nirav Goswami on 2022-12-07.
//  Nirav Goswami (Student ID: 301252385)

import Foundation
import UIKit

/// Get BMI Category based on BMI score
/// - Parameter bmi: bmi score
/// - Returns: category
func getCategory(bmi: Double) -> String
{
    var category = ""
    switch bmi {
    case let x where x < 16:
        category = "Severe Thinness"
    case 16...17:
        category = "Moderate Thinness"
    case 17...18.5:
        category = "Mild Thinness"
    case 18.5...25:
        category = "Normal"
    case 25...30:
        category = "Overweight"
    case 30...35:
        category = "Obese Class I"
    case 35...40:
        category = "Obese Class II"
    default:
        category = "Obese Class III"
    }
    
    return category
}
/// Get Color based on BMI score
/// - Parameter bmi: bmi score
/// - Returns: color
func getColor(bmi: Double) -> UIColor
{
    var color: UIColor
    switch bmi {
    case let x where x < 16:
        color = UIColor(red: 0.29, green: 0.74, blue: 1.00, alpha: 1.00)
    case 16...17:
        color = UIColor(red: 0.18, green: 0.56, blue: 1.00, alpha: 1.00)
    case 17...18.5:
        color = UIColor(red: 0.00, green: 0.45, blue: 0.99, alpha: 1.00)
    case 18.5...25:
        color = UIColor(red: 0.36, green: 0.79, blue: 0.01, alpha: 1.00)
    case 25...30:
        color = UIColor(red: 1.00, green: 0.78, blue: 0.00, alpha: 1.00)
    case 30...35:
        color = UIColor(red: 1.00, green: 0.55, blue: 0.07, alpha: 1.00)
    case 35...40:
        color = UIColor(red: 1.00, green: 0.38, blue: 0.42, alpha: 1.00)
    default:
        color = UIColor(red: 0.98, green: 0.23, blue: 0.25, alpha: 1.00)
    }
    
    return color
}

/// Calculate BMI Score
/// - Parameters:
///   - weight: weight
///   - height: height
///   - mode: mode
/// - Returns: bmi, category, color
func calculateBMI(weight: Double = 0, height: Double = 0, mode: String = "") -> (bmi: Double, category: String, color: UIColor)
{
    var bmi = 0.0
    if(mode == "Metric") {
        bmi = weight / (height * height)
    } else if(mode == "Imperial") {
        bmi = (weight / (height * height)) * 703
    }
    var category = getCategory(bmi: bmi)
    var color = getColor(bmi: bmi)
    return (bmi, category, color)
}
