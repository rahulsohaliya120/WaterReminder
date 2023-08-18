//
//  SettingRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//

import Foundation
import UIKit
import RealmSwift

class SettingRouter: PresenterToRouterSettingProtocol {
    
    // MARK: Static methods
    static func createModule(vc: SettingVC) {
        
        let presenter: ViewToPresenterSettingProtocol & InteractorToPresenterSettingProtocol = SettingPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = SettingRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = SettingInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func pushToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        let realm = try! Realm()
        let waterAmountRecord = realm.objects(WaterData.self)
        let waterReminderVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! WaterReminderVC;
        if let firstRecord = waterAmountRecord.last {
            let genderData = firstRecord.gender
            waterReminderVC.genderEnum = genderData == 0 ? .male : .female
            print("Gender Data: \(genderData)")
        }
        navigationController.pushViewController(waterReminderVC, animated: true)
    }
    
    func pushToOnBoardingVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        UserDefaults.standard.set(false, forKey: "USER_LOGIN")
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = storyboard.instantiateViewController(withIdentifier: withIdentifier) as UIViewController
        navigationController.viewControllers = [rootViewController]
        AppDelegate.sharedApplication().window?.rootViewController = navigationController
    }
}
