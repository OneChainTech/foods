import Foundation
import CoreLocation

class HomeViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        // 初始化时立即加载数据
        loadMockRestaurants()
    }
    
    func loadMockRestaurants() {
        // 模拟餐厅数据
        let mockRestaurants = [
            Restaurant(
                id: "1",
                name: "川味小馆",
                address: "上海市黄浦区南京东路123号",
                type: .sichuan,
                imageURL: "https://example.com/sichuan.jpg",
                latitude: 31.2304,
                longitude: 121.4737
            ),
            Restaurant(
                id: "2",
                name: "寿司之家",
                address: "上海市静安区南京西路456号",
                type: .japanese,
                imageURL: "https://example.com/japanese.jpg",
                latitude: 31.2352,
                longitude: 121.4692
            ),
            Restaurant(
                id: "3",
                name: "快乐快餐",
                address: "上海市徐汇区肇嘉浜路789号",
                type: .fastFood,
                imageURL: "https://example.com/fastfood.jpg",
                latitude: 31.2141,
                longitude: 121.4833
            )
        ]
        
        // 根据用户位置筛选 500m 内的餐厅
        if let userLocation = locationManager.location {
            self.restaurants = mockRestaurants.filter { restaurant in
                let restaurantLocation = CLLocation(
                    latitude: restaurant.latitude,
                    longitude: restaurant.longitude
                )
                let distance = userLocation.distance(from: restaurantLocation)
                return distance <= 500 // 500米内
            }
        } else {
            // 如果没有位置信息，显示所有餐厅
            self.restaurants = mockRestaurants
        }
    }
    
    func refreshRestaurants() {
        loadMockRestaurants()
    }
}

struct RestaurantsResponse: Codable {
    let restaurants: [Restaurant]
}
