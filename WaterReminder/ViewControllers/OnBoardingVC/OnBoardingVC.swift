//
//  OnBoardingVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//


import UIKit
import RealmSwift

class OnBoardingVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var letsGoBtn: GradientButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func letsGoBtnTapped(_ sender: GradientButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ChooseGenderVC") as! ChooseGenderVC
        navigationController?.pushViewController(vc, animated: true);
    }
}

