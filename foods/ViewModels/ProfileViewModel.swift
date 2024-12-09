import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var profileImage: UIImage?
    @Published var name: String = ""
    @Published var gender: User.Gender = .male
    @Published var age: Int = 18
    @Published var bio: String = ""
    
    init() {
        loadProfile()
    }
    
    func saveProfile() {
        // 这里实现保存用户资料的逻辑
        // 可以保存到 UserDefaults 或发送到服务器
    }
    
    private func loadProfile() {
        // 这里实现加载用户资料的逻辑
        // 可以从 UserDefaults 或服务器加载
    }
}
