//
//  ChooseGenderRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit



class ChooseGenderRouter: PresenterToRouterChooseGenderProtocol {
    
    // MARK: Static methods
    static func createModule(vc: ChooseGenderVC) {
        
        let presenter: ViewToPresenterChooseGenderProtocol & InteractorToPresenterChooseGenderProtocol = ChooseGenderPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = ChooseGenderRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = ChooseGenderInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func pushToWeightVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        let weightVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! WeightVC;
        weightVC.genderEnum = genderEnum
        weightVC.userDetails = userDetails
        navigationController.pushViewController(weightVC, animated: true)
    }
}
