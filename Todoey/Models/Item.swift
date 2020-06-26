//
//  Item.swift
//  Todoey
//
//  Created by Nadeem Ansari on 6/26/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable {
    private var title: String
    private var done: Bool
    
    init(title: String, done: Bool = false) {
        self.title = title
        self.done = done
    }
    
    func toggle() {
        self.done = !self.done
    }
    
    func isDone() -> Bool {
        return done
    }
    
    func setTitle(newTitle: String) {
        self.title = newTitle
    }
    
    func getTitle() -> String {
        return title
    }
}
