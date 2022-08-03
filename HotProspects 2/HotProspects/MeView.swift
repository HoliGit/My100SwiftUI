//
//  MeView.swift
//  HotProspects
//
//  Created by EO on 16/09/21.
//  Updated on 01/08/22

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct MeView: View {
    @State private var name = ""
    @State private var emailAddress = ""
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Insert the data for your QRcode")
                    .foregroundColor(.blue)
                    .padding()
            Form {
                TextField("Name", text: $name)
                    .textContentType(.name)
                    .font(.title)
                    //.padding(.horizontal)
                
                TextField("Email Address", text: $emailAddress)
                    .textContentType(.emailAddress)
                    .font(.title)
                    //.padding([.horizontal, .bottom])
                
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .contextMenu {
                        Button {
                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: qrCode)
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                        }
                    }
                
                Text("Press the image to save it for sharing")
                    .foregroundColor(.blue)
              
            }
            
            .navigationTitle("My QRcode")
            .onAppear(perform: updateCode)
            .onChange(of: name) { _ in updateCode()}
            .onChange(of: emailAddress) { _ in updateCode()}
        }
      }
    }
        
        func updateCode() {
            qrCode = generateQRCode(from: "\(name)\n\(emailAddress)")
        }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
