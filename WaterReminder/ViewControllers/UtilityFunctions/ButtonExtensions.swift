//
//  ButtonExtensions.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//

import Foundation
import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var startColor: UIColor = UIColor.red {
        didSet {
            updateGradient()
        }
    }
    @IBInspectable var endColor: UIColor = UIColor.yellow {
        didSet {
            updateGradient()
        }
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func draw(_ rect: CGRect) {
        gradientLayer.frame = rect
        
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
    }
    
    func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
}





