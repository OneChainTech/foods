import Foundation

struct User: Identifiable, Codable {
    let id: String
    var name: String
    var avatarURL: String
    var gender: Gender
    var age: Int
    var bio: String
    
    enum Gender: String, Codable {
        case male = "男"
        case female = "女"
    }
}

struct UserMatch: Identifiable {
    let id: String
    let users: [User]
    let restaurant: Restaurant
    let matchTime: Date
}
