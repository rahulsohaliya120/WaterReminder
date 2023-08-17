//
//  WaterReminderRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class WaterReminderRouter: PresenterToRouterWaterReminderProtocol {
    
    // MARK: Static methods
    static func createModule(vc: WaterReminderVC) {
        
        let presenter: ViewToPresenterWaterReminderProtocol & InteractorToPresenterWaterReminderProtocol = WaterReminderPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = WaterReminderRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = WaterReminderInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func timeWarningPopup(title: String, message: String, vc: WaterReminderVC) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func pushToHomeVC(name: String, withIdentifier: String, navigationController: UINavigationController, genderEnum: Gender) {
        UserDefaults.standard.set(true, forKey: "USER_LOGIN")
        let homeVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! HomeVC;
        homeVC.genderEnum = genderEnum
        navigationController.pushViewController(homeVC, animated: true)
    }
}
