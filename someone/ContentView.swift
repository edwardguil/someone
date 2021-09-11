//
//  ContentView.swift
//  someone
//
//  Created by Christina Riabokon on 10/9/21.
//

import SwiftUI

struct ContentView: View {
    
    
    @StateObject private var loginVM = LoginViewModel()
    
    var body: some View {
        TextField("First Name", text: $loginVM.firstName)
        HStack {
            Spacer()
            Button("Enter") {
                loginVM.login()
            }.buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
