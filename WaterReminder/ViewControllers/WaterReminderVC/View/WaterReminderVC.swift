//
//  WaterReminderVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 05/08/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift
import UserNotifications

class WaterReminderVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var waterReminderImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var waterDropImageView: UIImageView!
    @IBOutlet weak var backBtn: GradientButton!
    @IBOutlet weak var nextBtn: GradientButton!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    // MARK: - Properties
    var presenter: ViewToPresenterWaterReminderProtocol?
    var userDetails: UserDetails?
    var selectedTime: Date?
    var genderEnum = Gender.male
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        WaterReminderRouter.createModule(vc: self)
        maleFemaleSelection()
    }
    
    private func maleFemaleSelection() {
        presenter?.maleFemaleSelection(waterReminderImgView: waterReminderImgView, titleLbl: titleLbl, waterDropImageView: waterDropImageView, timePickerView: timePickerView, genderEnum: genderEnum)
    }

    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: GradientButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func timePickerValueChanged(_ sender: UIDatePicker) {
        selectedTime = sender.date
    }
    
    @IBAction func nextBtnTapped(_ sender: GradientButton) {
        
        guard let selectedTime = selectedTime else {
            presenter?.showTimeWarningPopup(title: "Time Selection", message: "Please select a time before proceeding.", vc: self)
            return
        }
        
        userDetails = UserDetails(gender: userDetails?.gender ?? 0 ,weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: userDetails?.wakeUpSelectedTime ?? Date(), sleepSelectedTime: userDetails?.sleepSelectedTime ?? Date() , waterReminderTime: timePickerView.date)
        
        presenter?.showNotification(selectedTime: selectedTime)
        
        presenter?.fetchingDatabaseData(userDetails: userDetails ?? UserDetails(gender: userDetails?.gender ?? 0 ,weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: userDetails?.wakeUpSelectedTime ?? Date(), sleepSelectedTime: userDetails?.sleepSelectedTime ?? Date() , waterReminderTime: timePickerView.date))
        
        presenter?.navigateToHomeVC(name: "Home", withIdentifier: "HomeVC", navigationController: navigationController ?? UINavigationController(), genderEnum: genderEnum)
    }
}

extension WaterReminderVC: PresenterToViewWaterReminderProtocol{
    // TODO: Implement View Output Methods
}
