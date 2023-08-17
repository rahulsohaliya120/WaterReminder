//
//  WaterReminderPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//

import UIKit
import Foundation

class WaterReminderPresenter: ViewToPresenterWaterReminderProtocol {

    // MARK: Properties
    var view: PresenterToViewWaterReminderProtocol?
    var interactor: PresenterToInteractorWaterReminderProtocol?
    var router: PresenterToRouterWaterReminderProtocol?
    
    func maleFemaleSelection(waterReminderImgView: UIImageView, titleLbl: UILabel, waterDropImageView: UIImageView, timePickerView: UIView, genderEnum: Gender) {
       waterReminderImgView.image = genderEnum == .male ? UIImage(named: "ic_waterReminderBlue") : UIImage(named: "ic_waterReminderPink")
       titleLbl.textColor = genderEnum == .male ? Constants.Colors.MaleColors.customBlue : Constants.Colors.FemaleColors.customPink
       waterDropImageView.image = genderEnum == .male ? UIImage(named: "ic_bluewaterDrop") : UIImage(named: "ic_pink")
       timePickerView.setValue(genderEnum == .male ? Constants.Colors.MaleColors.customBlue : Constants.Colors.FemaleColors.customPink, forKey: "textColor")
       timePickerView.translatesAutoresizingMaskIntoConstraints = false
   }
    
    func showTimeWarningPopup(title: String, message: String, vc: WaterReminderVC) {
        router?.timeWarningPopup(title: title, message: message, vc: vc)
    }
    
    func showNotification(selectedTime: Date) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Water Reminder"
        content.body = "It's time to drink water!"
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let identifier = "WaterReminderNotification"
        
        content.userInfo = ["value": "Data with local notification"]
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling local notification: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchingDatabaseData(userDetails: UserDetails) {
        interactor?.fetchDataBaseData(userDetails: userDetails)
    }
    
    func navigateToHomeVC(name: String, withIdentifier: String, navigationController: UINavigationController, genderEnum: Gender) {
        router?.pushToHomeVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController, genderEnum: genderEnum)
    }
}

extension WaterReminderPresenter: InteractorToPresenterWaterReminderProtocol {
    
}
