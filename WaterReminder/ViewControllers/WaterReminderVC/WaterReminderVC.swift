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
    
    var userDetails: UserDetails?
    var selectedTime: Date?
    var genderEnum = Gender.male
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        maleFemaleSelection()
    }
    
    private func maleFemaleSelection() {
        if genderEnum == .male {
            waterReminderImgView.image = UIImage(named: "ic_waterReminderBlue")
            titleLbl.textColor = Constants.Colors.MaleColors.customBlue
            waterDropImageView.image = UIImage(named: "ic_bluewaterDrop")
            
            timePickerView.setValue( Constants.Colors.MaleColors.customBlue, forKey: "textColor")
            timePickerView.translatesAutoresizingMaskIntoConstraints = false
        } else {
            waterReminderImgView.image = UIImage(named: "ic_waterReminderPink")
            titleLbl.textColor = Constants.Colors.FemaleColors.customPink
            waterDropImageView.image = UIImage(named: "ic_pink")
            
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
        
        userDetails = UserDetails(gender: userDetails?.gender ?? 0 ,weight: userDetails?.weight ?? 40, unit: userDetails?.unit ?? "kg", wakeUpSelectedTime: userDetails?.wakeUpSelectedTime ?? Date(), sleepSelectedTime: timePickerView.date , waterReminderTime: timePickerView.date)
        
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
        
        let realmData = WaterData()
        realmData.gender = userDetails?.gender ?? 0
        realmData.weight = userDetails?.weight ?? 40
        realmData.unit = userDetails?.unit ?? "kg"
        realmData.wakeUpSelectedTime = userDetails?.wakeUpSelectedTime ?? Date()
        realmData.SleepSelectedTime = userDetails?.sleepSelectedTime ?? Date()
        realmData.waterReminderTime = userDetails?.waterReminderTime ?? Date()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(realmData)
        }
        
        UserDefaults.standard.set(true, forKey: "USER_LOGIN")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        vc.genderEnum = genderEnum
        navigationController?.pushViewController(vc, animated: true);
    }
}
