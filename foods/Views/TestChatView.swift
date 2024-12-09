import SwiftUI

struct TestChatView: View {
    let matchedUser: User
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("测试页面")
                .font(.largeTitle)
            
            Text("当前用户: \(matchedUser.name)")
                .padding()
            
            Button("关闭") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding()
        }
    }
}
