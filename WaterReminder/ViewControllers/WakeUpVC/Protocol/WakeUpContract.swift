//
//  WakeUpContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewWakeUpProtocol {
    
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterWakeUpProtocol {
    
    var view: PresenterToViewWakeUpProtocol? { get set }
    var interactor: PresenterToInteractorWakeUpProtocol? { get set }
    var router: PresenterToRouterWakeUpProtocol? { get set }
    
    func maleFemaleSelection(wakeupClockImageView: UIImageView, titleLbl: UILabel, waterDropImageView: UIImageView, timePickerView: UIView, genderEnum: Gender)
    func showTimeWarningPopup(title: String, message: String, vc: WakeUpVC)
    func navigateToBedVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorWakeUpProtocol {
    
    var presenter: InteractorToPresenterWakeUpProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterWakeUpProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterWakeUpProtocol {
    func timeWarningPopup(title: String, message: String, vc: WakeUpVC)
    func pushToBedVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
}
