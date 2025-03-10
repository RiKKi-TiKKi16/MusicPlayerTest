//
//  BackgroundView.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.137, green: 0.008, blue: 0.271), // Верхний цвет (#230245)
                    Color(red: 0.141, green: 0.012, blue: 0.271), // Средний цвет (#240345)
                    Color(red: 0.137, green: 0.008, blue: 0.271)  // Нижний цвет (#230245)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .overlay(
                content: {
                    ZStack {
                        Ellipse()
                            .frame(width: 349, height: 349)
                            .position(x: 285.5, y: 163.5) // Top: -11px, Left: 111px (с учетом центра)
                            .foregroundColor(Color(hex: "2600BE"))//.opacity(0.5))
                            .blur(radius: 100)
                        
                        Ellipse()
                            .frame(width: 349, height: 349)
                            .position(x: 34.5, y: 613.5) // Top: 439px, Left: -140px (с учетом центра)
                            .foregroundColor(Color(hex: "760181"))//.opacity(0.5))
                                             
                            .blur(radius: 100)
                    }
                }
            )
        }
}

#Preview {
    BackgroundView()
}
