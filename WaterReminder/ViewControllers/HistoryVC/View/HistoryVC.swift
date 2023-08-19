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
    var presenter: ViewToPresenterHistoryProtocol?
    let realm = try! Realm()
    var selectedSegment: Int = 0
    var selectedTimeInterval: TimeIntervalSegment = .day
    var selectedIndex: Int = -1
    var arrTodayData = [TodayRecord]()
    var selectedTodayRecord: TodayRecord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryRouter.createModule(vc: self)
        configureSegment()
        nibRegister()
        dataRecordTableViewCustomization()
        mainViewOfChartCustomization()
        configureTableHeaderView()
        waterAmountUpdation()
        
        NotificationCenter.default.post(name: Notification.Name("WaterAmountUpdated"), object: nil)
    }
    
    func waterAmountUpdation() {
        presenter?.showWaterAmountUpdation(completion: { arrTodayData in
            self.arrTodayData = arrTodayData
        }, chartView: chartView, selectedTimeInterval: selectedTimeInterval)
    }
    
    private func dataRecordTableViewCustomization() {
        presenter?.showDataRecordTableViewCustomization(dataRecordTableView: dataRecordTableView)
    }
    
    private func mainViewOfChartCustomization() {
        presenter?.showMainViewOfChartCustomization(mainViewOfChart: mainViewOfChart)
    }
    
    private func updateChart(with data: Results<WaterAmount>) {
        presenter?.showUpdateChart(with: data, chartView: chartView, selectedTimeInterval: selectedTimeInterval)
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
        presenter?.registerNib(tableView: dataRecordTableView, nibName: "DataRecordTableViewCell", forCellReuseIdentifier: "DataRecordTableViewCell")
    }
    
    private func configureTableHeaderView() {
        let headerView = HeaderTableView(frame: CGRect(x: 0, y: 0, width: dataRecordTableView.bounds.width, height: 50))
        dataRecordTableView.tableHeaderView = headerView
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
        presenter?.deleteBtnTapped(dataRecordTableView: dataRecordTableView, arrTodayData: arrTodayData, sender: sender, chartView: chartView, selectedTimeInterval: selectedTimeInterval, completion: { index in
            arrTodayData.remove(at: index)
        })
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        presenter?.editBtnTapped(dataRecordTableView: dataRecordTableView, completion: { selectedRecord in
            self.selectedTodayRecord = selectedRecord
        }, arrTodayData: arrTodayData, sender: sender, chartView: chartView, selectedTimeInterval: selectedTimeInterval, vc: self, selectedIndex: -1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dataRecordTableView.reloadData()
    }
}

extension HistoryVC: PresenterToViewHistoryProtocol {
    // TODO: Implement View Output Methods
}


