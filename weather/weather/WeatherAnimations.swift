//
//  WeatherAnimations.swift
//  weather
//
//  Created by Emre on 14.01.2025.
//

import SwiftUI

// Güneşli hava animasyonu
struct SunAnimation: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow)
                .frame(width: 100 , height: 100)
                .shadow(radius: 20)
            
            ForEach(0..<12) { i in
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 10, height: 30)
                    .offset(y: -70)
                    .rotationEffect(.degrees(Double(i) * 30))
            }
        }
    }
}

// yağmurlu hava animasyonu

struct RainAnimation: View {
    var body: some View {
        ZStack {
            ForEach(0..<20) { i in
                Capsule()
                    .fill(Color.blue)
                    .frame(width: 5, height: 20)
                    .position(x: CGFloat.random(in: 0...300), y: CGFloat.random(in:0...500))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// karlı hava animasyonu

struct SnowAnimation: View {
    var body: some View {
        ZStack {
            ForEach (0..<20) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                    .position(x: CGFloat.random(in: 0...300),y:CGFloat.random(in: 0...500))
                    .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview for All Animations
struct WeatherAnimations_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SunAnimation()
                .previewDisplayName("Güneşli Hava")
                .frame(width: 300, height: 300)

            RainAnimation()
                .previewDisplayName("Yağmurlu Hava")
                .frame(width: 300, height: 300)

            SnowAnimation()
                .previewDisplayName("Karlı Hava")
                .frame(width: 300, height: 300)
        }
    }
}
