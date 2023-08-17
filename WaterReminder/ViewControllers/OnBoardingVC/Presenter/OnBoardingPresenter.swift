//
//  OnBoardingPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import UIKit
import Foundation

class OnBoardingPresenter: ViewToPresenterOnBoardingProtocol {
    
    // MARK: Properties
    var view: PresenterToViewOnBoardingProtocol?
    var interactor: PresenterToInteractorOnBoardingProtocol?
    var router: PresenterToRouterOnBoardingProtocol?
    
    func navigateToChooseGenderVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        router?.pushToChooseGenderVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController)
    }
}

extension OnBoardingPresenter: InteractorToPresenterOnBoardingProtocol {
    
}
