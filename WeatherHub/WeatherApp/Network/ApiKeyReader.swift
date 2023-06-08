//
//  KeyRef.swift
//  WeatherApp
//
//  Created by Ahmed Mohamed on 05/24/2023.
//  Copyright © 2023 Ahmed Mohamed. All rights reserved.

import Foundation

class ApiKeyReader {
    
    static func getAPIKeyThroughConfig() -> String {
        guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Could not find Info.plist")
        }

        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not find Info.plist")
        }

        guard let dictionary = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String : Any] else {
            fatalError("Could not find Info.plist")
        }

        guard let apiKey = dictionary["API_KEY"] as? String else {
            fatalError("Could not find API_KEY in Info.plist")
        }

        return apiKey
    }
}
