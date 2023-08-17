//
//  WakeUpRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class WakeUpRouter: PresenterToRouterWakeUpProtocol {
    
    // MARK: Static methods
    static func createModule(vc: WakeUpVC) {
        
        let presenter: ViewToPresenterWakeUpProtocol & InteractorToPresenterWakeUpProtocol = WakeUpPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = WakeUpRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = WakeUpInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func timeWarningPopup(title: String, message: String, vc: WakeUpVC) {
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
   }
    
    func pushToBedVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        let bedVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! BedVC;
        bedVC.genderEnum = genderEnum
        bedVC.userDetails = userDetails
        navigationController.pushViewController(bedVC, animated: true)
    }
}


