//
//  ContentView.swift
//  AccessibilitySandbox
//
// Reviewed by EO on 12/07/22.
//

import SwiftUI


struct SliderContentView: View {
    @State private var estimate = 25.0
    @State private var rating = 3

    var body: some View {
        VStack {
            Text("VoiceOver slider")
                .font(.title)
            Slider(value: $estimate, in: 0...50)
                //avoid voiceover to read in percentages:
                .accessibility(value: Text("\(Int(estimate))"))
                .padding()
            Text("Accessible stepper")
                .font(.title)
            Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
                .padding()
                .accessibility(value: Text("\(rating) out of 5"))
        }
    }
}

struct GroupChildrenContentView: View {
    var body: some View {
        Text("Accessibility Element")
            .font(.title)
            .padding(.bottom)
            .accessibility(label: Text("Accessibility element"))
        
        VStack {
            Text("Your score is")
            Text("1000")
                .font(.largeTitle)
                .foregroundColor(.red)
        }
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("Your score is 1000"))
    }
}

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]

    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]

    @State private var selectedPicture = Int.random(in: 0...3)

    var body: some View {
        VStack{
            Text("Accessibility Tests")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                
        Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .onTapGesture {
                self.selectedPicture = Int.random(in: 0...3)
            }
            .accessibility(label: Text(labels[selectedPicture]))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
            
            Text("Tap to change image")
                .padding(.bottom)

        Spacer()
        SliderContentView()
        Spacer()
        GroupChildrenContentView()
        Spacer()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
