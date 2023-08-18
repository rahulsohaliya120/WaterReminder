//
//  DataRecordTableViewCell.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 04/08/23.
//

import UIKit

class DataRecordTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var waterGlassImgView: UIImageView!
    @IBOutlet weak var waterLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var bottomWaterLbl: UILabel!
    @IBOutlet weak var bottomTimeLbl: UILabel!
    @IBOutlet weak var topTimeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
