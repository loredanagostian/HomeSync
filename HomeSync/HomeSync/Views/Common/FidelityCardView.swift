//
//  FidelityCardView.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct FidelityCardView: View {
    let title: String
    let headerColor: Color
    let barcodeText: String
    var height: CGFloat
    var width: CGFloat
    
    var body: some View {
        VStack {
            ZStack {
                headerColor
                    .frame(height: 35)
                    .cornerRadius(15, corners: [.topLeft, .topRight])

                GenericTextView(text: title, font: Fonts.semiBold.ofSize(14), textColor: .white)
            }
            
            Spacer()

            if let barcodeImage = generateBarcode(from: barcodeText) {
                Image(uiImage: barcodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
            }
            
            GenericTextView(text: barcodeText, font: Fonts.regular.ofSize(12), textColor: .appDark)

            Spacer()
        }
        .frame(width: width, height: height)
        .background(Color.white)
        .cornerRadius(15)
    }

    func generateBarcode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.code128BarcodeGenerator()
        let data = Data(string.utf8)
        filter.message = data

        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage).resized(to: CGSize(width: 300, height: 100))
            }
        }
        
        return nil
    }
}
