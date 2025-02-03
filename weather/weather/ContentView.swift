//
//  ContentView.swift
//  weather
//
//  Created by Emre on 13.01.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var cityName: String = ""
    @State private var weatherInfo: String = ""
    @State private var isLoading: Bool = false
    @State private var weatherCondition: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Hava Durumu")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Şehir Adı Girin", text: $cityName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    if cityName.isEmpty {
                        weatherInfo = "Lütfen bir şehir adı girin."
                    } else {
                        fetchWeather(for: cityName)
                    }
                }) {
                    Text("Hava Durumunu Getir")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if isLoading {
                    Text("Yükleniyor...")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    Text(weatherInfo)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                VStack {
                    if weatherCondition.contains("clear") {
                        SunAnimation()
                            .frame(width: 200, height: 200)
                    } else if weatherCondition.contains("rain") {
                        RainAnimation()
                            .frame(width: 200, height: 200)
                    } else if weatherCondition.contains("snow") {
                        SnowAnimation()
                            .frame(width: 200, height: 200)
                    } else {
                        Text("Hava durumu animasyonu yok: \(weatherCondition)")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .padding()

                .padding()
                

                Spacer()

                NavigationLink(destination: FavoriteCitiesView()) {
                    Text("Favori Şehirler")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    func fetchWeather(for city: String) {
        isLoading = true
        let apiKey = "6ae5804008f24760dcd95cb136efdcf9"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                isLoading = false
                weatherInfo = "Geçersiz şehir adı. Lütfen kontrol edin."
            }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    weatherInfo = "Bir hata oluştu: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    weatherInfo = "Veri alınamadı. Lütfen tekrar deneyin."
                }
                return
            }

            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    weatherInfo = """
                    Şehir: \(weatherResponse.name)
                    Sıcaklık: \(weatherResponse.main.temp)°C
                    Durum: \(weatherResponse.weather.first?.description.capitalized ?? "Bilinmiyor")
                    """
                    
                    weatherCondition = weatherResponse.weather.first?.description.lowercased() ?? "unknown"
                    
                    print("Weather Condition: \(weatherCondition)")
                    
                }
            } catch {
                DispatchQueue.main.async {
                    weatherInfo = "Beklenmedik bir hata oluştu. Lütfen tekrar deneyin."
                }
            }
        }.resume()
    }
}

struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
