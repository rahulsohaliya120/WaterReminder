//
//  ChooseGenderInteractor.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class ChooseGenderInteractor: PresenterToInteractorChooseGenderProtocol {
    
    // MARK: Properties
    var presenter: InteractorToPresenterChooseGenderProtocol?
    
    
    func mainTitleLbl(titleLbl: UILabel) {
        let gradient = getGradientLayer(bounds: titleLbl.bounds)
        titleLbl.textColor = gradientColor(bounds: titleLbl.bounds, gradientLayer: gradient)
    }
    
    func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = Constants.Colors.chooseGenderColor.colorful
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
}
