//
//  RegionsList.swift
//  SwiftUIList
//
//  Created by Voicu, Narcis-Florin-Stefan (RO - Bucharest) on 04/07/2019.
//  Copyright © 2019 Narcis. All rights reserved.
//

import SwiftUI

struct RegionsListView : View {
    
    private let regions = Regions.allCases
    
    var body: some View {
        NavigationView {
            List {
                ForEach(regions.identified(by: \.self)) { region in
                    NavigationButton(destination: CountryListView(service: CountriesService(), region: region)) {
                        Text(region.rawValue)
                    }
                }
            }.navigationBarTitle(Text("Regions"))
        }
    }
    
    private func generateArray() -> [String] {
        return ["Europe", "Asia"]
    }
}

#if DEBUG
struct RegionsList_Previews : PreviewProvider {
    static var previews: some View {
        RegionsListView()
    }
}
#endif
