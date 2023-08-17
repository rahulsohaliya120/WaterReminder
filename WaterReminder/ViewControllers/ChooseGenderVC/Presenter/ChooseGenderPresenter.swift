//
//  ChooseGenderPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import UIKit
import Foundation

class ChooseGenderPresenter: ViewToPresenterChooseGenderProtocol {
    
    // MARK: Properties
    var view: PresenterToViewChooseGenderProtocol?
    var interactor: PresenterToInteractorChooseGenderProtocol?
    var router: PresenterToRouterChooseGenderProtocol?
    
    func navigateToWeightVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        router?.pushToWeightVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController, userDetails: userDetails, genderEnum: genderEnum)
    }
    
    func showTitleLbl(titleLbl: UILabel) {
        interactor?.mainTitleLbl(titleLbl: titleLbl)
    }
    
    func maleSelectionBtn(maleSelectionBtn: UIButton, maleView: UIView, femaleView: UIView) {
        maleView.layer.borderWidth = 1
        maleView.layer.borderColor = UIColor.darkGray.cgColor
        maleView.layer.cornerRadius = 5
        
        femaleView.layer.borderWidth = 0
        femaleView.layer.borderColor = UIColor.darkGray.cgColor
        femaleView.layer.cornerRadius = 5
    }
    
    func femaleSelectionBtn(femaleSelectionBtn: UIButton, maleView: UIView, femaleView: UIView) {
        femaleView.layer.borderWidth = 1
        femaleView.layer.borderColor = UIColor.darkGray.cgColor
        femaleView.layer.cornerRadius = 5
        
        maleView.layer.borderWidth = 0
        maleView.layer.borderColor = UIColor.darkGray.cgColor
        maleView.layer.cornerRadius = 5
    }

}

extension ChooseGenderPresenter: InteractorToPresenterChooseGenderProtocol {
    
}
