//
//  WeightPickerVC.swift
//  WaterReminder
//
//  Created by Rahul on 28/07/23.
//

import Foundation
import UIKit

protocol WeightPickerViewDelegate: AnyObject {
    func didSelectWeight(weight: Int, unit: WeightUnit)
}

enum WeightUnit: String, CaseIterable {
    case kg = "kg"
    case lbs = "lbs"
}

class WeightPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    weak var weightPickerDelegate: WeightPickerViewDelegate?
    
    var currentThemeColor = Constants.Colors.MaleColors.customBlue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPickerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPickerView()
    }
    
    private func setupPickerView() {
        dataSource = self
        delegate = self
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 200
        } else {
            return WeightUnit.allCases.count
        }
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row)"
        } else {
            return WeightUnit.allCases[row].rawValue
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if component == 0 {
            attributes[.foregroundColor] = currentThemeColor
            attributes[.font] = UIFont.systemFont(ofSize: 17, weight: .bold)
        } else {
            attributes[.foregroundColor] = currentThemeColor
            attributes[.font] = UIFont.systemFont(ofSize: 17, weight: .bold)
        }
        
        if component == 0 {
            let weightNumber = "\(row)"
            return NSAttributedString(string: weightNumber, attributes: attributes)
        } else {
            let weightUnit = WeightUnit.allCases[row].rawValue
            return NSAttributedString(string: weightUnit, attributes: attributes)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedWeight = pickerView.selectedRow(inComponent: 0)
        let selectedUnit = WeightUnit.allCases[pickerView.selectedRow(inComponent: 1)]
        weightPickerDelegate?.didSelectWeight(weight: selectedWeight, unit: selectedUnit)
    }
}

