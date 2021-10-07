//
//  DiceHistory.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//

import SwiftUI

struct DiceHistory: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Dice.entity(), sortDescriptors: []) var dice: FetchedResults<Dice>
    
    
    var body: some View {
        Form {
            List {
                ForEach(dice, id: \.self) { item in
                    Section {
                        HStack {
                            Spacer()
                            DiceView(dice: .constant(self.data(db: item)), isRotating: .constant(false))
                            Spacer()
                        }
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
        }
    }
    
    func data(db: Dice) -> DiceItem {
        return DiceItem(sides: Int(db.sides),
                        values: db.valuesArray,
                        numberOfDice: Int(db.number))
    }
    
    func deleteItems(at offsets: IndexSet) {
        withAnimation {
            for offset in offsets {
               let dice = dice[offset]
                moc.delete(dice)
            }
                try? moc.save()
            
        }
    }
    
}

struct DiceListView_Previews: PreviewProvider {
    static var previews: some View {
        DiceHistory()
    }
}
