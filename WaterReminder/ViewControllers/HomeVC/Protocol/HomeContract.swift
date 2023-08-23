//
//  HomeContract.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import Foundation
import WaveAnimationView


// MARK: View Output (Presenter -> View)
protocol PresenterToViewHomeProtocol {
   
}


// MARK: View Input (View -> Presenter)
protocol ViewToPresenterHomeProtocol {
    
    var view: PresenterToViewHomeProtocol? { get set }
    var interactor: PresenterToInteractorHomeProtocol? { get set }
    var router: PresenterToRouterHomeProtocol? { get set }
    
    func navigateToHistoryVC(name: String, withIdentifier: String, navigationController: UINavigationController)
    func navigateToSettingVC(name: String, withIdentifier: String, navigationController: UINavigationController)
    func fetchingDataBaseData(title: String, message: String, vc: HomeVC, wave: WaveAnimationView, updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView)
    func drinkBtnCustomization(drinkBtn: UIButton)
    func tabbarConfiguration(tabbarView: UIView)
    func fetchLastWaterAmountData(updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView)
    func waveAnimationCustomization(wave: WaveAnimationView, bottleView: UIView)
    func updateWaveAnimationProgress(wave: WaveAnimationView, updateProgressLabel: UILabel, bottleView: BottleMaskView)
    func updateWaterAmount(updateProgressLabel: UILabel, completedMlLabel: UILabel, vc: HomeVC, bottleView: BottleMaskView)
}


// MARK: Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorHomeProtocol {
    
    var presenter: InteractorToPresenterHomeProtocol? { get set }
    
    func fetchData(title: String, message: String, vc: HomeVC, wave: WaveAnimationView, updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView)
    func getLastDataFromDatabase(updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView)
}


// MARK: Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterHomeProtocol {
    
}


// MARK: Router Input (Presenter -> Router)
protocol PresenterToRouterHomeProtocol {
    func pushToHistoryVC(name: String, withIdentifier: String, navigationController: UINavigationController)
    func pushToSettingVC(name: String, withIdentifier: String, navigationController: UINavigationController)
}
