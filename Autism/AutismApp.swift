//
//  AutismApp.swift
//  Autism
//
//  Created by Ethelyn Huang on 19/3/23.
//

import SwiftUI

 @main
struct AutismApp: App {
    @StateObject private var game = Game()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(game)
        }
    }
}
