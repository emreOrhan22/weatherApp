//
//  FavoriteCitiesView.swift
//  weather
//
//  Created by Emre on 13.01.2025.
//

import SwiftUI

struct FavoriteCitiesView: View {
    @State private var favoriteCities: [String] = ["Edirne","İstanbul","Ankara","İzmir",]
    @State private var weatherData: [String: String] = [:]
    
    var body: some View {
        List(favoriteCities, id: \.self) {city in
            VStack(alignment: .leading){
                Text(city)
                    .font(.headline)
                Text(weatherData[city] ?? "Yükleniyor...")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .onAppear {
                        fetchWeather(for: city)
                    }
            }
            .padding(.vertical, 5)
        }
        .navigationTitle("Favori Şehirler")
    }
    func fetchWeather(for city: String){
        let apiKey = "6ae5804008f24760dcd95cb136efdcf9"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        weatherData[city] = "\(weatherResponse.main.temp)°C, \(weatherResponse.weather.first?.description.capitalized ?? "Bilinmiyor")"
                }
            } catch {
                DispatchQueue.main.async {
                    weatherData[city] = "Hava durumu alınamadı."
                }
            }
        } .resume()
    }
}
