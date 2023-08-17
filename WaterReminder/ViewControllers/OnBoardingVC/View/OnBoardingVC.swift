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
    
    // MARK: - Properties
    var presenter: ViewToPresenterOnBoardingProtocol?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        OnBoardingRouter.createModule(vc: self)
        letsGoBtn.addTarget(self, action: #selector(letsGoBtnTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func letsGoBtnTapped() {
        presenter?.navigateToChooseGenderVC(name: "OnBoarding", withIdentifier: "ChooseGenderVC", navigationController: navigationController!)
    }
}

extension OnBoardingVC: PresenterToViewOnBoardingProtocol {
    // TODO: Implement View Output Methods
    
}




