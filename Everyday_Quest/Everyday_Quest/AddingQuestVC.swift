//
//  AddingQuestVC.swift
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/23/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//

import UIKit

class AddingQuestVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userTitleInput: UITextField!
    @IBOutlet weak var userTaskInput: UITextField!
    @IBOutlet weak var showTableView: UITableView!
    
    var newList: [String] = []
    var newQuestTitle: String = ""
    
    var delegate: PassingListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTableView.delegate = self
        showTableView.dataSource = self
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddingQuestVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your my actions
        
        delegate?.finishPassing(newList: (name: newQuestTitle, list: (task: newList, completed: [])))
        
        // Go back to the previous ViewController
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showItem", for: indexPath)
        cell.textLabel?.text = newList[indexPath.row]
        return cell;
    }
    
    // swipe delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // alert when they hit the delete after swiping to the left
            let alert = UIAlertController(title: "Deleting Quest", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            
            // cancel button for alert
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: { [alert] (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            // confirm button for alert
            let confirm = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                // delete item from the list once confirmed
                self.newList.remove(at: indexPath.row)
                self.showTableView.reloadData()
            })
            
            // add the button to the alert
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            // print to console that the alert was presented
            present(alert, animated: true, completion: { print("Alert was presented")} )
        }
    }
    
    
    @IBAction func addButton(_ sender: Any) {
        
        if let task = userTaskInput.text {
            if !task.isEmpty {
                newList.append(task)
                userTaskInput.text = ""
                showTableView.reloadData()
                print(newList)
            }
        }
        
        if let title =  userTitleInput.text {
            navigationItem.title = title
            newQuestTitle = title
        }
        
    }
    
}

protocol PassingListDelegate {
    func finishPassing(newList: (name: String, list: (task: [String], completed: [String])))
}

























