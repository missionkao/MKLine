//
//  LinePushMessages.swift
//  
//
//  Created by Mason Kao on 2023/4/10.
//

import Foundation

public struct LinePushMessages: Codable, MessagesProtocol {
    public enum MessageType: String {
        case text
    }
    
    public struct Message: Codable {
        let type: String
        let text: String
        
        public init(type: MessageType, text: String) {
            self.type = type.rawValue
            self.text = text
        }
    }
    
    let to: String
    let messages: [Message]
    
    public init(to: String, messages: [Message]) {
        self.to = to
        self.messages = messages
    }
    
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
}
