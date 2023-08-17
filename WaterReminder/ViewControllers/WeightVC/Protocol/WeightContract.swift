//
//  WeightContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewWeightProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWeightProtocol {
    
    var view: PresenterToViewWeightProtocol? { get set }
    var interactor: PresenterToInteractorWeightProtocol? { get set }
    var router: PresenterToRouterWeightProtocol? { get set }
    
    func navigateToWakeUpVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
    func showAlert(title: String, message: String, vc: WeightVC)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWeightProtocol {
    
    var presenter: InteractorToPresenterWeightProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWeightProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWeightProtocol {
    func pushToWakeUpVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
    func showAlert(title: String, message: String, vc: WeightVC)
    
}
