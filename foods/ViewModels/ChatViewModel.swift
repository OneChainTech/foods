import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var matchedUser: User?
    
    func loadMessages(for user: User) {
        self.matchedUser = user
        // 这里可以从服务器加载历史消息
        // 目前使用模拟数据
        messages = [
            ChatMessage(content: "你好，一起去吃饭吗？", isFromCurrentUser: false),
            ChatMessage(content: "好啊，什么时候？", isFromCurrentUser: true),
            ChatMessage(content: "12点怎么样？", isFromCurrentUser: false)
        ]
    }
    
    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        
        let newMessage = ChatMessage(content: text, isFromCurrentUser: true)
        messages.append(newMessage)
        
        // 模拟对方回复
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            let reply = ChatMessage(
                content: "好的，没问题！",
                isFromCurrentUser: false
            )
            self?.messages.append(reply)
        }
    }
}
