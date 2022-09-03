//
//  ViewController.swift
//  goalpost-app
//
//  Created by Hovhannes Mikayelyan on 29.08.22.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var undoView: UIView!
    @IBOutlet weak var undoViewLbl: UILabel!
    
    var goals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        
        self.tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                    
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCreatePage", sender: nil)
    }
    
    @IBAction func undoBtnWasPressed(_ sender: Any) {
        self.undoManager()
        self.fetchCoreDataObjects()
        self.tableView.reloadData()
    }
    
    func shit(){
        tableView.reloadData()
    }
    
}

extension GoalsVC {
    func enableUndoView(type: String) {
        if (type == "delete") {
            self.undoViewLbl.text = "Goal Removed"
            self.undoView.backgroundColor = #colorLiteral(red: 1, green: 0.2964266086, blue: 0.05206752638, alpha: 1)
        } else if (type == "create") {
            self.undoViewLbl.text = "Goal Created"
            self.undoView.backgroundColor = #colorLiteral(red: 0.6980392157, green: 0.8666666667, blue: 0.6862745098, alpha: 1)
        }
        
        self.undoView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.undoView.isHidden = true
        }
    }
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else {
            return UITableViewCell()
        }
        
        let goal = goals[indexPath.row]
        
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.enableUndoView(type: "delete")
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9991911054, green: 0.8310182691, blue: 0.1789256632, alpha: 1)
        
        return [deleteAction, addAction]
    }
    
}

extension GoalsVC {
    func setProgress(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
            print("Succesfully set progress")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
        
    }
    
    
    func removeGoal(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.undoManager = UndoManager()
        managedContext.undoManager?.beginUndoGrouping()
        
        managedContext.delete(goals[indexPath.row])
        
        do {
            try managedContext.save()
            managedContext.undoManager?.endUndoGrouping()
            print("Successfully removed goal.")
        }
        catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do{
            goals = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
            completion(false)
        }
        
        
    }
    
    func undoManager() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.undoManager?.undo()
        
        do {
            try managedContext.save()
            print("Successfully Undo Progress goal!")
            self.undoView.isHidden = true
            
        } catch {
            debugPrint("Could not undo :\(error.localizedDescription)")
        }
        
    }
}
