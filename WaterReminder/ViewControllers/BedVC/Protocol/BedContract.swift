//
//  BedContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation


// MARK: View Output (Presenter -> View)
protocol PresenterToViewBedProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterBedProtocol {
    
    var view: PresenterToViewBedProtocol? { get set }
    var interactor: PresenterToInteractorBedProtocol? { get set }
    var router: PresenterToRouterBedProtocol? { get set }
    func maleFemaleSelection(bedImageView: UIImageView, titleLbl: UILabel, waterDropImageView: UIImageView, timePickerView: UIView, genderEnum: Gender)
    func showTimeWarningPopup(title: String, message: String, vc: BedVC)
    func navigateToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorBedProtocol {
    
    var presenter: InteractorToPresenterBedProtocol? { get set }
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterBedProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterBedProtocol {
    func pushToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender)
    func timeWarningPopup(title: String, message: String, vc: BedVC)
}
