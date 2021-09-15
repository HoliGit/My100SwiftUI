//
//  EntryView.swift
//  NameMyPic
//
//  Created by EO on 13/09/21.
//
//

import SwiftUI
import CoreData

struct EntryView: View {
    
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var enteredName: String = ""
    @State private var dataInvalid = false
    @State private var dataInvalidMessage = ""
    @State private var selectedPhotoPickerSourceType = 0
    
    let pickerSourceTypes: [UIImagePickerController.SourceType] = [.camera, .photoLibrary]
    
    let context: NSManagedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    let dataManager = DataManager()
    @ObservedObject var locationFetcher = LocationFetcher()
    
    @State var showImagePicker = false
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Name Your Picture")
                    .padding()
                    .font(.title)
                    .foregroundColor(.blue)
                TextField("Name:", text: $enteredName)
                    .padding(.leading, 10.0)
            }
            
            ZStack {
                Rectangle()
                    .fill(image == nil ? Color.blue : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                if image != nil {
                    image?
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    Text(pickerSourceTypes[selectedPhotoPickerSourceType].formattedMessage)
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding(.horizontal, 5.0)
            .padding(.top, 20.0)
            .padding(.bottom, 30.0)
            .onTapGesture {
                self.showImagePicker = true
            }
            
            Picker("Source Type", selection: $selectedPhotoPickerSourceType) {
                ForEach(0..<pickerSourceTypes.count) {
                    Text("\(self.pickerSourceTypes[$0].formattedSourceType)")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            VStack(alignment: .leading) {
                Text("Your present location:")
                    .font(.headline)
                    .fontWeight(.black)
                    .padding()
                HStack{
                    Text("Latitude:  ")
                        .font(.headline)
                        .padding(5)
                    Text(self.locationFetcher.lastKnownLatitude)
                    Spacer()
                }
                HStack{
                    Text("Longitude:")
                        .font(.headline)
                        .padding(5)
                    Text(self.locationFetcher.lastKnownLongitude)
                }
            }
            .padding(.bottom, 20.0)
            
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                    .padding(5)
                        .font(.system(size: 22))
                }
                .background(Color.black.opacity(0.35))
                .foregroundColor(.white)
                .font(.title)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 10.0)
                
                Spacer()
                Button(action: {
                    self.save()
                }) {
                    Text("Save")
                    .padding(5)
                        .font(.system(size: 22))
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .font(.title)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, 10.0)
            }
            .padding(.bottom, 25.0)
        }
        .onAppear {
            self.locationFetcher.start()
        }
        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage, sourceType: pickerSourceTypes[selectedPhotoPickerSourceType])
        }
        .alert(isPresented: $dataInvalid) {
            Alert(title: Text("Data Missing"), message: Text(dataInvalidMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func loadImage() {
                guard let inputImage = inputImage else { return }
                image = Image(uiImage: inputImage)
    }
    
    func save() {
        
        guard let image = inputImage else {
            dataInvalidMessage = "Please select a picture"
            dataInvalid = true
            return
        }
        guard enteredName != "" else {
            dataInvalidMessage = "Please enter a name"
            dataInvalid = true
            return
        }
        
        dataManager.save(image, name: self.enteredName, coord: self.locationFetcher.lastKnownLocation, in: self.context)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EntryView_Previews: PreviewProvider {
    @Environment(\.managedObjectContext) static var context
    static var previews: some View {
        EntryView(context: context)
    }
}
