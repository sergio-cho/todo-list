//
//  TodoApp.swift
//  Todo
//
//  Created by sergio on 11/02/23.
//

import SwiftUI

@main
struct TodoApp: App {
    
    let persistentContainer = CoreData.shared.persistentContainer
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext,persistentContainer.viewContext )
        }
    }
}
