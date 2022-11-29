//
//  ToDoListItem.swift
//  CoreDataCheckUp
//
//  Created by Ben Huggins on 11/22/22.
//


import Foundation
import UIKit

class ToDoListItem {
    
    var name: String
    var date = Date()
    
    init(name: String, date: Date) {
        self.name = name
        self.date = date
        
    }
    
}
