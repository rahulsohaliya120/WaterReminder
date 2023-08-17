//
//  ChooseGenderVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift

class ChooseGenderVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var chooseGenderLbl: UILabel!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleSelectionBtn: UIButton!
    @IBOutlet weak var femaleSelectionBtn: UIButton!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var backBtn: GradientButton!
    @IBOutlet weak var nextBtn: GradientButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterChooseGenderProtocol?
    var genderEnum = Gender.male
    var userDetails: UserDetails?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        ChooseGenderRouter.createModule(vc: self)
        presenter?.showTitleLbl(titleLbl: chooseGenderLbl)
    }
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: GradientButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: GradientButton) {
        userDetails = UserDetails(gender: genderEnum == .male ? 0 : 1, weight: 0, unit: "", wakeUpSelectedTime: Date(), sleepSelectedTime: Date(), waterReminderTime: Date())

        presenter?.navigateToWeightVC(name: "OnBoarding", withIdentifier: "WeightVC", navigationController: navigationController ?? UINavigationController(), userDetails: userDetails ?? UserDetails(gender: genderEnum == .male ? 0 : 1, weight: 0, unit: "", wakeUpSelectedTime: Date(), sleepSelectedTime: Date(), waterReminderTime: Date()), genderEnum: genderEnum)
    }
    
    @IBAction func maleSelectionBtnTapped(_ sender: UIButton) {
        genderEnum = .male
        presenter?.maleSelectionBtn(maleSelectionBtn: maleSelectionBtn, maleView: maleView, femaleView: femaleView)
    }
    
    @IBAction func femaleSelectionBtnTappe(_ sender: UIButton) {
        genderEnum = .female
        presenter?.femaleSelectionBtn(femaleSelectionBtn: femaleSelectionBtn, maleView: maleView, femaleView: femaleView)
    }
}

extension ChooseGenderVC: PresenterToViewChooseGenderProtocol{
    // TODO: Implement View Output Methods
}
