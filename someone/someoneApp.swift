//
//  someoneApp.swift
//  someone
//
//  Created by Christina Riabokon on 10/9/21.
//

import SwiftUI

@main
struct someoneApp: App {
    let messageViewModel = MessageViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel : messageViewModel)
        }
    }
}
