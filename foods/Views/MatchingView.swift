import SwiftUI
import MapKit

struct MatchingView: View {
    let restaurant: Restaurant
    @StateObject private var viewModel = MatchingViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var cameraPosition: MapCameraPosition
    @State private var chatRequestUser: User?
    @State private var showTimePicker = false
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        let region = MKCoordinateRegion(
            center: restaurant.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        _cameraPosition = State(initialValue: .region(region))
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                navigationBar
                mapView(geometry: geometry)
                controlPanel
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showTimePicker) {
            timePickerView
        }
        .onReceive(NotificationCenter.default.publisher(for: .newChatRequest)) { notification in
            handleChatRequest(notification)
        }
    }
    
    private var navigationBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                    Text(restaurant.name)
                        .foregroundColor(.primary)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private func mapView(geometry: GeometryProxy) -> some View {
        Map(position: $cameraPosition) {
            Marker("餐厅", coordinate: restaurant.coordinate)
                .tint(.red)
            
            ForEach(viewModel.mapAnnotations) { annotation in
                Annotation(
                    "",
                    coordinate: annotation.coordinate,
                    anchor: .center
                ) {
                    NavigationLink {
                        ChatView(matchedUser: annotation.user)
                    } label: {
                        ZStack {
                            UserAnnotationView(user: annotation.user)
                                .contentShape(Circle())
                            
                            if chatRequestUser?.id == annotation.user.id {
                                BlinkingCircleView(color: annotation.user.gender == .male ? .blue : .pink)
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(height: geometry.size.height * 0.5)
        .padding(.bottom, 20)
    }
    
    private var controlPanel: some View {
        VStack(spacing: 24) {
            timeButton
            matchButton
        }
        .padding(.horizontal)
    }
    
    private var timeButton: some View {
        Button(action: { showTimePicker = true }) {
            VStack(spacing: 8) {
                Text("就餐时间")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text(DateFormatters.chineseTimeFormatter.string(from: viewModel.diningTime))
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var matchButton: some View {
        Button(action: {
            viewModel.toggleMatching()
            updateMapRegionIfNeeded()
        }) {
            Text(viewModel.isMatching ? "停止匹配" : "开始匹配")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isMatching ? Color.red : Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
    
    private var timePickerView: some View {
        DatePicker("选择时间", selection: $viewModel.diningTime, displayedComponents: [.hourAndMinute])
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding()
    }
    
    private func updateMapRegionIfNeeded() {
        if viewModel.isMatching {
            let annotations = viewModel.mapAnnotations.map { $0.coordinate }
            let region = MKCoordinateRegion(
                coordinates: annotations + [restaurant.coordinate]
            )
            cameraPosition = .region(region)
        }
    }
    
    private func handleChatRequest(_ notification: Notification) {
        guard let user = notification.object as? User else { return }
        
        chatRequestUser = user
        
        if let userAnnotation = viewModel.mapAnnotations.first(where: { $0.user.id == user.id }) {
            withAnimation {
                cameraPosition = .region(MKCoordinateRegion(
                    center: userAnnotation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ))
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            chatRequestUser = nil
        }
    }
}

struct UserAnnotationView: View {
    let user: User
    
    var body: some View {
        AsyncImage(url: URL(string: user.avatarURL)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .foregroundColor(.gray)
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(user.gender == .male ? Color.blue : Color.pink, lineWidth: 2)
        )
    }
}

extension Notification.Name {
    static let newChatRequest = Notification.Name("newChatRequest")
}

extension MKCoordinateRegion {
    init(coordinates: [CLLocationCoordinate2D]) {
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.2,
            longitudeDelta: (maxLon - minLon) * 1.2
        )
        
        self.init(center: center, span: span)
    }
}
