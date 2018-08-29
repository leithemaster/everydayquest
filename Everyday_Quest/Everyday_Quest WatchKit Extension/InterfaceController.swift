//
//  InterfaceController.swift
//  Everyday_Quest WatchKit Extension
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    @IBOutlet var displayTItle: WKInterfaceLabel!
    
    let session = WCSession.default
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageRecived), name: NSNotification.Name(rawValue: "getPhoneMessage"), object: nil)
        
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    @objc func messageRecived(info: Notification) {
        let msg = info.userInfo as? [String: Any]
        
        DispatchQueue.main.async {
            if let done = msg!["title"] as? String {
                
                self.displayTItle.setText(done)
                
            }
            
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
