//
//  CoreData.swift
//  Todo
//
//  Created by sergio on 11/02/23.
//

import Foundation
import CoreData

class CoreData {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreData = CoreData()
    private init(){
        
        persistentContainer = NSPersistentContainer(name: "SimpleTodo")
        persistentContainer.loadPersistentStores{ description, error in
            if let error = error{
                fatalError("No podemos inicializar el core data papu  \(error)")
                
            }
        }
        
    }
}
