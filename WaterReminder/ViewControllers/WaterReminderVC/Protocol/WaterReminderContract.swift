//
//  WaterReminderContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewWaterReminderProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWaterReminderProtocol {
    
    var view: PresenterToViewWaterReminderProtocol? { get set }
    var interactor: PresenterToInteractorWaterReminderProtocol? { get set }
    var router: PresenterToRouterWaterReminderProtocol? { get set }
    
    func maleFemaleSelection(waterReminderImgView: UIImageView, titleLbl: UILabel, waterDropImageView: UIImageView, timePickerView: UIView, genderEnum: Gender)
    func showTimeWarningPopup(title: String, message: String, vc: WaterReminderVC)
    func showNotification(selectedTime: Date)
    func fetchingDatabaseData(userDetails: UserDetails)
    func navigateToHomeVC(name: String, withIdentifier: String, navigationController: UINavigationController, genderEnum: Gender)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWaterReminderProtocol {
    
    var presenter: InteractorToPresenterWaterReminderProtocol? { get set }
    
    func fetchDataBaseData(userDetails: UserDetails)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWaterReminderProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWaterReminderProtocol {
    func timeWarningPopup(title: String, message: String, vc: WaterReminderVC)
    func pushToHomeVC(name: String, withIdentifier: String, navigationController: UINavigationController, genderEnum: Gender)
}
