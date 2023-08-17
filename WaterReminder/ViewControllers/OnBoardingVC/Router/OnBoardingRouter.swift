//
//  OnBoardingRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class OnBoardingRouter: PresenterToRouterOnBoardingProtocol {
    
    // MARK: Static methods
    static func createModule(vc: OnBoardingVC) {
        
        let presenter: ViewToPresenterOnBoardingProtocol & InteractorToPresenterOnBoardingProtocol = OnBoardingPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = OnBoardingRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = OnBoardingInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func pushToChooseGenderVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        let chooseGenderVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier);
        navigationController.pushViewController(chooseGenderVC, animated: true)
    }
    
}

