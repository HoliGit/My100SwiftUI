//
//  ContentView.swift
//  Instafilter
//
//  Created by EO on 01/09/21.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    //Challenge 3
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var showingFilterSheet = false
    //Challenge 1
    @State private var noImageToSave = false
    
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    var body: some View {
        
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        let radius = Binding<Double>(
            get: { self.filterRadius },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        
        )
        
        let scale = Binding<Double>(
            get: {self.filterScale },
            set: {
                self.filterScale = $0
                self.applyProcessing()
            }
        
        )
        
        
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: intensity)
                            }
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey){
                        HStack {
                            ZStack(alignment: .leading) {
                                Text("Intensity").opacity(0)
                                Text("Radius")
                            }
                            Slider(value: radius)
                           }
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputScaleKey){
                        HStack {
                            ZStack(alignment: .leading){
                                Text("Intensity").opacity(0)
                                Text("Scale")
                            }
                            Slider(value: scale)
                        }
                    }
                }
                .padding(.vertical)
                
                HStack {
                    //Challenge 2
                    Button("Filter: \(currentFilter.formattedFilterName)") {
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedImage = self.processedImage else {
                            
                            self.noImageToSave = true
                            
                            return
                        }
                        
                        let imageSaver = ImageSaver()
                        
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        
                        imageSaver.errorHandler = {
                            print("Oops! \($0.localizedDescription)")
                        }
                        
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                        }
                    .alert(isPresented: $noImageToSave) {
                        Alert(title: Text("Nothing To Save!"), message: Text("Please select a picture"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("INSTAFILTER 📸")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
               }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize())},
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges())},
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur())},
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate())},
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone())},
                    .default(Text("Unsharp mask")) { self.setFilter(CIFilter.unsharpMask())},
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette())},
                    .cancel()
                ])
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterIntensity * 100, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage
        else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
}

//Challenge 2 - cutting CI prefix from filter names
extension CIFilter {
    var formattedFilterName: String {
        let removeCI = name.replacingOccurrences(of: "CI", with: "", range:  name.range(of: name))
        let fromSpaceToUppercase = removeCI.replacingOccurrences(of: "([A-Z])", with: "$1", options: .regularExpression, range: removeCI.range(of: removeCI))
        return fromSpaceToUppercase.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
