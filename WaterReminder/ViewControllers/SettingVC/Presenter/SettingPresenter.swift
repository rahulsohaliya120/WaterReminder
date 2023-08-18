//
//  SettingPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//

import Foundation
import UIKit

class SettingPresenter: ViewToPresenterSettingProtocol {

    // MARK: Properties
    var view: PresenterToViewSettingProtocol?
    var interactor: PresenterToInteractorSettingProtocol?
    var router: PresenterToRouterSettingProtocol?
    
    func configureViews(reminderSettingView: UIView, reminderSettingsOptionsView: UIView, generalView: UIView, generalOptionsView: UIView) {
        reminderSettingView.layer.cornerRadius = 10
        reminderSettingsOptionsView.layer.cornerRadius = 10
        generalView.layer.cornerRadius = 10
        generalOptionsView.layer.cornerRadius = 10
    }
    
    func navigateToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        router?.pushToWaterReminderVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController)
    }
    
    func navigateToOnBoardingVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        router?.pushToOnBoardingVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController)
    }
}


extension SettingPresenter: InteractorToPresenterSettingProtocol {
    
}
