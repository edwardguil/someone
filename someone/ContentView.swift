//
//  ContentView.swift
//  someone
//
//  Created by Christina Riabokon on 10/9/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel : MessageViewModel
    @StateObject private var loginVM = LoginViewModel()
    @State private var hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunched")
    @State var currentView = "first"
    
    var body: some View {
        if(!hasLaunched) {
            NewLaunchView(hasLaunched: $hasLaunched)
        } else {
            ChatView(viewModel: viewModel)
        }
    }
}

