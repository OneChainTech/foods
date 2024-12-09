import SwiftUI

struct BlinkingCircleView: View {
    @State private var isAnimating = false
    let color: Color
    
    var body: some View {
        ZStack {
            // 外圈动画
            Circle()
                .stroke(color.opacity(0.5), lineWidth: 3)
                .scaleEffect(isAnimating ? 1.8 : 1.0)
                .opacity(isAnimating ? 0 : 0.8)
            
            // 内圈动画
            Circle()
                .stroke(color.opacity(0.8), lineWidth: 3)
                .scaleEffect(isAnimating ? 1.4 : 1.0)
                .opacity(isAnimating ? 0 : 0.8)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}
