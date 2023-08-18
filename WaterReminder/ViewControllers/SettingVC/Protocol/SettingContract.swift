//
//  SettingContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewSettingProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterSettingProtocol {
    
    var view: PresenterToViewSettingProtocol? { get set }
    var interactor: PresenterToInteractorSettingProtocol? { get set }
    var router: PresenterToRouterSettingProtocol? { get set }
    
    func configureViews(reminderSettingView: UIView, reminderSettingsOptionsView: UIView, generalView: UIView, generalOptionsView: UIView)
    func navigateToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController)
    func navigateToOnBoardingVC(name: String, withIdentifier: String, navigationController: UINavigationController)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorSettingProtocol {
    
    var presenter: InteractorToPresenterSettingProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterSettingProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterSettingProtocol {
    func pushToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController)
    func pushToOnBoardingVC(name: String, withIdentifier: String, navigationController: UINavigationController)
}
