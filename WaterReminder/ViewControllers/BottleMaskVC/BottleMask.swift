//
//  BottleMask.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 31/07/23.
//

import Foundation
import UIKit

class BottleMaskView: UIView {
    private let bottleMaskImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        if let bottleMaskImage = UIImage(named: "ic_union") {
            bottleMaskImageView.image = bottleMaskImage
        }
        
        bottleMaskImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottleMaskImageView)
        NSLayoutConstraint.activate([
            bottleMaskImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottleMaskImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottleMaskImageView.topAnchor.constraint(equalTo: topAnchor),
            bottleMaskImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        self.mask = bottleMaskImageView
    }
}








