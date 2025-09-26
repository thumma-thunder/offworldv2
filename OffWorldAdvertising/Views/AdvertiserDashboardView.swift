import SwiftUI

struct AdvertiserDashboardView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingOnboarding = false
    @State private var showingPayment = false
    @State private var activeCampaigns = 0
    @State private var totalSpent = 0.0
    @State private var driversReached = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Welcome back!")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Manage your advertising campaigns")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Stats Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCard(
                            title: "Active Campaigns",
                            value: "\(activeCampaigns)",
                            icon: "megaphone.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Drivers Reached",
                            value: "\(driversReached)",
                            icon: "car.fill",
                            color: .green
                        )
                        
                        StatCard(
                            title: "Total Spent",
                            value: "$\(String(format: "%.2f", totalSpent))",
                            icon: "dollarsign.circle.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Monthly Fee",
                            value: "$10.00",
                            icon: "calendar",
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
                                title: "Create New Campaign",
                                subtitle: "Design and launch a new sticker campaign",
                                icon: "plus.circle.fill",
                                color: .blue
                            ) {
                                showingOnboarding = true
                            }
                            
                            ActionButton(
                                title: "Manage Campaigns",
                                subtitle: "View and edit existing campaigns",
                                icon: "list.bullet",
                                color: .green
                            ) {
                                // Navigate to campaigns list
                            }
                            
                            ActionButton(
                                title: "Payment & Billing",
                                subtitle: "Manage payments and view invoices",
                                icon: "creditcard.fill",
                                color: .orange
                            ) {
                                showingPayment = true
                            }
                            
                            ActionButton(
                                title: "Analytics",
                                subtitle: "View campaign performance metrics",
                                icon: "chart.bar.fill",
                                color: .purple
                            ) {
                                // Navigate to analytics
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
                                title: "Campaign 'Summer Sale' approved",
                                subtitle: "Your campaign is now live and visible to drivers",
                                time: "2 hours ago",
                                icon: "checkmark.circle.fill",
                                color: .green
                            )
                            
                            ActivityItem(
                                title: "Payment processed",
                                subtitle: "Monthly fee of $10.00 charged",
                                time: "1 day ago",
                                icon: "creditcard.fill",
                                color: .blue
                            )
                            
                            ActivityItem(
                                title: "New driver application",
                                subtitle: "John Doe applied for your 'Tech Startup' campaign",
                                time: "3 days ago",
                                icon: "person.badge.plus",
                                color: .orange
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
            AdvertiserOnboardingView()
        }
        .sheet(isPresented: $showingPayment) {
            PaymentView()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ActivityItem: View {
    let title: String
    let subtitle: String
    let time: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    AdvertiserDashboardView()
        .environmentObject(AuthManager())
}
