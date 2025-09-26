import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingAuth = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                // Logo and Title
                VStack(spacing: 20) {
                    Image(systemName: "car.2.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("OffWorld Advertising")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Turn your car into a money-making machine")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // User Type Selection
                VStack(spacing: 20) {
                    Text("Choose your role:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 16) {
                        // Advertiser Button
                        Button(action: {
                            authManager.selectedUserType = .advertiser
                            showingAuth = true
                        }) {
                            HStack {
                                Image(systemName: "building.2.fill")
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text("Advertiser")
                                        .font(.headline)
                                    Text("Promote your business")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                        }
                        
                        // Driver Button
                        Button(action: {
                            authManager.selectedUserType = .driver
                            showingAuth = true
                        }) {
                            HStack {
                                Image(systemName: "car.fill")
                                    .font(.title2)
                                VStack(alignment: .leading) {
                                    Text("Driver")
                                        .font(.headline)
                                    Text("Earn money with your car")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "arrow.right")
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .foregroundColor(.green)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Features
                VStack(spacing: 12) {
                    Text("How it works:")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Image(systemName: "1.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Sign Up")
                                .font(.caption)
                        }
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.secondary)
                        
                        VStack {
                            Image(systemName: "2.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Get Stickers")
                                .font(.caption)
                        }
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(.secondary)
                        
                        VStack {
                            Image(systemName: "3.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Earn Money")
                                .font(.caption)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingAuth) {
            AuthView()
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AuthManager())
}
