import SwiftUI

struct DriverDashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingOnboarding = false
    @State private var showingAvailableAds = false
    @State private var showingCameraVerification = false
    @State private var currentEarnings = 0.0
    @State private var activeStickers = 0
    @State private var monthlyEarnings = 0.0
    @State private var pendingApplications = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Welcome back!")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Manage your sticker campaigns and earnings")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Stats Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "Current Earnings",
                            value: "$\(String(format: "%.2f", currentEarnings))",
                            icon: "dollarsign.circle.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Active Stickers",
                            value: "\(activeStickers)",
                            icon: "car.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Monthly Earnings",
                            value: "$\(String(format: "%.2f", monthlyEarnings))",
                            icon: "calendar",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Pending Apps",
                            value: "\(pendingApplications)",
                            icon: "clock.fill",
                            color: .purple
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ActionButton(
                                title: "Browse Available Ads",
                                subtitle: "Find new sticker campaigns to apply for",
                                icon: "magnifyingglass.circle.fill",
                                color: .blue
                            ) {
                                showingAvailableAds = true
                            }
                            
                            ActionButton(
                                title: "My Applications",
                                subtitle: "Track your pending and approved applications",
                                icon: "list.bullet",
                                color: .green
                            ) {
                                // Navigate to applications list
                            }
                            
                            ActionButton(
                                title: "Photo Verification",
                                subtitle: "Submit monthly verification photos",
                                icon: "camera.fill",
                                color: .orange
                            ) {
                                showingCameraVerification = true
                            }
                            
                            ActionButton(
                                title: "Earnings & Payments",
                                subtitle: "View your earnings and payment history",
                                icon: "creditcard.fill",
                                color: .purple
                            ) {
                                // Navigate to earnings
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recent Activity")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ActivityItem(
                                title: "Application approved",
                                subtitle: "Your application for 'Tech Startup' campaign was approved",
                                time: "1 hour ago",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                            
                            ActivityItem(
                                title: "Payment received",
                                subtitle: "Monthly payment of $45.00 received",
                                time: "2 days ago",
                                icon: "dollarsign.circle.fill",
                                color: .blue
                            )
                            
                            ActivityItem(
                                title: "Photo verification due",
                                subtitle: "Submit verification photos for active campaigns",
                                time: "3 days ago",
                                icon: "camera.circle.fill",
                                color: .orange
                            )
                            
                            ActivityItem(
                                title: "New campaign available",
                                subtitle: "Local Restaurant campaign now accepting applications",
                                time: "5 days ago",
                                icon: "megaphone.fill",
                                color: .purple
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Earnings Breakdown
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Earnings Breakdown")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            EarningsItem(
                                campaign: "Tech Startup",
                                amount: 25.00,
                                status: "Active"
                            )
                            
                            EarningsItem(
                                campaign: "Local Restaurant",
                                amount: 20.00,
                                status: "Active"
                            )
                            
                            EarningsItem(
                                campaign: "Fitness Center",
                                amount: 15.00,
                                status: "Completed"
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Profile") { }
                        Button("Settings") { }
                        Button("Help") { }
                        Divider()
                        Button("Sign Out", role: .destructive) {
                            authManager.signOut()
                        }
                    } label: {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showingOnboarding) {
            DriverOnboardingView()
        }
        .sheet(isPresented: $showingAvailableAds) {
            AvailableAdsView()
        }
        .sheet(isPresented: $showingCameraVerification) {
            CameraVerificationView()
        }
    }
}

struct EarningsItem: View {
    let campaign: String
    let amount: Double
    let status: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(campaign)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(status)
                    .font(.caption)
                    .foregroundColor(status == "Active" ? .green : .secondary)
            }
            
            Spacer()
            
            Text("$\(String(format: "%.2f", amount))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    DriverDashboardView()
        .environmentObject(AuthManager())
}
