//
//  Constant.swift
//  Everyday_Quest
//
//  Created by Liem Nguyen on 3/13/18.
//  Copyright © 2018 Liem Nguyen. All rights reserved.
//
import Foundation

var quest: Quest?

func saveData(todo: Quest) {
    UserDefaults.standard.set(todo , forKey: "quests")
}

func loadData() -> Quest? {
    if let todo = UserDefaults.standard.object(forKey: "quests") as? Quest {
        return todo
    }
    
    return nil
}
