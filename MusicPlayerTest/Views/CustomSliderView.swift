//
//  CustomSliderView.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 06.03.2025.
//

import SwiftUI


struct CustomSliderView: View {
    @Binding var progress: CGFloat // Значение от 0.0 до 1.0
    @State private var gestureValue: CGFloat?
    var change: (_ value: CGFloat) -> Void
    
    var body: some View {
        ZStack {
            
            Capsule()
                .fill(Color.white.opacity(0.4))
                .frame(height: 2)
            
            GeometryReader { geometry in
                let progressWidth = geometry.size.width * (gestureValue ?? progress)
                
                ZStack(alignment: .leading) {
                    
                    Capsule()
                        .fill(Color.white)
                        .frame(width: progressWidth, height: 2)
                    
                    let side: CGFloat = 13
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: side, height: side)
                        .offset(x: progressWidth - (side / 2))
                        .gesture(DragGesture(minimumDistance: 0.1)
                            .onChanged { value in
                                let newProgress = value.location.x / geometry.size.width
                                gestureValue = min(max(newProgress, 0), 1) // Ограничение от 0 до 1
                            }
                            .onEnded({ value in
                                if let gestureValue {
                                    progress = gestureValue
                                    change(gestureValue)
                                }
                                
                                gestureValue = nil
                            })
                        )
                }
            }
        }
        .frame(height: 13)
    }
}

#Preview {
    @Previewable @State var progress: CGFloat = 0.5
    CustomSliderView(progress: $progress, change: { _ in})
        .padding(.horizontal, 50)
}

