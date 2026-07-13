//
//  ContentView.swift
//  TextSurvival
//
//  Created by David Wells on 7/9/26.
//

import SwiftUI

struct ContentView: View {
    @State var loaded = false
    
    
    var body: some View {
        VStack {
            if loaded {
                StartingScreen()
            } else {
                LoadingPage()
            }
        }
        .padding()
        .task {
            loaded = true
        }
    }
}

#Preview {
    ContentView()
}
