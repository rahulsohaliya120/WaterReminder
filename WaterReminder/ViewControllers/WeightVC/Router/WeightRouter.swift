//
//  WeightRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class WeightRouter: PresenterToRouterWeightProtocol {
    
    // MARK: Static methods
    static func createModule(vc: WeightVC) {
        
        let presenter: ViewToPresenterWeightProtocol & InteractorToPresenterWeightProtocol = WeightPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = WeightRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = WeightInteractor()
        vc.presenter?.interactor?.presenter = presenter
        
    }
    
    func showAlert(title: String, message: String, vc: WeightVC) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func pushToWakeUpVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        let wakeUpVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! WakeUpVC;
        wakeUpVC.genderEnum = genderEnum
        wakeUpVC.userDetails = userDetails
        navigationController.pushViewController(wakeUpVC, animated: true)
    }
    
    
}
