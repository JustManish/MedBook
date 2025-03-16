//
//  SearchBar.swift
//  MedBook
//
//  Created by Manish Patidar on 15/03/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass") // Search icon
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Search for books", text: $text)
                .padding(8)
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

#Preview {
    SearchBar(text: .constant("search"))
}
