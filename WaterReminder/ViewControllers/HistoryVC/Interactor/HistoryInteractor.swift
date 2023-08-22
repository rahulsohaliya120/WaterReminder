//
//  HistoryInteractor.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import DGCharts
import RealmSwift
import BetterSegmentedControl
import Foundation

enum TimeIntervalSegment: Int {
    case day = 0
    case week = 1
    case month = 2
    case year = 3
}

class HistoryInteractor: PresenterToInteractorHistoryProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterHistoryProtocol?

    func waterAmountUpdation(completion: ([TodayRecord]) -> Void) {
       let realm = try! Realm()
       
       let waterAmountRecord = realm.objects(TodayRecord.self)

       let filteredData = Array(waterAmountRecord.filter { compareDay($0.time, with: Date()) })
       completion(filteredData)
       print(filteredData)
   }
    
    func deleteBtnTapped(dataRecordTableView: UITableView, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment ,completion: (Int) -> Void) {
        let realm = try! Realm()
        let indexToDelete = sender.tag
        
        if indexToDelete >= 0 && indexToDelete < arrTodayData.count {
            let recordToDelete = arrTodayData[indexToDelete]
            let deletedAmount = recordToDelete.waterRecordML
            
            do {
                try realm.write {
                    realm.delete(recordToDelete)
                }
                completion(indexToDelete)
                
                if let waterAmountRecord = realm.objects(WaterAmount.self).first(where: { compareDay($0.date, with: Date()) }) {
                    try realm.write {
                        waterAmountRecord.amountInMilliliters -= deletedAmount
                    }
                }
                
                dataRecordTableView.reloadData()
                
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = dataRecordTableView.cellForRow(at: indexPath) as! ChartTableViewCell

                cell.updateChart(with: realm.objects(WaterAmount.self))
                
                NotificationCenter.default.post(name: Notification.Name("WaterAmountUpdated"), object: nil)
                
            } catch {
                print("Error deleting data: \(error)")
            }
        }
    }
    
    func editBtnTapped(dataRecordTableView: UITableView, completion: (TodayRecord) -> Void, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment, vc: HistoryVC, selectedIndex: Int) {
        let selectedRecord = arrTodayData[sender.tag]
        completion(selectedRecord)
        
        let alert = UIAlertController(title: "Water Details Update", message: "Please add water in ml", preferredStyle: .alert)
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
            
            let waterData = WaterAmount()
            waterData.amountInMilliliters = waterAmount
            waterData.date = currentDate
            
            do {
                try realm.write {
                    selectedRecord.waterRecordML = waterAmount
                }
            } catch {
                print("Error updating TodayRecord: \(error)")
            }
           
            
            do {
                let existingWaterAmount = realm.objects(WaterAmount.self).first(where: { calendar.isDateInToday($0.date) })
                
                if let existingWaterAmount = existingWaterAmount {
                    try! realm.write {
                        existingWaterAmount.amountInMilliliters = waterAmount
                    }
                } else {
                    let waterData = WaterAmount()
                    waterData.amountInMilliliters = waterAmount
                    waterData.date = currentDate
                    try realm.write {
                        realm.add(waterData)
                    }
                }
                let indexPath = IndexPath(row: 0, section: 0)
                let cell = dataRecordTableView.cellForRow(at: indexPath) as! ChartTableViewCell
                cell.updateChart(with: realm.objects(WaterAmount.self))
                vc.selectedIndex = -1
                dataRecordTableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name("TodayRecordDeleted"), object: nil)
            } catch {
                print("Error updating WaterAmount: \(error)")
            }
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
