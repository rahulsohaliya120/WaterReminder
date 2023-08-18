//
//  SettingVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 31/07/23.
//
// MARK: - Navigation

import UIKit

class SettingVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var reminderSettingView: UIView!
    @IBOutlet weak var reminderSettingsOptionsView: UIView!
    @IBOutlet weak var timeForwardBtn: UIButton!
    @IBOutlet weak var bellBtn: UIButton!
    @IBOutlet weak var bellRingBtn: UIButton!
    @IBOutlet weak var generalView: UIView!
    @IBOutlet weak var generalOptionsView: UIView!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var dumbleBtn: UIButton!
    @IBOutlet weak var targetBtn: UIButton!
    @IBOutlet weak var languageBtn: UIButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterSettingProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingRouter.createModule(vc: self)
        configureViews()
    }
    
    private func configureViews() {
        presenter?.configureViews(reminderSettingView: reminderSettingView, reminderSettingsOptionsView: reminderSettingsOptionsView, generalView: generalView, generalOptionsView: generalOptionsView)
    }
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func timeForwardBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func bellBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func bellRingBtnTapped(_ sender: UIButton) {
        presenter?.navigateToWaterReminderVC(name: "OnBoarding", withIdentifier: "WaterReminderVC", navigationController: navigationController!)
    }
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        presenter?.navigateToOnBoardingVC(name: "OnBoarding", withIdentifier: "OnBoardingVC", navigationController: navigationController!)
    }
    
    @IBAction func dumbleBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func targetBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func languageBtnTapped(_ sender: UIButton) {
        
    }
}

extension SettingVC: PresenterToViewSettingProtocol{
    // TODO: Implement View Output Methods
}
