//
//  ViewController.swift
//  CobaURLSession
//
//  Created by Audrey Saudjhana on 06/08/20.
//  Copyright © 2020 Audrey Saudjhana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchWeatherAPI()
    }

    func fetchWeatherAPI(){
        guard let apiUrl = URL(string: "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=439d4b804bc8187953eb36d2a8c26a02")
        else {
            return
        }
        
        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            guard let data = data else {return}
            do {
                // Decode data JSON
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherAPI.self, from: data)
                // Ambil temp value
                let temp = weatherData.main?.temp ?? 0
                let description = weatherData.weather?[0].description
                // Set value ke view
                DispatchQueue.main.async {
                    self.labelTemperature.text = "\(temp)°"
                    self.labelDescription.text = "\(description!)"
                }
            } catch let err {
                print("Error: ", err)
            }
        }.resume()
    }
    @IBOutlet var labelTemperature: UILabel!
    @IBOutlet var labelDescription: UILabel!
}

struct WeatherAPI: Codable {
    let main: Main?
    let weather: [Weather]?
    
    private enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}

struct Main: Codable {
    let temp: Float?
    let humidity: Int?
    
    private enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}

struct Weather: Codable {
    let description: String?
    
    private enum CodingKeys: String, CodingKey {
        case description
    }
}
