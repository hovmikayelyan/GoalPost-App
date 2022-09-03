//
//  UIButtonExt.swift
//  goalpost-app
//
//  Created by Hovhannes Mikayelyan on 03.09.22.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.3882352941, green: 0.9019607843, blue: 0.8862745098, alpha: 1)
    }
    func setDeselectedColor(){
        self.backgroundColor = #colorLiteral(red: 0, green: 0.7803921569, blue: 0.7450980392, alpha: 0.2464734008)
    }
}
