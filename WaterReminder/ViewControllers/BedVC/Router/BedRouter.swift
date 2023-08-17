//
//  BedRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class BedRouter: PresenterToRouterBedProtocol {
    
    // MARK: Static methods
    static func createModule(vc: BedVC) {
        
        let presenter: ViewToPresenterBedProtocol & InteractorToPresenterBedProtocol = BedPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = BedRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = BedInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func timeWarningPopup(title: String, message: String, vc: BedVC) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func pushToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        let waterReminder = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! WaterReminderVC;
        waterReminder.genderEnum = genderEnum
        waterReminder.userDetails = userDetails
        navigationController.pushViewController(waterReminder, animated: true)
    }
}
