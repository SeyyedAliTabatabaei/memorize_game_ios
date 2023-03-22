//
//  memorizeApp.swift
//  memorize
//
//  Created by Seyyed Ali Tabatabaei on 3/17/23.
//

import SwiftUI

@main
struct memorizeApp: App {
    let game = MemoryGameViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
