//
//  HistoryPresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import Foundation
import RealmSwift
import DGCharts

class HistoryPresenter: ViewToPresenterHistoryProtocol {

    // MARK: Properties
    var view: PresenterToViewHistoryProtocol?
    var interactor: PresenterToInteractorHistoryProtocol?
    var router: PresenterToRouterHistoryProtocol?
    
    func showDataRecordTableViewCustomization(dataRecordTableView: UITableView) {
        dataRecordTableView.isHidden = true
        dataRecordTableView.layer.cornerRadius = 10
    }
    
    func showMainViewOfChartCustomization(mainViewOfChart: UIView) {
        mainViewOfChart.layer.cornerRadius = 10
    }
    
    func showUpdateChart(with data: Results<WaterAmount>, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment) {
        interactor?.updateChart(with: data, chartView: chartView, selectedTimeInterval: selectedTimeInterval)
    }
    
    func registerNib(tableView: UITableView, nibName: String, forCellReuseIdentifier: String) {
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: forCellReuseIdentifier)
    }
    
    func showWaterAmountUpdation(completion: ([TodayRecord]) -> Void, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment) {
        interactor?.waterAmountUpdation(completion: completion, chartView: chartView, selectedTimeInterval: selectedTimeInterval)
    }
    
    func deleteBtnTapped(dataRecordTableView: UITableView, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment ,completion: (Int) -> Void) {
        interactor?.deleteBtnTapped(dataRecordTableView: dataRecordTableView, arrTodayData: arrTodayData, sender: sender, chartView: chartView, selectedTimeInterval: selectedTimeInterval, completion: completion)
    }
    
    func editBtnTapped(dataRecordTableView: UITableView, completion: (TodayRecord) -> Void, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment, vc: HistoryVC, selectedIndex: Int) {
        interactor?.editBtnTapped(dataRecordTableView: dataRecordTableView, completion: completion, arrTodayData: arrTodayData, sender: sender, chartView: chartView, selectedTimeInterval: selectedTimeInterval, vc: vc, selectedIndex: selectedIndex)
    }
    
}

extension HistoryPresenter: InteractorToPresenterHistoryProtocol {
    
}
