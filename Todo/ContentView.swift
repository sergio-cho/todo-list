//
//  ContentView.swift
//  Todo
//
//  Created by sergio on 11/02/23.
//

import SwiftUI

// priorities
enum Priority: String,Identifiable,CaseIterable{
    var id: UUID{
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}
extension Priority{
    var title:String{
        switch self {
        case .low:
            return "Low"
        case .medium:
             return "Medium"
        case .high:
            return "High"
        }
    }
}


struct ContentView: View {
    
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    var body: some View {
        // Vista de navegacion
        NavigationView{
            // vertical stack
            VStack{
                TextField("Introduce un titulo", text:$title )
                    // .textFieldStyle(.roundedBorder)
                Picker("Priority", selection:$selectedPriority){
                    ForEach(Priority.allCases){
                        priority in Text(priority.title).tag(priority)
                    }
                }
            }
            // titulo de la vista
            .padding()
            .navigationTitle("Todas las tareas")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
