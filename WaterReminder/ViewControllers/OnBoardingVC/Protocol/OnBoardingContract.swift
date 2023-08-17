//
//  OnBoardingContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewOnBoardingProtocol {
    
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterOnBoardingProtocol {
    
    var view: PresenterToViewOnBoardingProtocol? { get set }
    var interactor: PresenterToInteractorOnBoardingProtocol? { get set }
    var router: PresenterToRouterOnBoardingProtocol? { get set }
    func navigateToChooseGenderVC(name: String, withIdentifier: String, navigationController: UINavigationController)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorOnBoardingProtocol {
    
    var presenter: InteractorToPresenterOnBoardingProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterOnBoardingProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterOnBoardingProtocol {
    func pushToChooseGenderVC(name: String, withIdentifier: String, navigationController: UINavigationController)
}
