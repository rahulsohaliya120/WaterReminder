//
//  HistoryContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import Foundation
import DGCharts
import RealmSwift


// MARK: View Output (Presenter -> View)
protocol PresenterToViewHistoryProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterHistoryProtocol {
    
    var view: PresenterToViewHistoryProtocol? { get set }
    var interactor: PresenterToInteractorHistoryProtocol? { get set }
    var router: PresenterToRouterHistoryProtocol? { get set }
    
    func showDataRecordTableViewCustomization(dataRecordTableView: UITableView)
    func registerNib(tableView: UITableView, nibName: String, forCellReuseIdentifier: String)
    func showWaterAmountUpdation(completion: ([TodayRecord]) -> Void)
    func deleteBtnTapped(dataRecordTableView: UITableView, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment ,completion: (Int) -> Void)
    func editBtnTapped(dataRecordTableView: UITableView, completion: (TodayRecord) -> Void, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment, vc: HistoryVC, selectedIndex: Int)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorHistoryProtocol {
    
    var presenter: InteractorToPresenterHistoryProtocol? { get set }
    func waterAmountUpdation(completion: ([TodayRecord]) -> Void)
    func deleteBtnTapped(dataRecordTableView: UITableView, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment ,completion: (Int) -> Void)
    func editBtnTapped(dataRecordTableView: UITableView, completion: (TodayRecord) -> Void, arrTodayData: [TodayRecord], sender: UIButton, chartView: BarChartView, selectedTimeInterval: TimeIntervalSegment, vc: HistoryVC, selectedIndex: Int)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterHistoryProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterHistoryProtocol {
    
}
