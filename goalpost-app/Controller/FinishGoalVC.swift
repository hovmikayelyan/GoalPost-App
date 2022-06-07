//
//  FinishGoalVC.swift
//  goalpost-app
//
//  Created by Hovhannes Mikayelyan on 6/7/22.
//  Copyright © 2022 Hovhannes Mikayelyan. All rights reserved.
//

import UIKit

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDecription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType){
        self.goalDecription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
        pointsTextField.delegate = self
    }

    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        //Pass Data into Core Data Goal Model
    }
    
}
