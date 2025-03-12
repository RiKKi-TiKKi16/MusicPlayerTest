//
//  SearchButton.swift
//  MusicPlayerTest
//
//  Created by Anna Ruslanovna on 07.03.2025.
//

import SwiftUI

struct SearchButton: View {
    @Binding var searchText: String
    @State private var isExpanded = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack {
            if !isExpanded { Spacer() }
            
            HStack {
                if isExpanded {
                    TextField("Search...", text: $searchText)
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .transition(.opacity)
                        .focused($isTextFieldFocused)
                }
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        if searchText.isEmpty { isExpanded.toggle() }
                        isTextFieldFocused = isExpanded
                    }
                }) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 15.88, height: 15.88)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: 40, height: 40)
                
            }
            .frame(width: isExpanded ? nil : 40, height: 40)
            .background(Color.white.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 24)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isExpanded {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded = false
                    isTextFieldFocused = false
                }
            }
        }
    }
}
