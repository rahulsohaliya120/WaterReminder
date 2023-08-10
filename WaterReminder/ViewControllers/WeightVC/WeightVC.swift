//
//  WeightVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift

class WeightVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var weightImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var waterDropImageView: UIImageView!
    @IBOutlet weak var nextBtn: GradientButton!
    @IBOutlet weak var backBtn: GradientButton!
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var userDetails: UserDetails?
    var weightSelected = false
    var weightPicker: WeightPickerView!
    var genderEnum = Gender.male
    var selectWeight: Int = 0
    var selectedUnit: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maleFemaleSelection()
    }
    
    func didSelectWeight(weight: Int, unit: WeightUnit) {
        selectWeight = weight
        selectedUnit = unit.rawValue
        weightSelected = true
        print("Selected weight: \(weight) \(unit.rawValue)")
    }

    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: GradientButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: GradientButton) {
        userDetails = UserDetails(gender: userDetails?.gender ?? 0, weight: selectWeight, unit: selectedUnit, wakeUpSelectedTime: Date(), sleepSelectedTime: Date(), waterReminderTime: Date())
        if weightSelected {
            let storyBoard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "WakeUpVC") as! WakeUpVC
            vc.genderEnum = genderEnum
            vc.userDetails = userDetails
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Weight Not Selected", message: "Please select your weight before proceeding.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension WeightVC: WeightPickerViewDelegate {

    private func maleFemaleSelection() {
        if genderEnum == .male {
            weightImageView.image = UIImage(named: "ic_weightBlue")
            titleLbl.textColor = Constants.Colors.MaleColors.customBlue
            waterDropImageView.image = UIImage(named: "ic_bluewaterDrop")
            
            weightPicker = WeightPickerView()
            weightPicker.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(weightPicker)
            
            NSLayoutConstraint.activate([
                
                weightPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                weightPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                weightPicker.widthAnchor.constraint(equalToConstant: 60),
                weightPicker.heightAnchor.constraint(equalToConstant: 100),
                
                weightPicker.topAnchor.constraint(equalTo: titleLbl.topAnchor, constant: 110),
                
                weightPicker.leadingAnchor.constraint(equalTo: waterDropImageView.leadingAnchor, constant: 120),
                weightPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
            
            weightPicker.weightPickerDelegate = self
            weightPicker.currentThemeColor = Constants.Colors.MaleColors.customBlue
            
        } else {
            weightImageView.image = UIImage(named: "ic_weightPink")
            titleLbl.textColor = Constants.Colors.FemaleColors.customPink
            waterDropImageView.image = UIImage(named: "ic_weightWaterdrop")
            
            weightPicker = WeightPickerView()
            weightPicker.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(weightPicker)
            
            NSLayoutConstraint.activate([
                
                weightPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                weightPicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                weightPicker.widthAnchor.constraint(equalToConstant: 60),
                weightPicker.heightAnchor.constraint(equalToConstant: 100),
                
                weightPicker.topAnchor.constraint(equalTo: titleLbl.topAnchor, constant: 110),
                
                weightPicker.leadingAnchor.constraint(equalTo: waterDropImageView.leadingAnchor, constant: 120),
                weightPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ])
            
            weightPicker.weightPickerDelegate = self
            weightPicker.currentThemeColor = Constants.Colors.FemaleColors.customPink
        }
    }
}
