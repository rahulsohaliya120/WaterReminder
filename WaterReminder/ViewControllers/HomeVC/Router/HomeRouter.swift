//
//  HomeRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//

import Foundation
import UIKit

class HomeRouter: PresenterToRouterHomeProtocol {
    
    // MARK: Static methods
    static func createModule(vc: HomeVC) {

        let presenter: ViewToPresenterHomeProtocol & InteractorToPresenterHomeProtocol = HomePresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = HomeRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = HomeInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
    
    func pushToHistoryVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        let historyVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! HistoryVC;
        navigationController.pushViewController(historyVC, animated: true)
    }
    
    func pushToSettingVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        let settingVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: withIdentifier) as! SettingVC;
        navigationController.pushViewController(settingVC, animated: true)
    }
}
