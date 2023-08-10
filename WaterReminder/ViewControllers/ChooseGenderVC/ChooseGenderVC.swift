//
//  ChooseGenderVC.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 27/07/23.
//
// MARK: - Navigation

import UIKit
import RealmSwift

enum Gender {
    case male
    case female
}

class ChooseGenderVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var chooseGenderLbl: UILabel!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleSelectionBtn: UIButton!
    @IBOutlet weak var femaleSelectionBtn: UIButton!
    @IBOutlet weak var maleLbl: UILabel!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var backBtn: GradientButton!
    @IBOutlet weak var nextBtn: GradientButton!
    
    // MARK: - Properties
    
    var genderEnum = Gender.male
    var userDetails: UserDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTitleLbl()
    }
    
    private func mainTitleLbl() {
        let gradient = getGradientLayer(bounds: chooseGenderLbl.bounds)
        chooseGenderLbl.textColor = gradientColor(bounds: chooseGenderLbl.bounds, gradientLayer: gradient)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image!)
    }
    func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = Constants.Colors.chooseGenderColor.colorful
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
    
    // MARK: - Actions
    
    @IBAction func backBtnTapped(_ sender: GradientButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextBtnTapped(_ sender: GradientButton) {
        userDetails = UserDetails(gender: genderEnum == .male ? 0 : 1, weight: 0, unit: "", wakeUpSelectedTime: Date(), sleepSelectedTime: Date(), waterReminderTime: Date())
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "OnBoarding", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "WeightVC") as! WeightVC
        vc.genderEnum = genderEnum
        vc.userDetails = userDetails
        navigationController?.pushViewController(vc, animated: true);
    }
    @IBAction func maleSelectionBtnTapped(_ sender: UIButton) {
        genderEnum = .male
        maleView.layer.borderWidth = 1
        maleView.layer.borderColor = UIColor.darkGray.cgColor
        maleView.layer.cornerRadius = 5
        
        femaleView.layer.borderWidth = 0
        femaleView.layer.borderColor = UIColor.darkGray.cgColor
        femaleView.layer.cornerRadius = 5
    }
    
    @IBAction func femaleSelectionBtnTappe(_ sender: UIButton) {
        genderEnum = .female
        femaleView.layer.borderWidth = 1
        femaleView.layer.borderColor = UIColor.darkGray.cgColor
        femaleView.layer.cornerRadius = 5
        
        maleView.layer.borderWidth = 0
        maleView.layer.borderColor = UIColor.darkGray.cgColor
        maleView.layer.cornerRadius = 5
    }
}
