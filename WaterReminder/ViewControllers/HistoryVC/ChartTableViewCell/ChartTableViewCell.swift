//
//  ChartTableViewCell.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 21/08/23.
//

import UIKit
import DGCharts
import RealmSwift

class ChartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainViewOfChart: UIView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var hydrateBtn: UIButton!
    @IBOutlet weak var weightBtn: UIButton!
    
    let realm = try! Realm()
    var arrTodayData = [TodayRecord]()
    var selectedTodayRecord: TodayRecord?
    var selectedSegment: Int = 0
    var selectedTimeInterval: TimeIntervalSegment = .day

    override func awakeFromNib() {
        super.awakeFromNib()
        mainViewOfChart.layer.cornerRadius = 10
    }

    func waterAmountUpdation() {
        let waterAmountData = realm.objects(WaterAmount.self)
        updateChart(with: waterAmountData)
    }
    
    func updateChart(with data: Results<WaterAmount>) {
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
        dataSet.colors = [UIColor(red: 27/255, green: 174/255, blue: 238/255, alpha: 1)]
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
}
