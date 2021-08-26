//
//  FilteredList.swift
//  CoreDataProjectFull
//
//  Created by SCOTTY on 25/08/21.
//

import CoreData
import SwiftUI


struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var items: FetchedResults<T> { fetchRequest.wrappedValue }
    
    //content closure, called once for each item in list
    let content: (T) -> Content
        
    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                self.content(item)
            }
        }
    }
    
    init(filterKey: String, filterValue: String, filterType: FilterType, sortBy: [NSSortDescriptor], @ViewBuilder content: @escaping (T) -> Content) {
        
        var predicate: NSPredicate?
        
        switch filterType {
            case .equals:
                predicate = (filterValue != "" ? NSPredicate(format: "%K == %@", filterKey, filterValue) : nil)
            case .beginsWith:
                predicate = (filterValue != "" ? NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue) : nil)
            case .not:
                predicate = (filterValue != "" ? NSPredicate(format: "NOT %K == %@", filterKey, filterValue) : nil)
        }
        
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortBy, predicate: predicate)
        self.content = content
    }
    
    
    
}

/*struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        FilteredList()
    }
} */
