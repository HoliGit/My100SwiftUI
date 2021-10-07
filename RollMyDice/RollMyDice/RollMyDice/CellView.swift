//
//  CellView.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//

import SwiftUI
import Shapes

struct CellView: View {
    @Binding var dice: DiceItem
    @Binding var isRotating: Bool
    var row: Int
    var col: Int
    var index: Int
    
    var text: String? {
        dice.values.count > index ? String(dice.values[index]) : nil
    }

    
    var body: some View {
        if text != nil {
            ZStack {
                RegularPolygon(sides: UInt(dice.sides))
                    .stroke(Color.blue, lineWidth: 4)
                    .shadow(radius: 4.0, x: 2.0, y: 2.0)
                
                Text(text ?? "")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .rotationEffect(Angle.degrees(isRotating ? 360 : 0))
            .animation(isRotating ?
                       Animation.linear(duration: 0.5)
                        .repeatCount(8, autoreverses: false) : .none
            )
        }
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(dice: .constant(DiceItem(sides: 4, numberOfDice: 4)), isRotating: .constant(true), row: 1, col: 1, index: 2)
    }
}
