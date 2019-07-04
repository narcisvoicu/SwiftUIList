//
//  CountryDetailsView.swift
//  SwiftUIList
//
//  Created by Voicu, Narcis-Florin-Stefan (RO - Bucharest) on 02/07/2019.
//  Copyright © 2019 Narcis. All rights reserved.
//

import SwiftUI
import Combine
import SDWebImageSVGCoder

struct CountryDetailsView : View {
    var country: Country
    
    var body: some View {
        VStack {
            CountryFlag(with: country.flag)
            Text("Welcome to \(country.name)")
                .font(.largeTitle)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding(.bottom)
            Text("Capital: \(country.capital)")
            Text("Region: \(country.subregion)")
            Text("Population: \(country.population)")
        }
    }
}

class ImageLoader: BindableObject {
    var didChange = PassthroughSubject<Data?, Never>()
    
    var data: Data? {
        didSet {
            didChange.send(data)
        }
    }
    
    init(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }

}

struct CountryFlag: View {
    
    @ObjectBinding var imageLoader: ImageLoader
    
    init(with flag: String) {
        self.imageLoader = ImageLoader(url: URL(string: flag)!)
    }
    
    var body: some View {
        getImage()
            .resizable()
            .aspectRatio(4/3, contentMode: .fit)
            .shadow(radius: 5)
            .padding(50)
        
    }
    
    private func getImage() -> Image {
        guard let data = imageLoader.data else {
            return Image(systemName: SFSymbolsName.nosign.rawValue)
        }
        guard let image = SDSVGImage(data: data) else {
            return Image(systemName: SFSymbolsName.nosign.rawValue)
        }
        
        return Image(uiImage: image)
        
    }
}

#if DEBUG
struct CountryDetailsView_Previews : PreviewProvider {
    static var previews: some View {
        CountryDetailsView(country: CountriesService().countries[0])
    }
}
#endif
