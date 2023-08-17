//
//  DatabaseClass.swift
//  WaterReminder
//
//  Created by Rahul on 28/07/23.
//
import Foundation
import RealmSwift

class WaterData: Object {
    @Persisted var gender: Int = 0
    @Persisted var weight: Int = 0
    @Persisted var unit: String = ""
    @Persisted dynamic var wakeUpSelectedTime: Date = Date()
    @Persisted dynamic var SleepSelectedTime: Date = Date()
    @Persisted dynamic var waterReminderTime: Date = Date()
}

class WaterAmount: Object {
    @Persisted var date: Date = Date()
    @Persisted var amountInMilliliters: Int = 0
}

class TodayRecord: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var time: Date = Date()
    @Persisted var waterRecordML: Int = 0
}
