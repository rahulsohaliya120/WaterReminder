//
//  BedPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation

class BedPresenter: ViewToPresenterBedProtocol {

    // MARK: Properties
    var view: PresenterToViewBedProtocol?
    var interactor: PresenterToInteractorBedProtocol?
    var router: PresenterToRouterBedProtocol?
    
    func maleFemaleSelection(bedImageView: UIImageView, titleLbl: UILabel, waterDropImageView: UIImageView, timePickerView: UIView, genderEnum: Gender) {
       bedImageView.image = genderEnum == .male ? UIImage(named: "ic_blueBed") : UIImage(named: "ic_pinkBed")
       titleLbl.textColor = genderEnum == .male ? Constants.Colors.MaleColors.customBlue : Constants.Colors.FemaleColors.customPink
       waterDropImageView.image = genderEnum == .male ? UIImage(named: "ic_blueSleepWaterDrop") : UIImage(named: "ic_pinkSleepWaterDrop")
       timePickerView.setValue(genderEnum == .male ? Constants.Colors.MaleColors.customBlue : Constants.Colors.FemaleColors.customPink, forKey: "textColor")
       timePickerView.translatesAutoresizingMaskIntoConstraints = false
   }
    
    func showTimeWarningPopup(title: String, message: String, vc: BedVC) {
        router?.timeWarningPopup(title: title, message: message, vc: vc)
    }
    
    func navigateToWaterReminderVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        router?.pushToWaterReminderVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController, userDetails: userDetails, genderEnum: genderEnum)
    }
}

extension BedPresenter: InteractorToPresenterBedProtocol {
    
}
