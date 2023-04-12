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
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateC", ascending: false)]) private var allTask: FetchedResults<Task>
    
    // funcion para guardar tarea
    
    private func saveTask(){
        
        do{
            let task = Task(context: viewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateC = Date()
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    //clear text field
    
    
    // color segun la prioriudad
    private func styleForPriority(value: String) -> Color{
        let priority = Priority(rawValue: value)
        switch priority {
        case .low:
            return Color.green
        case .medium:
            return Color.yellow
        case .high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    // colores
    func color(value: String) -> Color {
        let selected = Priority(rawValue: value)
        switch selected {
        case .low:
            return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    // actualizar la tarea favorita
    private func updateTask(task:Task){
        task.isFavorite = !task.isFavorite
        do{
            try viewContext.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    
    //eliminar tareas
    private func deleteTask(at offset: IndexSet){
        offset.forEach{index in
            let task = allTask[index]
            viewContext.delete(task)
            
            do{
                try viewContext.save()
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    // esquema
    @State private var scheme: ColorScheme = .light
    @State private var isShowingNewAccountView = false
    
    
    func toggleScheme() {
        scheme = scheme == .light ? .dark : .light
    }
    
    
    var body: some View {
        
                // Vista de navegacion
        NavigationView{
            // vertical stack
            VStack{
                HStack{
                    TextField("Introduce un titulo", text:$title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .border(Color.MyCyan)
                        .padding(10)
                    
                    // boton del esquema
                    Button(action: {
                        self.toggleScheme()
                    }) {
                        Image(systemName:scheme == .light ? "sun.min.fill" : "moon.fill")
                            .foregroundColor(scheme == .light ? Color.black : Color.yellow)
                    }
                    .padding()
                    
                }
                Picker("Priority", selection:$selectedPriority){
                    ForEach(Priority.allCases){
                        priority in Text(priority.title).tag(priority)
                            
                            
                    }
                    
                }.colorMultiply(scheme == .light ? Color.MyBlue : Color.MyCyan)
            .pickerStyle(SegmentedPickerStyle())
                
                
                List{
                    
                    ForEach(allTask){ task in
                        HStack{
                            
                            Circle()
                                .fill(styleForPriority(value: task.priority!))
                                .frame(width:15 , height: 15)
                                
                            
                            Spacer().frame(width:20 )
                            
                            Text(task.title ?? "")
                            
                            Spacer()
                                                
                            Image(systemName: task.isFavorite ? "circle.fill" : "circle")
                                .foregroundColor(Color.MyBlue)
                                .onTapGesture {
                                    updateTask(task: task)
                        }
                    }
                    }.onDelete(perform: deleteTask(at:))
                }
                
                
                Spacer()
                Button("save")
                {
                 saveTask()
                    self.title = ""
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            }
            // titulo de la vista
            .padding()
            .navigationTitle(" ☑️ Todas las tareas")
        }.preferredColorScheme(scheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let persistentContainer = CoreData.shared.persistentContainer
        ContentView().environment(\.managedObjectContext,
                                  persistentContainer.viewContext)
    }
}
