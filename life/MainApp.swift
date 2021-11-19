//
//  MainApp.swift
//  life
//
//  Created by Michael on 11/19/21.
//

import SwiftUI

@main
struct MainApp: App {
    @State private var isPlaying: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView(isPlaying: $isPlaying)
            Button("Toggle") {
                isPlaying.toggle()
            }
        }
    }
}
