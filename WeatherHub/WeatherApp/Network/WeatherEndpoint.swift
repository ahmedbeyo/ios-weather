//
//  WeatherEndpoints.swift
//  WeatherApp
//
//  Created by Ahmed Mohamed on 05/24/2023.
//  Copyright © 2023 Ahmed Mohamed. All rights reserved.

import Foundation

struct WeatherEndpoints<Response: Decodable> {
    let url: URL
    let responseType: Response.Type
}

struct WeatherEndpoint {
    static private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    static func getCurrentWeatherData(lat: Double, lon: Double) -> WeatherEndpoints<Forecast> {
        WeatherEndpoints(url: URL(string: "\(baseUrl)?lat=\(lat)&lon=\(lon)&appid=\(ApiKeyReader.getAPIKeyThroughConfig())")!,
                         responseType: Forecast.self)
    }
    
    static func getWeatherLocation(city: String) -> WeatherEndpoints<Forecast> {
        WeatherEndpoints(url: URL(string: "\(baseUrl)?q=\(city)&appid=\(ApiKeyReader.getAPIKeyThroughConfig())")!, responseType: Forecast.self)
    }
}
