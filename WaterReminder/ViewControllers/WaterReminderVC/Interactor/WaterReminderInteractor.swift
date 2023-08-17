//
//  WaterReminderInteractor.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 17/08/23.
//  
//
import UIKit
import Foundation
import RealmSwift

class WaterReminderInteractor: PresenterToInteractorWaterReminderProtocol {

    // MARK: Properties
    var presenter: InteractorToPresenterWaterReminderProtocol?
    
    func fetchDataBaseData(userDetails: UserDetails) {
        let realmData = WaterData()
        realmData.gender = userDetails.gender
        realmData.weight = userDetails.weight
        realmData.unit = userDetails.unit
        realmData.wakeUpSelectedTime = userDetails.wakeUpSelectedTime
        realmData.SleepSelectedTime = userDetails.sleepSelectedTime
        realmData.waterReminderTime = userDetails.waterReminderTime
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(realmData)
        }
    }
}
