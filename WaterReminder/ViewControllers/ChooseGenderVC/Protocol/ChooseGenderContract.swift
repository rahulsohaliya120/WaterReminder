//
//  ChooseGenderContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewChooseGenderProtocol {
    
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterChooseGenderProtocol {
    
    var view: PresenterToViewChooseGenderProtocol? { get set }
    var interactor: PresenterToInteractorChooseGenderProtocol? { get set }
    var router: PresenterToRouterChooseGenderProtocol? { get set }
    
    func navigateToWeightVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
    func showTitleLbl(titleLbl: UILabel)
    func maleSelectionBtn(maleSelectionBtn: UIButton, maleView: UIView, femaleView: UIView)
    func femaleSelectionBtn(femaleSelectionBtn: UIButton, maleView: UIView, femaleView: UIView)
    
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorChooseGenderProtocol {
    
    var presenter: InteractorToPresenterChooseGenderProtocol? { get set }
    func mainTitleLbl(titleLbl: UILabel)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterChooseGenderProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterChooseGenderProtocol {
    func pushToWeightVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
}
