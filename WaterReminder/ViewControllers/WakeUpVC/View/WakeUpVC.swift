//
//  WakeUpVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift

class WakeUpVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var wakeupClockImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var waterDropImageView: UIImageView!
    @IBOutlet weak var backBtn: GradientButton!
    @IBOutlet weak var nextBtn: GradientButton!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    // MARK: - Properties
    var presenter: ViewToPresenterWakeUpProtocol?
    
    var userDetails: UserDetails?
    var selectedTime: Date?
    var genderEnum = Gender.male
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WakeUpRouter.createModule(vc: self)
        maleFemaleSelection()
    }
    
    private func maleFemaleSelection() {
        presenter?.maleFemaleSelection(wakeupClockImageView: wakeupClockImageView, titleLbl: titleLbl, waterDropImageView: waterDropImageView, timePickerView: timePickerView, genderEnum: genderEnum)
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
        
        userDetails = UserDetails(gender: userDetails?.gender ?? 0, weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: timePickerView.date , sleepSelectedTime: Date(), waterReminderTime: Date())
        
        presenter?.navigateToBedVC(name: "OnBoarding", withIdentifier: "BedVC", navigationController: navigationController ?? UINavigationController(), userDetails: userDetails ?? UserDetails(gender: userDetails?.gender ?? 0, weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: timePickerView.date, sleepSelectedTime: Date(), waterReminderTime: Date()), genderEnum: genderEnum)
    }
}

extension WakeUpVC: PresenterToViewWakeUpProtocol{
    // TODO: Implement View Output Methods
}
