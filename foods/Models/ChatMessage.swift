import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isFromCurrentUser: Bool
    let timestamp: Date
    
    init(content: String, isFromCurrentUser: Bool, timestamp: Date = Date()) {
        self.content = content
        self.isFromCurrentUser = isFromCurrentUser
        self.timestamp = timestamp
    }
}
