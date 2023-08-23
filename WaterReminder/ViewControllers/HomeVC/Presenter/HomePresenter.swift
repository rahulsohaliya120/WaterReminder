//
//  HomePresenter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//
import UIKit
import Foundation
import WaveAnimationView
import RealmSwift

class HomePresenter: ViewToPresenterHomeProtocol {
    
    // MARK: Properties
    var view: PresenterToViewHomeProtocol?
    var interactor: PresenterToInteractorHomeProtocol?
    var router: PresenterToRouterHomeProtocol?
    

    func navigateToHistoryVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        router?.pushToHistoryVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController)
    }
    
    func navigateToSettingVC(name: String, withIdentifier: String, navigationController: UINavigationController) {
        router?.pushToSettingVC(name: name, withIdentifier: withIdentifier, navigationController: navigationController)
    }
    
    func fetchingDataBaseData(title: String, message: String, vc: HomeVC, wave: WaveAnimationView, updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView) {
        interactor?.fetchData(title: title, message: message, vc: vc, wave: wave, updateProgressLabel: updateProgressLabel, completedMlLabel: completedMlLabel, bottleView: bottleView)
    }
    
    func drinkBtnCustomization(drinkBtn: UIButton) {
        drinkBtn.layer.cornerRadius = 26
    }
    
    func tabbarConfiguration(tabbarView: UIView) {
        tabbarView.layer.cornerRadius = 20
    }
    
    func fetchLastWaterAmountData(updateProgressLabel: UILabel, completedMlLabel: UILabel, bottleView: BottleMaskView) {
        interactor?.getLastDataFromDatabase(updateProgressLabel: updateProgressLabel, completedMlLabel: completedMlLabel, bottleView: bottleView)
    }
    
    func waveAnimationCustomization(wave: WaveAnimationView, bottleView: UIView) {
        wave.frontColor = Constants.Colors.WaveColors.front
        wave.backColor = Constants.Colors.WaveColors.back
        bottleView.layer.borderColor = UIColor.black.cgColor
        
        wave.mask = bottleView.mask
        bottleView.mask = wave.mask
    }
    
    func updateWaveAnimationProgress(wave: WaveAnimationView, updateProgressLabel: UILabel, bottleView: BottleMaskView) {
        let realm = try! Realm()
        let getData = realm.objects(WaterAmount.self).last
        let totalWaterConsumed = getData?.amountInMilliliters ?? 0
        let newProgress = Float(totalWaterConsumed) / 4000.0
        wave.progress = newProgress
        updateProgressLabel.text = "\(totalWaterConsumed) ml"
        wave.startAnimation()
        if totalWaterConsumed == 0 {
            bottleView.isHidden = true
        } else {
            bottleView.isHidden = false
        }
    }
    
    
    func updateWaterAmount(updateProgressLabel: UILabel, completedMlLabel: UILabel, vc: HomeVC, bottleView: BottleMaskView) {
        if let todayWaterAmount = vc.realm.objects(WaterAmount.self).filter({ Calendar.current.isDateInToday($0.date)}).first {
            if todayWaterAmount.amountInMilliliters == 0 {
                bottleView.isHidden = true
            } else {
                bottleView.isHidden = false
            }
            vc.updateProgressLabel.text = "\(todayWaterAmount.amountInMilliliters) ml"
            vc.completedMlLabel.text = "\(todayWaterAmount.amountInMilliliters) ml"
        }
    }
}

extension HomePresenter: InteractorToPresenterHomeProtocol {
    
}
