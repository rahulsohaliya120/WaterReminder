//
//  BedVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift

class BedVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var bedImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var waterDropImageView: UIImageView!
    @IBOutlet weak var backBtn: GradientButton!
    @IBOutlet weak var nextBtn: GradientButton!
    @IBOutlet weak var timePickerView: UIDatePicker!
    
    // MARK: - Properties
    
    var userDetails: UserDetails?
    var selectedTime: Date?
    var genderEnum = Gender.male
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maleFemaleSelection()
    }
    
    private func maleFemaleSelection() {
        if genderEnum == .male {
            bedImageView.image = UIImage(named: "ic_blueBed")
            titleLbl.textColor = Constants.Colors.MaleColors.customBlue
            waterDropImageView.image = UIImage(named: "ic_blueSleepWaterDrop")
            timePickerView.setValue(Constants.Colors.MaleColors.customBlue, forKey: "textColor")
            timePickerView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            bedImageView.image = UIImage(named: "ic_pinkBed")
            titleLbl.textColor = Constants.Colors.FemaleColors.customPink
            waterDropImageView.image = UIImage(named: "ic_pinkSleepWaterDrop")
            timePickerView.setValue(Constants.Colors.FemaleColors.customPink, forKey: "textColor")
            timePickerView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func showTimeWarningPopup() {
        let alertController = UIAlertController(title: "Time Selection", message: "Please select a time before proceeding.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
            showTimeWarningPopup()
            return
        }
        
        userDetails = UserDetails(gender: userDetails?.gender ?? 0 ,weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: userDetails?.wakeUpSelectedTime ?? Date(), sleepSelectedTime: timePickerView.date , waterReminderTime: Date())
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WaterReminderVC") as! WaterReminderVC
        vc.genderEnum = genderEnum
        vc.userDetails = userDetails
        navigationController?.pushViewController(vc, animated: true);
    }
}
