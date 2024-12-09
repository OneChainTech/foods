import Foundation
import CoreLocation

struct Restaurant: Identifiable, Codable {
    let id: String
    let name: String
    let address: String
    let type: CuisineType
    let imageURL: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

enum CuisineType: String, Codable {
    case sichuan = "川菜"
    case japanese = "日料"
    case fastFood = "快餐"
    case hotPot = "火锅"
    case cantonese = "粤菜"
    case other = "其他"
}
