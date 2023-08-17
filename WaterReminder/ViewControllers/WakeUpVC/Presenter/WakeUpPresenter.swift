//
//  WakeUpPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import Foundation
import UIKit

class WakeUpPresenter: ViewToPresenterWakeUpProtocol {

    // MARK: Properties
    var view: PresenterToViewWakeUpProtocol?
    var interactor: PresenterToInteractorWakeUpProtocol?
    var router: PresenterToRouterWakeUpProtocol?
    
     func maleFemaleSelection(wakeupClockImageView: UIImageView, titleLbl: UILabel, waterDropImageView: UIImageView, timePickerView: UIView, genderEnum: Gender) {
        wakeupClockImageView.image = genderEnum == .male ? UIImage(named: "ic_wakeupBlueClock") : UIImage(named: "ic_wakeupPinkClock")
        titleLbl.textColor = genderEnum == .male ? Constants.Colors.MaleColors.customBlue : Constants.Colors.FemaleColors.customPink
        waterDropImageView.image = genderEnum == .male ? UIImage(named: "ic_bluewaterDrop") : UIImage(named: "ic_weightWaterdrop")
        timePickerView.setValue( genderEnum == .male ? Constants.Colors.MaleColors.customBlue : Constants.Colors.FemaleColors.customPink, forKey: "textColor")
        timePickerView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func navigateToBedVC(name: String, withIdentifier: String, navigationController: UINavigationController, userDetails: UserDetails, genderEnum: Gender) {
        router?.pushToBedVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController, userDetails: userDetails, genderEnum: genderEnum)
    }
    
    func showTimeWarningPopup(title: String, message: String, vc: WakeUpVC) {
        router?.timeWarningPopup(title: title, message: message, vc: vc)
    }
    
}

extension WakeUpPresenter: InteractorToPresenterWakeUpProtocol {
    
}
