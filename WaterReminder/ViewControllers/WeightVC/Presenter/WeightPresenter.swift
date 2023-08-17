//
//  WeightPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation

class WeightPresenter: ViewToPresenterWeightProtocol {

    // MARK: Properties
    var view: PresenterToViewWeightProtocol?
    var interactor: PresenterToInteractorWeightProtocol?
    var router: PresenterToRouterWeightProtocol?
    
    func navigateToWakeUpVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        router?.pushToWakeUpVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController, userDetails: userDetails, genderEnum: genderEnum)
    }
    
    func showAlert(title: String, message: String, vc: WeightVC) {
        router?.showAlert(title: title, message: message, vc: vc)
    }
}

extension WeightPresenter: InteractorToPresenterWeightProtocol {
    
}
