//
//  Country.swift
//  SwiftUIList
//
//  Created by Voicu, Narcis-Florin-Stefan (RO - Bucharest) on 01/07/2019.
//  Copyright © 2019 Narcis. All rights reserved.
//

import SwiftUI
import Combine

enum SFSymbolsName: String {
    case reload = "arrow.clockwise"
    case nosign = "nosign"
}

enum Regions: String, CaseIterable {
    case europe = "Europe"
    case asia = "Asia"
    case americas = "Americas"
    case africa = "Africa"
    case oceania = "Oceania"
}

struct Country: Identifiable, Decodable {
    var id: UUID = UUID()
    var name: String
    var subregion: String
    var capital: String
    var population: Int
    var flag: String
    
    enum CodingKeys: String, CodingKey {
        case name, subregion, capital, flag, population
    }
}

class CountriesService: BindableObject {

    var countries = [Country]() {
        didSet {
            didChange.send(self)
        }
    }
    
    var filteredCountries = [Country]() {
        didSet {
            didChange.send(self)
        }
    }
    
    var filteredString: String = "" {
        didSet {
            filteredCountries = countries.filter {
                $0.name.contains(filteredString)
            }
        }
    }
    
    public let didChange = PassthroughSubject<CountriesService, Never>()
    
    
    func fetchCountries(by region: Regions) {
        guard let url = URL(string: "https://restcountries.eu/rest/v2/region/\(region.rawValue.lowercased())") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            if let countries = try? JSONDecoder().decode([Country].self, from: data) {
                DispatchQueue.main.async {
                    self.countries = countries
                }
            } else {
                print("Failed to decode: \(String(describing: error?.localizedDescription))")
            }
            
        }
        task.resume()
    }
    
}
