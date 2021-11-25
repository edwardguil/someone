//
//  Message.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//

import Foundation

struct Message: Identifiable, Decodable, Hashable {
    var id = UUID()
    var text: String
    var isUser : Bool
}
