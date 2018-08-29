//
//  GListTableView.swift
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//


import UIKit
import WatchConnectivity

class QuestListTableView: UITableViewController, PassingListDelegate {
    
    @IBOutlet weak var trashBeGoneMethod: UIBarButtonItem!
    @IBOutlet var questListView: UITableView!
    
    var qList: [(name: String, list: (task: [String], completed: [String]) ) ] = []
    let session = WCSession.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageRecived), name: NSNotification.Name(rawValue: "getWatchMessage"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let header = UINib.init(nibName: "CustomHeader", bundle: nil)
        questListView.register(header, forHeaderFooterViewReuseIdentifier: "header")
        
        //Edit turn on "Select Mode"
        tableView.allowsMultipleSelectionDuringEditing = true
    }
    
    @objc func messageRecived(info: NSNotification) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let whole = qList[indexPath.section].list.task.count + qList[indexPath.section].list.completed.count
        let done = qList[indexPath.section].list.completed.count
            
        self.session.sendMessage(["title" : "\(done)/\(whole)"] , replyHandler: nil, errorHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Create view
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CustomHeaderView
        
        //Configure the view
        header?.headerLable.text = "Quests"
        header?.subLabel.text = "Total: \(qList.count)"
        header?.add.isHidden = false
        header?.editOrAdd.isHidden = true
        
        //Return the view
        return header
    }

    
    // reload the screen so update the list counts
    override func viewWillAppear(_ animated: Bool) {
        questListView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    // setup sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // setup section hight
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    // set up rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return qList.count
    }

    // cell division
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_Glist", for: indexPath) as! CustomCell

        // Configure the cell...
        cell.listName.text = qList[indexPath.row].name
        cell.itemCount.text = "Quest's tasks: \(qList[indexPath.row].list.task.count)"

        return cell
    }
    // trash button
    @IBAction func trashButton(_ sender: Any) {
        
            
            // alert when they hit the delete after swiping to the left
            let alert = UIAlertController(title: "Deleting Quest", message: "Are you sure you want to delete this?", preferredStyle: .alert)
            
            // cancel button for alert
            let cancel = UIAlertAction(title: "No", style: .cancel, handler: { [alert] (_) in
                alert.dismiss(animated: true, completion: nil)
            })
            
            // confirm button for alert
            let confirm = UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                // delete item from the list once confirmed
                if var selectedItems = self.tableView.indexPathsForSelectedRows {
                    
                    //Sort in largest to smallest index so that we can remove items back to front
                    selectedItems.sort(by: { (a, b) -> Bool in
                        a.row > b.row
                    })
                    
                    // remove the item from the list.
                    for indexpath in selectedItems {
                        //Update data first
                        self.qList.remove(at: indexpath.row)
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
    
    // edit button
    @IBAction func editbutton(_ sender: Any) {
        // set up the ability to edit or enter edit mode
        tableView.setEditing( !tableView.isEditing, animated: true)
        
        // when in edit mode the trash can appear and there a cancel feature
        if tableView.isEditing {
            // invisible button to trash can
            navigationItem.leftBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .trash,
                                                                target: self,
                                                                action: #selector (QuestListTableView.trashButton(_:)))
            // edit to cancel
            navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                 target: self,
                                                                 action: #selector (QuestListTableView.editbutton(_:)))
        } else {
            // edit button return back to normal
            navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector (QuestListTableView.editbutton(_:)))
            // this reset the trash can into a invisible button
            navigationItem.leftBarButtonItem? = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
    }

    // swipe delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
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
                self.qList.remove(at: indexPath.row)
                self.questListView.reloadData()
            })
            
            // add the button to the alert
            alert.addAction(cancel)
            alert.addAction(confirm)
            
            // print to console that the alert was presented
            present(alert, animated: true, completion: { print("Alert was presented")} )
        }
    }
    
    // add button
    @IBAction func newList(_ sender: UIButton) {
        
        performSegue(withIdentifier: "toAddQuest", sender: nil)
        
        print("New List TO add")
    }

    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
       
        // this will prevent the going into the list while editing the lists
        if questListView.isEditing == false {
            return true
        } else {
            return false
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toQuestDetail" {
            // sending the lists to the other table
            if let indexPath = questListView.indexPathForSelectedRow {
                let listItems = qList[indexPath.row]
                
                if let destination =  segue.destination as? QuestDetail {
                    destination.storedList = listItems.list
                    destination.questTitle = listItems.name
                    destination.navItems.title = listItems.name
                }
            }
        }
        
        if segue.identifier == "toAddQuest" {
            print("Going to ass something")
            if let destination =  segue.destination as? AddingQuestVC {
                destination.delegate = self
            }
        }
    }
    
    // protocol used for getting the data from the add new list view controller
    func finishPassing(newList: (name: String, list: (task: [String], completed: [String]))) {
        qList.append(newList)
        questListView.reloadData()
        
        let whole = newList.list.task.count + newList.list.completed.count
        let done = newList.list.completed.count
        
        self.session.sendMessage(["title" : "\(done)/\(whole)"] , replyHandler: nil, errorHandler: nil)
    }
    
    

}



















