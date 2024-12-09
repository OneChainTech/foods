import SwiftUI

struct ChatView: View {
    let matchedUser: User
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @StateObject private var viewModel = ChatViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // 自定义导航栏
            HStack {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text(matchedUser.name)
                            .foregroundColor(.primary)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 1, y: 1)
            
            // 聊天内容
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message)
                    }
                }
                .padding(.vertical)
            }
            
            // 输入框
            HStack {
                TextField("发送消息...", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: {
                    if !messageText.isEmpty {
                        viewModel.sendMessage(messageText)
                        messageText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 1, y: -1)
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadMessages(for: matchedUser)
        }
    }
}

struct ChatBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                Text(message.content)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
