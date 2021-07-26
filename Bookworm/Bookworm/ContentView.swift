//
//  ContentView.swift
//  Bookworm
//
//  Created by EO on 23/07/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true), NSSortDescriptor(keyPath: \Book.author, ascending: true)]) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    
    var body: some View {
        NavigationView {
            List{
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading){
                            Text(book.title ?? "Unknown title")
                                .font(.headline)
                                //challenge 2
                                .foregroundColor(book.rating == 1 ? Color.red : .primary)
                            Text(book.author ?? "Unknown author")
                            
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
                //swipe delete in ForEach, not in List!
                .onDelete(perform: deleteBooks)
                
                
            }
            
                .navigationBarTitle("Bookworm")
            .navigationBarItems(leading: EditButton(), trailing:
                        Button(action: {
                            self.showingAddScreen.toggle()
                        }) {
                            
                            Image(systemName: "plus")
                        }
                        )
            
                .sheet(isPresented: $showingAddScreen){
                    AddBookView().environment(\.managedObjectContext, self.moc)
                }
        }
    }
    
    //find the book in fetchrequest, delete and save the context
    func deleteBooks(at offsets: IndexSet){
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
