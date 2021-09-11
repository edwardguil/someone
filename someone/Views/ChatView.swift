//
//  ChatView.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//

import SwiftUI
import Combine
import Foundation

struct ChatView: View {
    @ObservedObject var viewModel: MessageViewModel
    
    var body: some View {
        List(viewModel.messages) {message in
                MessageView(message: message)
            }
    }
}

struct MessageView: View {

    var message:Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
        Text(message.text)
            .padding(10)
            .foregroundColor(message.isUser ? Color.white : Color.black)
            .background(message.isUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
        }
    }
}
