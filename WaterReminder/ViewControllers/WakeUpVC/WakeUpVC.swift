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
            wakeupClockImageView.image = UIImage(named: "ic_wakeupBlueClock")
            titleLbl.textColor = UIColor(red: 27/255, green: 174/255, blue: 238/255, alpha: 1)
            waterDropImageView.image = UIImage(named: "ic_bluewaterDrop")
            timePickerView.setValue(UIColor(red: 27/255, green: 174/255, blue: 238/255, alpha: 1), forKey: "textColor")
            timePickerView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            wakeupClockImageView.image = UIImage(named: "ic_wakeupPinkClock")
            titleLbl.textColor = UIColor(red: 255/255, green: 69/255, blue: 147/255, alpha: 1)
            waterDropImageView.image = UIImage(named: "ic_weightWaterdrop")
            timePickerView.setValue(UIColor(red: 255/255, green: 69/255, blue: 147/255, alpha: 1), forKey: "textColor")
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
        
        userDetails = UserDetails(gender: userDetails?.gender ?? 0, weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: timePickerView.date , sleepSelectedTime: Date(), waterReminderTime: Date())
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "BedVC") as! BedVC
        vc.genderEnum = genderEnum
        vc.userDetails = userDetails
        navigationController?.pushViewController(vc, animated: true);
    }
}
