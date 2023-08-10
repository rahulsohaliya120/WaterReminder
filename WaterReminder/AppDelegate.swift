//
//  AppDelegate.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//

import UIKit
import RealmSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let realm = try! Realm()
    
    class func sharedApplication() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        print(defaults.bool(forKey: "USER_LOGIN"))
        
        if defaults.bool(forKey: "USER_LOGIN") {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
            navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
        } else {
            let storyboard = UIStoryboard(name: "OnBoarding", bundle: nil)
            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "OnBoardingVC") as UIViewController
            navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Notification permissions granted.")
            } else {
                print("Notification permissions denied.")
            }
        }
        
        let getData = realm.objects(WaterAmount.self)
        
        if getData.isEmpty {
            let currentDate = Date()
            let waterData = WaterAmount()
            waterData.amountInMilliliters = 0
            waterData.date = currentDate
            
            try! realm.write {
                realm.add(waterData)
            }
        } else {
            let currentDate = Date()
            let calendar = Calendar.current
            
            if let todayDate = getData.first(where: { calendar.isDateInToday($0.date) } ) {
                print(todayDate)
            } else {
                let waterData = WaterAmount()
                waterData.amountInMilliliters = 0
                waterData.date = currentDate
                
                try! realm.write {
                    realm.add(waterData)
                }
            }
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "WaterReminderNotification" {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            vc.genderEnum = .male
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let navigationController = appDelegate.window?.rootViewController as? UINavigationController {
                navigationController.pushViewController(vc, animated: true)
            }
        }
        completionHandler()
    }
}



