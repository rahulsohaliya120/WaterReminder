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
    
    var wave: WaveAnimationView!
    var genderEnum = Gender.male
    var progressTimer: Timer?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateWaterAmountLabels), name: Notification.Name("WaterAmountUpdated"), object: nil)
        updateWaterAmountLabels()
        
        drinkBtn.layer.cornerRadius = 26
        
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: bottleView.bounds.size), color: UIColor.blue.withAlphaComponent(0.5))
        bottleView.addSubview(wave)
        
        wave.frontColor = Constants.Colors.WaveColors.front
        wave.backColor = Constants.Colors.WaveColors.back
        bottleView.layer.borderColor = UIColor.black.cgColor
        
        wave.mask = bottleView.mask
        bottleView.mask = wave.mask
        
        let getData = realm.objects(WaterAmount.self).last
        
        updateProgressLabel.text = "\(getData?.amountInMilliliters ?? 0) ml"
        completedMlLabel.text = "\(getData?.amountInMilliliters ?? 0) ml"
        
        tabbarConfiguration()
        updateWaveAnimationProgress()
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
    
    func updateWaveAnimationProgress() {
        let getData = realm.objects(WaterAmount.self).last
        let totalWaterConsumed = getData?.amountInMilliliters ?? 0
        let newProgress = Float(totalWaterConsumed) / 4000.0
        wave.progress = newProgress
        updateProgressLabel.text = "\(totalWaterConsumed) ml"
        wave.startAnimation() 
    }
    
    @objc func updateWaterAmountLabels() {
        DispatchQueue.main.async {
            if let todayWaterAmount = self.realm.objects(WaterAmount.self).filter({ Calendar.current.isDateInToday($0.date)}).first {
                self.updateProgressLabel.text = "\(todayWaterAmount.amountInMilliliters) ml"
                self.completedMlLabel.text = "\(todayWaterAmount.amountInMilliliters) ml"
                self.updateWaveAnimationProgress()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func tabbarConfiguration() {
        tabbarView.layer.cornerRadius = 20
    }
    
    // MARK: - Actions
    
    @IBAction func drinkBtnTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Water Details", message: "Please add water in ml", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Water data"
            field.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self] _ in
            guard let waterDataTextField = alert.textFields?.first,
                  let waterDataText = waterDataTextField.text,
                  let waterAmount = Int(waterDataText) else {
                      return
                  }
            
            if waterAmount > 4000 {
                let errorAlert = UIAlertController(title: "Error", message: "Water amount should not exceed 4000 ml", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }
            
            let realm = try! Realm()
            let currentDate = Date()
            let calendar = Calendar.current
            let getData = realm.objects(WaterAmount.self)
            
            let waterData = WaterAmount()
            waterData.amountInMilliliters = waterAmount
            waterData.date = currentDate
            
            do {
                if let todayDate = getData.first(where: { calendar.isDateInToday($0.date) } ) {
                    print(todayDate)
                    try! realm.write({
                        todayDate.amountInMilliliters += waterAmount
                    })
                    
                } else {
                    let waterData = WaterAmount()
                    waterData.amountInMilliliters = 0
                    waterData.date = currentDate
                    
                    try! realm.write {
                        realm.add(waterData)
                    }
                }
                print("Water Data added and saved to Realm")
            }
            
            do {
                let waterData = TodayRecord()
                waterData.waterRecordML = waterAmount
                waterData.time = currentDate
                
                try! realm.write {
                    realm.add(waterData)
                }
            }
            
            let updatedData = realm.objects(WaterAmount.self).last
            
            updateProgressLabel.text = "\(updatedData?.amountInMilliliters ?? 0) ml"
            completedMlLabel.text = "\(updatedData?.amountInMilliliters ?? 0) ml"
            
            let totalWaterConsumed = updatedData?.amountInMilliliters ?? 0
            let newProgress = Float(totalWaterConsumed) / 4000.0
            wave.progress = newProgress
            updateProgressLabel.text = "\(totalWaterConsumed) ml"
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func graphBtnTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "HistoryVC") as! HistoryVC
        navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func settingBtnTapped(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        navigationController?.pushViewController(vc, animated: true);
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        
    }
}

