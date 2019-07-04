//
//  ContentView.swift
//  SwiftUIList
//
//  Created by Voicu, Narcis-Florin-Stefan (RO - Bucharest) on 01/07/2019.
//  Copyright © 2019 Narcis. All rights reserved.
//

import SwiftUI

struct CountryListView : View {
    
    @ObjectBinding var service: CountriesService
    var region: Regions
    
    var body: some View {
        VStack {
            TextField($service.filteredString,
                      placeholder: Text("Search countries"))
                .padding(10)
                .background(Color.white)
                .cornerRadius(5)
            List {
                ForEach(service.filteredString.isEmpty ? service.countries : service.filteredCountries) { country in
                    NavigationButton(destination: CountryDetailsView(country: country)) {
                        Row(country: country)
                    }
                    }.onDelete(perform: delete)
                }
                .navigationBarTitle(Text("Countries"))
                .navigationBarItems(trailing:
                    Button(action: {
                        self.service.fetchCountries(by: self.region)
                    }, label: {
                        Image(systemName: SFSymbolsName.reload.rawValue)
                    })
                ).onAppear {
                    self.service.fetchCountries(by: self.region)
                }
        }.padding(.top, 7)
        .background(Color.gray)
    }
    
    private func delete(at offsets: IndexSet) {
        if let first = offsets.first {
            service.countries.remove(at: first)
        }
    }
}

struct Row: View {
    let country: Country
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(country.name)
                .font(.headline)
                .lineLimit(nil)
            Text(country.capital)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        CountryListView(service: CountriesService(), region: Regions.africa)
    }
}
#endif
