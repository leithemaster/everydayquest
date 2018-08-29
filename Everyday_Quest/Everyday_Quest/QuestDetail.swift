//
//  listDetail.swift
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//
import UIKit
import WatchConnectivity
import AVFoundation

class QuestDetail: UITableViewController {
    
    @IBOutlet weak var navItems: UINavigationItem!
    
    var storedList: ( task: [String], completed: [String]) = ([],[])
    var questTitle: String = ""
    let session = WCSession.default
    private var audio: AVAudioPlayer?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let header = UINib.init(nibName: "CustomHeader", bundle: nil)
        tableView.register(header, forHeaderFooterViewReuseIdentifier: "header")
        
        //Edit turn on "Select Mode"
        tableView.allowsMultipleSelectionDuringEditing = true
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        audio?.stop()
    }
    
    func audioStart()
    {
        let path = Bundle.main.path(forResource: "bad", ofType:".mp3")!
        let url = URL(fileURLWithPath: path)
        do
        {
            let sound = try AVAudioPlayer(contentsOf: url)
            audio = sound
            sound.numberOfLoops = 1
            sound.prepareToPlay()
            sound.play()
        }
        catch
        {
            print("Error - 294")
        }
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Create view
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CustomHeaderView
        
        //Configure the view
        if section == 0 {
            header?.headerLable.text = "Task"
            header?.subLabel.text = "Tasks Left: \(storedList.task.count)"
            header?.add.isHidden = true
            header?.editOrAdd.isHidden = false
        } else {
            header?.headerLable.text = "Completed"
            header?.subLabel.text = "Tasked Done: \(storedList.completed.count)"
            header?.add.isHidden = true
            header?.editOrAdd.isHidden = false
        }
        
        //Return the view
        return header
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // section setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    // section height
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    // row in each section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return storedList.task.count
            
        } else {
            return storedList.completed.count
        }
    }

    
    // cell creation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_displayList", for: indexPath) as! QuestDetailCustomCell

        // Configure the cell...
        
        if indexPath.section == 0 {
            cell.displayItem.text = storedList.task[indexPath.row]
            cell.checkMark.isHidden = true
        } else {
            cell.displayItem.text = storedList.completed[indexPath.row]
            cell.checkMark.isHidden = false
        }

        return cell
    }
    
    
    
    // once the use select something on the list it update the root list as well as the current list. 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            
        } else
        {
            if let item = tableView.indexPathForSelectedRow {
                if item.section == 0 {
                    storedList.completed.append(storedList.task[item.row])
                    storedList.task.remove(at: item.row)
                    tableView.reloadData()
                    for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                        if newList.name == questTitle {
                            (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list = storedList
                        }
                    }
                } else {
                    storedList.task.append(storedList.completed[item.row])
                    storedList.completed.remove(at: item.row)
                    tableView.reloadData()
                    for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                        if newList.name == questTitle {
                            (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list = storedList
                        }
                    }
                }
                
                
                let whole = storedList.task.count + storedList.completed.count
                let done = storedList.completed.count
                
                self.session.sendMessage(["title" : "\(done)/\(whole)"] , replyHandler: nil, errorHandler: nil)
                
                if(storedList.completed.count != 0 && storedList.task.count == 0) {
                    audioStart()
                    // alert when they hit the delete after swiping to the left
                    let alert = UIAlertController(title: "CONGRATULATION", message: "YOU FINISH ALL TASK?", preferredStyle: .alert)
                    
                    // cancel button for alert
                    let cancel = UIAlertAction(title: "OKAY", style: .cancel, handler: { [alert] (_) in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    
                    alert.addAction(cancel)
                    // print to console that the alert was presented
                    present(alert, animated: true, completion: nil )
                    
                }

            }

        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            // alert when they hit the delete after swiping to the left
            let alert = UIAlertController(title: "Deleting task", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            // cancel button
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: { [alert] (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            // confirm button
            let confirm = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                // action taken after user confirm it
                if indexPath.section == 0 {
                    self.storedList.task.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                        if newList.name == self.questTitle {
                            (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list.task.remove(at: indexPath.row)
                        }
                    }

                } else {
                    self.storedList.completed.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                        if newList.name == self.questTitle {
                            (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list.completed.remove(at: indexPath.row)
                        }
                    }

                }
            })
            
            // add button to the alert
            alert.addAction(cancel)
            alert.addAction(confirm)
                
            // print out alert was shown
            present(alert, animated: true, completion: { print("Alert was presented")} )
            
        } else if editingStyle ==  .insert {
            
        }
    }

    @IBAction func newItem(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Task", message: "Title of task. ", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            
            textField.placeholder = "Name"
        }
        
        let cancel = (UIAlertAction(title: "Cancel", style: .cancel, handler: { [alert] (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        let confirm = (UIAlertAction(title: "OK", style: .default, handler: { [alert] (_) in
            if let newThing = alert.textFields?[0].text {
                
                self.storedList.task.append(newThing)
                for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                    if newList.name == self.questTitle {
                        (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list.task.append(newThing)
                    }
                }
                self.tableView.reloadData()
            }
            
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        
        //show the alert to the user
        present(alert, animated: true, completion: nil)
    }
    
    // trash button
    @IBAction func trashButton(_ sender: Any) {
        
        // alert when they hit the delete after swiping to the left
        let alert = UIAlertController(title: "Deleting Task", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        
        // cancel button for alert
        let cancel = UIAlertAction(title: "No", style: .cancel, handler: { [alert] (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        // confirm button for alert
        let confirm = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            
            
            
            if var selectedItems = self.tableView.indexPathsForSelectedRows {
                
                //Sort in largest to smallest index so that we can remove items back to front
                selectedItems.sort(by: { (a, b) -> Bool in
                    a.row > b.row
                })
                
                // remove the item from the list.
                for indexpath in selectedItems {
                    //Update data first
                    if indexpath.section == 0 {
                        self.storedList.task.remove(at: indexpath.row)
                        for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                            if newList.name == self.questTitle {
                                (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list.task.remove(at: indexpath.row)
                            }
                        }
                    }else {
                        self.storedList.completed.remove(at: indexpath.row)
                        for (index, newList) in (self.navigationController?.viewControllers[0] as! QuestListTableView).qList.enumerated() {
                            if newList.name == self.questTitle {
                                (self.navigationController?.viewControllers[0] as! QuestListTableView).qList[index].list.completed.remove(at: indexpath.row)
                            }
                        }
                    }
                }
                //Delete all rows at once
                self.tableView.deleteRows(at: selectedItems, with: .left)
                self.tableView.reloadData()
            }
            
            
        })
        
        // add the button to the alert
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        // print to console that the alert was presented
        present(alert, animated: true, completion: { print("Alert was presented")} )
    }
    
    @IBAction func edit(_ sender: Any) {
        
        // set up the ability to edit or enter edit mode
        tableView.setEditing( !tableView.isEditing, animated: true)
        
        // when in edit mode the trash can appear and there a cancel feature
        if tableView.isEditing {
            // invisible button to trash can
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash,
                                                                target: self,
                                                                action: #selector (QuestDetail.trashButton(_:)))
            // edit to cancel
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector (QuestDetail.edit(_:)))
        } else {
            // edit button return back to normal
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector (QuestDetail.newItem(_:)))
            // this reset the trash can into a invisible button
            navigationItem.leftBarButtonItem = navItems.backBarButtonItem
        }
    }


}
