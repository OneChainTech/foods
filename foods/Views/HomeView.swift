import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel: HomeViewModel
    @State private var isShowingProfile = false
    
    init() {
        let locationManager = LocationManager()
        _viewModel = StateObject(wrappedValue: HomeViewModel(locationManager: locationManager))
        _locationManager = StateObject(wrappedValue: locationManager)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部导航栏
                HStack {
                    Text("饭搭子")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button(action: { isShowingProfile = true }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                // 餐厅列表
                if viewModel.restaurants.isEmpty {
                    ContentUnavailableView("附近暂无餐厅", 
                        systemImage: "fork.knife.circle")
                        .offset(y: -50) // 调整空状态显示的位置
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.restaurants) { restaurant in
                                NavigationLink(destination: MatchingView(restaurant: restaurant)) {
                                    RestaurantRow(restaurant: restaurant)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .refreshable {
                        await refreshData()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $isShowingProfile) {
            ProfileView()
        }
    }
    
    private func refreshData() async {
        viewModel.refreshRestaurants()
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
}

struct RestaurantRow: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 餐厅图片
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 150)
                .overlay(
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                )
                .clipped()
            
            // 餐厅信息
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .center) {
                    Text(restaurant.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(restaurant.type.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text(restaurant.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
