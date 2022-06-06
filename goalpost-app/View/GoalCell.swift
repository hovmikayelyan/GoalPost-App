//
//  GoalCell.swift
//  goalpost-app
//
//  Created by Hovhannes Mikayelyan on 5/30/22.
//  Copyright © 2022 Hovhannes Mikayelyan. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    
    func configureCell(description: String, type: GoalType, goalProgressAmount: Int){
        self.goalDescriptionLbl.text = description
        self.goalTypeLbl.text = type.rawValue
        self.goalProgressLbl.text = String(describing: goalProgressAmount)
    }
    
}
