//
//  Constants.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 10/08/23.
//

import UIKit

struct Constants {
    
    struct Colors {
        
        struct chooseGenderColor {
            static let colorful = [UIColor(red: 27/255, green: 174/255, blue: 238/255, alpha: 1).cgColor, UIColor(red: 255/255, green: 69/255, blue: 147/255, alpha: 1).cgColor]
        }
        
        struct MaleColors {
            static let customBlue = UIColor(red: 27/255, green: 174/255, blue: 238/255, alpha: 1)
        }
        
        struct FemaleColors {
            static let customPink = UIColor(red: 255/255, green: 69/255, blue: 147/255, alpha: 1)
        }
        
        struct WaveColors {
            static let front = UIColor(red: 112/255, green: 189/255, blue: 242/255, alpha: 1).withAlphaComponent(0.5)
            static let back = UIColor(red: 112/255, green: 189/255, blue: 242/255, alpha: 1).withAlphaComponent(0.5)
        }
        
        struct SegmentColors {
            static let normalTextColor = UIColor(red: 113/255, green: 212/255, blue: 255/255, alpha: 0.9)
            static let selectedTextColor = UIColor(red: 113/255, green: 212/255, blue: 255/255, alpha: 1)
        }
        
        struct ChartViewBarColor {
           static let chartBarColor = [UIColor(red: 27/255, green: 174/255, blue: 238/255, alpha: 1)]
        }
    }
}
