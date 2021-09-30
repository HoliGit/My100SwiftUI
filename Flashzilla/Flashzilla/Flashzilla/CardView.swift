//
//  CardView.swift
//  Flashzilla
//
//  Created by EO on 28/09/21.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    
    let card: Card
    
    var removal: ((_ isCorrect: Bool) -> Void)? = nil
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(differentiateWithoutColor ? Color.white
                      : Color.white
                        .opacity(1 - Double(abs(offset.width / 50)))
                )
                .background(
                    differentiateWithoutColor ? nil
                    : RoundedRectangle(cornerRadius: 25, style: .continuous)
                    //challenge 3:
                        .fill(offset.width == 0 ? Color.white : (offset.width > 0 ? Color.green : Color.red))
                    )
                .padding(20)
                .padding(.bottom, 30)
                .shadow(radius: 10)
                
            }
            
            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                } else {
                    
                    Text(card.prompt)
                        .font(.title)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            .padding(20)
            .multilineTextAlignment(.center)
        }
        
        .frame(width: 450, height: 250)
        //I used /10 instead of /5 to make the movement slower
        .rotationEffect(.degrees(Double(offset.width / 10)))
        .offset(x: offset.width * 5, y: 0)
        //opacity set to 2 will give positive numbers
        .opacity(2 - Double(abs(offset.width / 50)))
        //voiceover will read the card and tell is a button
        .accessibility(addTraits: .isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.offset = gesture.translation
                    self.feedback.prepare()
                }
                .onEnded { _ in
                    if abs(self.offset.width) > 100 {
                        if self.offset.width > 0 {
                            //self.feedback.notificationOccurred(.success) - less haptics
                            print("Right answer")
                        } else {
                            self.feedback.notificationOccurred(.error)
                            
                        }
                        
                        self.removal?(self.offset.width > 0)
                        
                    } else {
                        self.offset = .zero
                    }
                }
        )
        
        
        .onTapGesture {
            self.isShowingAnswer.toggle()
        }
        
        .animation(.spring())
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
