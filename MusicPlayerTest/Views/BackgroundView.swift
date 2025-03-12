//
//  BackgroundView.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
            LinearGradient( gradient: Gradient(colors: [
                    Color(red: 0.137, green: 0.008, blue: 0.271),
                    Color(red: 0.141, green: 0.012, blue: 0.271),
                    Color(red: 0.137, green: 0.008, blue: 0.271)
                ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            .overlay(
                content: {
                    ZStack {
                        Ellipse()
                            .frame(width: 349, height: 349)
                            .position(x: 285.5, y: 163.5)
                            .foregroundColor(Color(hex: "2600BE"))
                            .blur(radius: 100)
                        Ellipse()
                            .frame(width: 349, height: 349)
                            .position(x: 34.5, y: 613.5)
                            .foregroundColor(Color(hex: "760181"))
                            .blur(radius: 100)
                    }
                }
            )
        }
}

#Preview {
    BackgroundView()
}
