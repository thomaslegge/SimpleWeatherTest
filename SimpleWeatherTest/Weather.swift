//
//  Weather.swift
//  SimpleWeatherTest
//
//  Created by Thomas Legge on 27/05/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Welcome
struct Welcome: Codable {
    let cod: String?
    let message, cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let rain: Rain?
    let sys: Sys?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, seaLevel, grndLevel, humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}

struct WeatherResquest {
    enum WeatherError: Error {
        case noDataAvailable
        case cannotProccesData
    }
    
//    init(json:[String:Any]) throws {
//        guard let summary = json["summary"] as? String else {throw SerializationError.missing("Summary is missing")}
//
//        guard let icon = json["icon"] as? String else {throw SerializationError.missing("Icon is missing")}
//
//        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("Temprature is missing")}
//
//        self.summary = summary
//        self.icon = icon
//        self.temperature = temperature
//    }
    
    static func forecast (location: CLLocationCoordinate2D, completion: @escaping (Result<Welcome, Error>) -> ()) {
        
        //#TODO: Hide Key, improve url building
        let api = "https://api.openweathermap.org/data/2.5/forecast?"
        let lat = "lat=" + String(location.latitude)
        let lon = "&lon=" + String(location.longitude)
        let key = "&appid=" //#SECRET
        let urlString =  api + lat + lon + key
        
        guard let url = URL(string: urlString) else {fatalError("Invalid URL")}
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Welcome.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(weather))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
