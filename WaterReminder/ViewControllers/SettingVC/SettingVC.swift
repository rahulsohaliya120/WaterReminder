//
//  SettingVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 31/07/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift

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
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        reminderSettingView.layer.cornerRadius = 10
        reminderSettingsOptionsView.layer.cornerRadius = 10
        generalView.layer.cornerRadius = 10
        generalOptionsView.layer.cornerRadius = 10
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
        let waterAmountRecord = realm.objects(WaterData.self)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WaterReminderVC") as! WaterReminderVC
        if let firstRecord = waterAmountRecord.last {
            let genderData = firstRecord.gender
            vc.genderEnum = genderData == 0 ? .male : .female
            print("Gender Data: \(genderData)")
        }
        navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "USER_LOGIN")
        let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        let rootViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as UIViewController
        navigationController.viewControllers = [rootViewController]
        AppDelegate.sharedApplication().window?.rootViewController = navigationController
    }
    
    @IBAction func dumbleBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func targetBtnTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func languageBtnTapped(_ sender: UIButton) {
        
    }
}
