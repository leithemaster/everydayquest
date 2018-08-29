//
//  Quest.swift
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//

import Foundation

class Quest {
    
    var mQuests: [(title: String, list: (task: [String], completed: [String]))]
    
    init(quest: [(title: String, list: (task: [String], completed: [String] ) ) ]) {
        self.mQuests = quest
    }
}

class List: NSObject, NSCoding{
    
    var list: [String]?
    
    init(data: [String]) {
        self.list = data
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        
        self.init(data: ["test", "testing"])
        
        list = aDecoder.decodeObject(forKey: "dataString") as? [String]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(list, forKey: "dataString")
    }
}
