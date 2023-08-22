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
    @IBOutlet weak var dataRecordTableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: - Properties
    var presenter: ViewToPresenterHistoryProtocol?
    let realm = try! Realm()
    var selectedSegment: Int = 0
    var selectedTimeInterval: TimeIntervalSegment = .day
    var selectedIndex: Int = -1
    var arrTodayData = [TodayRecord]()
    var selectedTodayRecord: TodayRecord?
    var isHydrateBtnSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HistoryRouter.createModule(vc: self)
        configureSegment()
        nibRegister()
        dataRecordTableViewCustomization()
        presenter?.showWaterAmountUpdation(completion: { arrTodayData in
            self.arrTodayData = arrTodayData
        })
        
        NotificationCenter.default.post(name: Notification.Name("WaterAmountUpdated"), object: nil)
    }
    
    private func dataRecordTableViewCustomization() {
        presenter?.showDataRecordTableViewCustomization(dataRecordTableView: dataRecordTableView)
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
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            if let cell = dataRecordTableView.cellForRow(at: indexPath) as? ChartTableViewCell {
                let waterAmountData = realm.objects(WaterAmount.self)
                cell.updateChart(with: waterAmountData)
            }
            dataRecordTableView.reloadData()
        }
    }
    
    private func nibRegister() {
        presenter?.registerNib(tableView: dataRecordTableView, nibName: "DataRecordTableViewCell", forCellReuseIdentifier: "DataRecordTableViewCell")
        presenter?.registerNib(tableView: dataRecordTableView, nibName: "ChartTableViewCell", forCellReuseIdentifier: "ChartTableViewCell")
    }
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isHydrateBtnSelected {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHydrateBtnSelected {
            if section == 0 {
                return 1
            } else {
                return arrTodayData.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isHydrateBtnSelected {
            
            if indexPath.section == 0 {
                
                let cell: ChartTableViewCell = dataRecordTableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath) as! ChartTableViewCell
                cell.selectedTimeInterval = self.selectedTimeInterval
                cell.waterAmountUpdation()
                cell.hydrateBtn.tag = indexPath.row
                cell.hydrateBtn.addTarget(self, action: #selector(hydrateButtonTapped(_:)), for: .touchUpInside)
                return cell
                
            } else {
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
            
        } else {
            let cell: ChartTableViewCell = dataRecordTableView.dequeueReusableCell(withIdentifier: "ChartTableViewCell", for: indexPath) as! ChartTableViewCell
            cell.selectedTimeInterval = self.selectedTimeInterval
            cell.waterAmountUpdation()
            cell.hydrateBtn.tag = indexPath.row
            cell.hydrateBtn.addTarget(self, action: #selector(hydrateButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    @objc func hydrateButtonTapped(_ sender: UIButton) {
        isHydrateBtnSelected = true
        dataRecordTableView.reloadData()
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = dataRecordTableView.cellForRow(at: indexPath) as! ChartTableViewCell
        presenter?.deleteBtnTapped(dataRecordTableView: dataRecordTableView, arrTodayData: arrTodayData, sender: sender, chartView: cell.chartView, selectedTimeInterval: selectedTimeInterval, completion: { index in
            arrTodayData.remove(at: index)
        })
    }
    
    @objc func editButtonTapped(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = dataRecordTableView.cellForRow(at: indexPath) as! ChartTableViewCell
        presenter?.editBtnTapped(dataRecordTableView: dataRecordTableView, completion: { selectedRecord in
            self.selectedTodayRecord = selectedRecord
        }, arrTodayData: arrTodayData, sender: sender, chartView: cell.chartView, selectedTimeInterval: selectedTimeInterval, vc: self, selectedIndex: -1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        dataRecordTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let headerView = HeaderTableView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
            return headerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : 0
    }
}

extension HistoryVC: PresenterToViewHistoryProtocol {
    // TODO: Implement View Output Methods
}


