//
//  GridStack.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//

import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let spacing: CGFloat
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(spacing: self.spacing) {
            ForEach(0 ..< rows) { row in
                HStack(spacing: self.spacing) {
                    ForEach(0 ..< self.columns) { column in
                        self.content(row, column)
                    }
                
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, spacing: CGFloat, @ViewBuilder content: @escaping (Int, Int) -> Content ){
        self.rows = rows
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
}

struct GridStack_Previews: PreviewProvider {
    static var previews: some View {
        GridStack(rows: 3, columns: 3, spacing: 10) { row, col in
            Text("")
                .frame(width: 100, height: 100, alignment: .center)
                .background(Color.red)
            
        }
    }
}
