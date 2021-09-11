//
//  Message.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//

import Foundation

struct Message: Decodable {
    let text: String
    var response: MessageResponse
}
