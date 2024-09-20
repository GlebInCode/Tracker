//
//  GradientBoarderView.swift
//  Tracker
//
//  Created by Глеб Хамин on 20.09.2024.
//

import UIKit

class GradientBorderView: UIView {
    var gradientColors: [UIColor] = [UIColor(hex: "#007BFA")!, UIColor(hex: "#46E69D")!, UIColor(hex: "#FD4C49")!] {
        didSet {
            setNeedsLayout()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let gradient = UIImage.gradientImage(bounds: bounds, colors: gradientColors)
        layer.borderColor = UIColor(patternImage: gradient).cgColor
    }
}
