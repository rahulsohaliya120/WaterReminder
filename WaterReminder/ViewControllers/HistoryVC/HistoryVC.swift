//
//  HistoryVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 31/07/23.
//
// MARK: - Navigation

import UIKit
import BetterSegmentedControl
import DGCharts
import RealmSwift

enum TimeIntervalSegment: Int {
    case day = 0
    case week = 1
    case month = 2
    case year = 3
}

class HistoryVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var segmentController: BetterSegmentedControl!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var dataRecordTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var hydrateBtn: UIButton!
    @IBOutlet weak var weightBtn: UIButton!
    @IBOutlet weak var mainViewOfChart: UIView!
    
    // MARK: - Properties
    
    let realm = try! Realm()
    var selectedSegment: Int = 0
    var selectedTimeInterval: TimeIntervalSegment = .day
    var selectedIndex: Int = -1
    var arrTodayData = [TodayRecord]()
    var selectedTodayRecord: TodayRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegment()
        nibRegister()
        dataRecordTableView.isHidden = true
        configureTableHeaderView()
        dataRecordTableView.layer.cornerRadius = 10
        mainViewOfChart.layer.cornerRadius = 10
        
        let waterAmountData = realm.objects(WaterAmount.self)
        updateChart(with: waterAmountData)
        
        let waterAmountRecord = realm.objects(TodayRecord.self)
        
        let filteredData = Array(waterAmountRecord.filter { [self] in compareDay($0.time, with: Date()) })
        arrTodayData = filteredData
        print(filteredData)
        
        NotificationCenter.default.post(name: Notification.Name("WaterAmountUpdated"), object: nil)
    }
    
    private func updateChart(with data: Results<WaterAmount>) {
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
    
    private func compareDate(_ date: Date, isBetween startDate: Date, and endDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, equalTo: startDate, toGranularity: .weekOfYear) ||
        calendar.isDate(date, equalTo: endDate, toGranularity: .weekOfYear) ||
        (date > startDate && date < endDate)
    }
    
    private func calculateWeeklyMeasurement(data: Results<WaterAmount>, startDate: Date, endDate: Date) -> Int {
        let weekData = data.filter { self.compareDate($0.date, isBetween: startDate, and: endDate) }
        let totalMeasurement = weekData.reduce(0) { $0 + $1.amountInMilliliters }
        return totalMeasurement
    }
    
    private func calculateMonthlyMeasurement(data: Results<WaterAmount>, startDate: Date, endDate: Date) -> Int {
        let monthData = data.filter { self.compareDate($0.date, isBetween: startDate, and: endDate) }
        let totalMeasurement = monthData.reduce(0) { $0 + $1.amountInMilliliters }
        return totalMeasurement
    }
    
    private func calculateYearlyMeasurement(data: Results<WaterAmount>, startDate: Date, endDate: Date) -> Int {
        let yearData = data.filter { self.compareDate($0.date, isBetween: startDate, and: endDate) }
        let totalMeasurement = yearData.reduce(0) { $0 + $1.amountInMilliliters }
        return totalMeasurement
    }
    
    private func compareDay(_ date: Date, with day: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: day)
    }
    
    private func configureSegment() {
        segmentController.segments = LabelSegment.segments(withTitles: ["D", "W", "M", "Y"],
                                                           normalFont: .systemFont(ofSize: 14.0),
                                                           normalTextColor: Constants.Colors.SegmentColors.normalTextColor,
                                                           selectedFont: .systemFont(ofSize: 14.0),
                                                           selectedTextColor: Constants.Colors.SegmentColors.selectedTextColor)
        segmentController.addTarget(self, action: #selector(segmentControllerValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentControllerValueChanged(_ sender: BetterSegmentedControl) {
        if let selectedSegmentIndex = TimeIntervalSegment(rawValue: Int(sender.index)) {
            selectedTimeInterval = selectedSegmentIndex
            let waterAmountData = realm.objects(WaterAmount.self)
            updateChart(with: waterAmountData)
        }
    }
    
    private func nibRegister() {
        let nibFile: UINib = UINib(nibName: "DataRecordTableViewCell", bundle: nil)
        dataRecordTableView.register(nibFile, forCellReuseIdentifier: "DataRecordTableViewCell")
        dataRecordTableView.separatorStyle = .none
    }
    
    private func configureTableHeaderView() {
        let headerView = HeaderTableView(frame: CGRect(x: 0, y: 0, width: dataRecordTableView.bounds.width, height: 50))
        dataRecordTableView.tableHeaderView = headerView
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if !dataRecordTableView.isHidden {
            dataRecordTableView.isHidden = false
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if !dataRecordTableView.isHidden {
            dataRecordTableView.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hydrateBtnTapped(_ sender: UIButton) {
        dataRecordTableView.isHidden = false
    }
    
    @IBAction func weightBtnTapped(_ sender: UIButton) {
        
    }
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTodayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DataRecordTableViewCell = dataRecordTableView.dequeueReusableCell(withIdentifier: "DataRecordTableViewCell", for: indexPath) as! DataRecordTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        
        cell.waterLbl.text = "\(arrTodayData[indexPath.row].waterRecordML) ml"
        cell.bottomWaterLbl.text = "\(arrTodayData[indexPath.row].waterRecordML) ml"
        
        let timeString = dateFormatter.string(from: arrTodayData[indexPath.row].time)
        cell.topTimeLbl.text = timeString
        cell.bottomTimeLbl.text = timeString
        
        if indexPath.row == selectedIndex {
            cell.deleteBtn.isHidden = false
            cell.bottomStackView.isHidden = false
            cell.editBtn.isHidden = false
            cell.waterGlassImgView.isHidden = true
        } else {
            cell.bottomStackView.isHidden = true
            cell.waterGlassImgView.isHidden = false
            cell.deleteBtn.isHidden = true
        }
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let indexToDelete = sender.tag
        
        if indexToDelete >= 0 && indexToDelete < arrTodayData.count {
            let recordToDelete = arrTodayData[indexToDelete]
            let deletedAmount = recordToDelete.waterRecordML
            
            do {
                try realm.write {
                    realm.delete(recordToDelete)
                }
                arrTodayData.remove(at: indexToDelete)
                
                if let waterAmountRecord = realm.objects(WaterAmount.self).first(where: { compareDay($0.date, with: Date()) }) {
                    try realm.write {
                        waterAmountRecord.amountInMilliliters -= deletedAmount
                    }
                }
                
                dataRecordTableView.reloadData()
                updateChart(with: realm.objects(WaterAmount.self))
                
                NotificationCenter.default.post(name: Notification.Name("WaterAmountUpdated"), object: nil)
                
            } catch {
                print("Error deleting data: \(error)")
            }
        }
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        
        let selectedRecord = arrTodayData[sender.tag]
        selectedTodayRecord = selectedRecord
        
        let alert = UIAlertController(title: "Water Details Update", message: "Please add water in ml", preferredStyle: .alert)
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
            
            let waterData = WaterAmount()
            waterData.amountInMilliliters = waterAmount
            waterData.date = currentDate
            
            do {
                try realm.write {
                    selectedTodayRecord?.waterRecordML = waterAmount
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
                updateChart(with: realm.objects(WaterAmount.self))
                dataRecordTableView.reloadData()
                NotificationCenter.default.post(name: Notification.Name("TodayRecordDeleted"), object: nil)
            } catch {
                print("Error updating WaterAmount: \(error)")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dataRecordTableView.reloadData()
    }
}




