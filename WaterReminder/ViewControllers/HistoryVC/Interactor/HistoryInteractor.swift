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
    
     func updateChart(with data: Results<WaterAmount>, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment) {
        var dataEntries: [BarChartDataEntry] = []
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        switch selectedTimeInterval {
        case .day:
            for i in 1...10 {
                if let date = calendar.date(byAdding: .day, value: -i + 1, to: today) {
                    let measurement = data.first(where: { compareDay($0.date, with: date) })?.amountInMilliliters ?? 0
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(measurement))
                    dataEntries.append(dataEntry)
                }
            }
        case .week:
            for i in 1...4 {
                if let startDate = calendar.date(byAdding: .weekOfYear, value: -i, to: today),
                   let endDate = calendar.date(byAdding: .weekOfYear, value: -i + 1, to: today) {
                    let weekMeasurement = calculateWeeklyMeasurement(data: data, startDate: startDate, endDate: endDate)
                    let averageMeasurement = weekMeasurement / 7  // Divide by 7 days to get daily average
                    print(averageMeasurement)
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(averageMeasurement))
                    dataEntries.append(dataEntry)
                }
            }
        case .month:
            for i in 1...12 {
                if let startDate = calendar.date(byAdding: .month, value: -i, to: today),
                   let endDate = calendar.date(byAdding: .month, value: -i + 1, to: today) {
                    let monthMeasurement = calculateMonthlyMeasurement(data: data, startDate: startDate, endDate: endDate)
                    let averageMeasurement = monthMeasurement / 30  // Approximate days in a month
                    print(averageMeasurement)
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(averageMeasurement))
                    dataEntries.append(dataEntry)
                }
            }
        case .year:
            for i in 1...5 {
                if let startDate = calendar.date(byAdding: .year, value: -i, to: today),
                   let endDate = calendar.date(byAdding: .year, value: -i + 1, to: today) {
                    let yearMeasurement = calculateYearlyMeasurement(data: data, startDate: startDate, endDate: endDate)
                    let averageMeasurement = yearMeasurement / 365  // Approximate days in a year
                    print(averageMeasurement)
                    let dataEntry = BarChartDataEntry(x: Double(i), y: Double(averageMeasurement))
                    dataEntries.append(dataEntry)
                }
            }
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "ML Measurements")
        dataSet.colors = Constants.Colors.ChartViewBarColor.chartBarColor
        dataSet.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: dataSet)
        data.barWidth = 0.4
        
        chartView.data = data
        
        let maxMeasurement = dataEntries.max(by: { $0.y < $1.y })?.y ?? 0
        let yMaxValue = Double((Int(maxMeasurement) / 4000 + 1) * 4000)
        
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.axisMaximum = yMaxValue
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.granularity = 1
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.leftAxis.labelPosition = .outsideChart
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = 10
        chartView.notifyDataSetChanged()
    }
    
    func waterAmountUpdation(completion: ([TodayRecord]) -> Void, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment) {
       let realm = try! Realm()
       let waterAmountData = realm.objects(WaterAmount.self)
       updateChart(with: waterAmountData, chartView: chartView, selectedTimeInterval: selectedTimeInterval)
       
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
                updateChart(with: realm.objects(WaterAmount.self), chartView: chartView, selectedTimeInterval: selectedTimeInterval)
                
                NotificationCenter.default.post(name: Notification.Name("WaterAmountUpdated"), object: nil)
                
            } catch {
                print("Error deleting data: \(error)")
            }
        }
    }
    
    func editBtnTapped(dataRecordTableView: UITableView, completion: (TodayRecord) -> Void, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment, vc: HistoryVC) {
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
                self.updateChart(with: realm.objects(WaterAmount.self), chartView: chartView, selectedTimeInterval: selectedTimeInterval)
                dataRecordTableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name("TodayRecordDeleted"), object: nil)
            } catch {
                print("Error updating WaterAmount: \(error)")
            }
        }))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
