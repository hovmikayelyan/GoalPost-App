//
//  CreateGoalVC.swift
//  goalpost-app
//
//  Created by Hovhannes Mikayelyan on 03.09.22.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var _goal = [
        "type": GoalType.shortTerm,
        "description": ""
    ] as [String : Any]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.bindToKeyboard()
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
        
        goalTextView.delegate = self
    }
    
    
    @IBAction func shortTermBtnWasPressed(_ sender: Any) {
        _goal["type"] = GoalType.shortTerm
        shortTermBtn.setSelectedColor()
        longTermBtn.setDeselectedColor()
    }
    
    @IBAction func longTermBtnWasPressed(_ sender: Any) {
        _goal["type"] = GoalType.longTerm
        longTermBtn.setSelectedColor()
        shortTermBtn.setDeselectedColor()
    }
    
    @IBAction func nextBtnWasPressed(_ sender: Any) {
        if (goalTextView.text != "" && goalTextView.text != "What is your goal?") {
            _goal["description"] = String(describing: goalTextView.text!)
            performSegue(withIdentifier: "showPointsPage", sender: _goal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let finishGoalVC = segue.destination as? FinishGoalVC {
            assert(sender as? [String : Any] != nil)
            
            finishGoalVC.initData(_goal: _goal)
        }
    }
    
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
        goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
}
