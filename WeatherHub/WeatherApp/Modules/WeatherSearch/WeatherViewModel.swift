//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ahmed Mohamed on 05/24/2023.
//  Copyright © 2023 Ahmed Mohamed. All rights reserved.

import Foundation
import CoreLocation
import SwiftUI

protocol WeatherViewModelContract: ObservableObject {
    func fetchWeatherInfo(city: String)
    func fetcheDefaultWeatherInfo(_ location: CLLocation)
}
final class WeatherViewModel {
    private var location: Forecast?
    private var currentTemp: Int = 0
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var fetchTask: Task<Void, Never>?
    private let weatherManager: NetworkProtocol

    let lastSearchedCityKey = "LastSearchedCity"
    @Published var forecast: Forecast?

    init(weatherManager: NetworkProtocol) {
        self.weatherManager = weatherManager
    }
    
    func tempConversion(temp: Double) -> Int {
        var fahrenheitTemp: Double
        fahrenheitTemp = (temp - 273.15) * 9/5 + 32
        round(fahrenheitTemp)
        return Int(fahrenheitTemp)
    }
}

extension WeatherViewModel: WeatherViewModelContract {
    func fetchWeatherInfo(city: String) {
        fetchTask?.cancel()
        Task {
            do {
                var cityName = city
                if cityName.isEmpty {
                    cityName = UserDefaults.standard.string(forKey: lastSearchedCityKey) ?? ""
                }
                let _location = try await weatherManager.fetchData(endpoint: WeatherEndpoint.getWeatherLocation(city: cityName), useCache: true)
                                
                await MainActor.run {
                    location = _location
                    latitude = _location.coord.lat ?? 0.0
                    longitude = _location.coord.lon ?? 0.0
                }
                
                let _forecast = try await weatherManager.fetchData(endpoint: WeatherEndpoint.getCurrentWeatherData(lat: latitude, lon: longitude), useCache: true)
    
                await MainActor.run {
                    forecast = _forecast
                    currentTemp = tempConversion(temp: forecast?.main.temp ?? 0.0)
                }
                
                UserDefaults.standard.set(forecast?.name.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "+"), forKey: lastSearchedCityKey)

            } catch let error {
                location = nil
                forecast = nil
                print("Error fetching data: \(error)")
            }
        }
    }
    
    
    func fetcheDefaultWeatherInfo(_ location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        Task {
            do {
                let _forecast = try await weatherManager.fetchData(endpoint: WeatherEndpoint.getCurrentWeatherData(lat: latitude, lon: longitude), useCache: true)
                
                await MainActor.run {
                    forecast = _forecast
                    currentTemp = tempConversion(temp: forecast?.main.temp ?? 0.0)
                }
            } catch let error {
                forecast = nil
                print("Error fetching data: \(error)")
            }
        }
    }
}
