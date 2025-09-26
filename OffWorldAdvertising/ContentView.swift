import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                if authManager.userType == .advertiser {
                    AdvertiserDashboardView()
                } else {
                    DriverDashboardView()
                }
            } else {
                WelcomeView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
}
