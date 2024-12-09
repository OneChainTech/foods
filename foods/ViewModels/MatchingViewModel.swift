import Foundation
import CoreLocation
import SwiftUI
import MapKit

class MatchingViewModel: ObservableObject {
    @Published var isMatching = false
    @Published var diningTime = Date()
    @Published var matchedUsers: [User] = []
    @Published var mapAnnotations: [UserAnnotation] = []
    
    private let mockUsers = [
        User(id: "1", name: "小明", avatarURL: "", gender: .male, age: 25, bio: "喜欢美食"),
        User(id: "2", name: "小红", avatarURL: "", gender: .female, age: 23, bio: "想交朋友"),
        User(id: "3", name: "小华", avatarURL: "", gender: .male, age: 27, bio: "美食达人")
    ]
    
    private let mockLocations = [
        CLLocationCoordinate2D(latitude: 31.2305, longitude: 121.4737),  // 上海人民广场
        CLLocationCoordinate2D(latitude: 31.2288, longitude: 121.4753),  // 南京东路
        CLLocationCoordinate2D(latitude: 31.2323, longitude: 121.4758),  // 外滩
        CLLocationCoordinate2D(latitude: 31.2297, longitude: 121.4762)   // 豫园
    ]
    
    func toggleMatching() {
        isMatching.toggle()
        if isMatching {
            startMatching()
        } else {
            stopMatching()
        }
    }
    
    private func startMatching() {
        // 随机选择两个用户进行匹配
        let shuffledUsers = mockUsers.shuffled()
        matchedUsers = Array(shuffledUsers.prefix(2))
        
        // 为匹配的用户生成随机位置（在餐厅500米范围内）
        updateMapAnnotations()
    }
    
    private func stopMatching() {
        matchedUsers.removeAll()
        mapAnnotations.removeAll()
    }
    
    private func updateMapAnnotations() {
        // 将匹配到的用户和位置信息组合
        mapAnnotations = zip(matchedUsers, mockLocations).map { user, location in
            UserAnnotation(
                id: user.id,
                user: user,
                coordinate: location
            )
        }
    }
}

struct UserAnnotation: Identifiable {
    let id: String
    let user: User
    let coordinate: CLLocationCoordinate2D
}
