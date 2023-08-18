//
//  UtilityFunctions.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//
import RealmSwift
import Foundation

func compareDay(_ date: Date, with day: Date) -> Bool {
    let calendar = Calendar.current
    return calendar.isDate(date, inSameDayAs: day)
}

func compareDate(_ date: Date, isBetween startDate: Date, and endDate: Date) -> Bool {
   let calendar = Calendar.current
   return calendar.isDate(date, equalTo: startDate, toGranularity: .weekOfYear) ||
   calendar.isDate(date, equalTo: endDate, toGranularity: .weekOfYear) ||
   (date > startDate && date < endDate)
}

func calculateWeeklyMeasurement(data: Results<WaterAmount>, startDate: Date, endDate: Date) -> Int {
   let weekData = data.filter {compareDate($0.date, isBetween: startDate, and: endDate) }
   let totalMeasurement = weekData.reduce(0) { $0 + $1.amountInMilliliters }
   return totalMeasurement
}

func calculateMonthlyMeasurement(data: Results<WaterAmount>, startDate: Date, endDate: Date) -> Int {
   let monthData = data.filter { compareDate($0.date, isBetween: startDate, and: endDate) }
   let totalMeasurement = monthData.reduce(0) { $0 + $1.amountInMilliliters }
   return totalMeasurement
}

func calculateYearlyMeasurement(data: Results<WaterAmount>, startDate: Date, endDate: Date) -> Int {
   let yearData = data.filter { compareDate($0.date, isBetween: startDate, and: endDate) }
   let totalMeasurement = yearData.reduce(0) { $0 + $1.amountInMilliliters }
   return totalMeasurement
}
