//
//  SwiftUIView.swift
//  SwinjectPL
//
//  Created by Mauricio Fuentes Bravo on 24-11-25.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Title
            Subtitle
            PrintButton            
        }
    }
    
    // Mark: Internal variables as views
    var Title: some View {
        Text("Title!")
            .font(.largeTitle)
            .foregroundColor(.cyan)
    }
    
    var Subtitle: some View {
        Text("Subtitle")
            .font(.title2)
            .fontWeight(.medium)
    }
    
    var PrintButton: some View {
        Button{
            print("Aloha")
        } label: {
            Text("Print aloha")
        }
    }
}

#Preview {
    SwiftUIView()
}
