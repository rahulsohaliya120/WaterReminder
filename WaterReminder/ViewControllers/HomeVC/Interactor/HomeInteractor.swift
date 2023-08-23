//
//  HomeInteractor.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import WaveAnimationView
import RealmSwift
import Foundation

class HomeInteractor: PresenterToInteractorHomeProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterHomeProtocol?
    
    func fetchData(title: String, message: String, vc: HomeVC, wave: WaveAnimationView, updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView) {
        
        let alert = UIAlertController(title: "Water Details", message: "Please add water in ml", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Water data"
            field.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            guard let waterDataTextField = alert.textFields?.first,
                  let waterDataText = waterDataTextField.text,
                  let waterAmount = Int(waterDataText) else {
                      return
                  }
            
            if waterAmount > 4000 {
                let errorAlert = UIAlertController(title: "Error", message: "Water amount should not exceed 4000 ml", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc.present(errorAlert, animated: true, completion: nil)
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
            if updatedData?.amountInMilliliters == 0 {
                bottleView.isHidden = true
            } else {
                bottleView.isHidden = false
            }
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func getLastDataFromDatabase(updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView) {
        let realm = try! Realm()
        let getData = realm.objects(WaterAmount.self).last

        updateProgressLabel.text = "\(getData?.amountInMilliliters ?? 0) ml"
        completedMlLabel.text = "\(getData?.amountInMilliliters ?? 0) ml"
        if getData?.amountInMilliliters == 0 {
            bottleView.isHidden = true
        } else {
            bottleView.isHidden = false
        }
    }
}
