//
//  HomeVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//
// MARK: - Navigation


import UIKit
import WaveAnimationView
import RealmSwift

class HomeVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var drinkBtn: UIButton!
    @IBOutlet weak var tabbarView: UIView!
    @IBOutlet weak var graphBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bottleView: BottleMaskView!
    @IBOutlet weak var updateProgressLabel: UILabel!
    @IBOutlet weak var completedMlLabel: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterHomeProtocol?
    var wave: WaveAnimationView!
    var genderEnum = Gender.male
    var progressTimer: Timer?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HomeRouter.createModule(vc: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWaterAmountLabels), name: Notification.Name("WaterAmountUpdated"), object: nil)

        drinkBtnCustomize()
        waveAnimationCustomization()
        getLastDataFromDatabase()
        tabbarConfiguration()
        updateWaveAnimationProgress()
        updateWaterAmountLabels()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        wave.stopAnimation()
        progressTimer?.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWaterAmountLabels()
    }
    
    func getLastDataFromDatabase() {
        presenter?.fetchLastWaterAmountData(updateProgressLabel: updateProgressLabel, completedMlLabel: completedMlLabel)
    }
    
    func waveAnimationCustomization() {
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: bottleView.bounds.size), color: UIColor.blue.withAlphaComponent(0.5))
        bottleView.addSubview(wave)
        presenter?.waveAnimationCustomization(wave: wave, bottleView: bottleView)
    }
    
    func drinkBtnCustomize() {
        presenter?.drinkBtnCustomization(drinkBtn: drinkBtn)
    }
    
    func updateWaveAnimationProgress() {
        presenter?.updateWaveAnimationProgress(wave: wave, updateProgressLabel: updateProgressLabel, bottleView: bottleView)
    }
    
    @objc func updateWaterAmountLabels() {
        presenter?.updateWaterAmount(updateProgressLabel: updateProgressLabel, completedMlLabel: completedMlLabel, vc: self, bottleView: bottleView)
        self.updateWaveAnimationProgress()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func tabbarConfiguration() {
        presenter?.tabbarConfiguration(tabbarView: tabbarView)
    }
    
    // MARK: - Actions
    
    @IBAction func drinkBtnTapped(_ sender: UIButton) {
        presenter?.fetchingDataBaseData(title: "Water Details", message: "Please add water in ml", vc: self, wave: wave, updateProgressLabel: updateProgressLabel, completedMlLabel: completedMlLabel)
    }
    
    @IBAction func graphBtnTapped(_ sender: UIButton) {
        presenter?.navigateToHistoryVC(name: "Home", withIdentifier: "HistoryVC", navigationController: navigationController!)
    }
    
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        presenter?.navigateToSettingVC(name: "Home", withIdentifier: "SettingVC", navigationController: navigationController!)
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        
    }
}

extension HomeVC: PresenterToViewHomeProtocol{
    // TODO: Implement View Output Methods
}
