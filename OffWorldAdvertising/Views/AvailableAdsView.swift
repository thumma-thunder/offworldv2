import SwiftUI

struct AvailableAdsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var availableCampaigns: [Campaign] = []
    @State private var selectedCampaign: Campaign?
    @State private var showingApplication = false
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    
    enum FilterOption: String, CaseIterable {
        case all = "All"
        case nearby = "Nearby"
        case highPaying = "High Paying"
        case new = "New"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Bar
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search campaigns...", text: $searchText)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(FilterOption.allCases, id: \.self) { filter in
                                Button(action: {
                                    selectedFilter = filter
                                }) {
                                    Text(filter.rawValue)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(selectedFilter == filter ? Color.blue : Color(.systemGray6))
                                        .foregroundColor(selectedFilter == filter ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
                
                // Campaigns List
                if availableCampaigns.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "megaphone")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No campaigns available")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Check back later for new advertising opportunities in your area")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredCampaigns) { campaign in
                                CampaignCard(campaign: campaign) {
                                    selectedCampaign = campaign
                                    showingApplication = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
            .navigationTitle("Available Ads")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadAvailableCampaigns()
        }
        .sheet(isPresented: $showingApplication) {
            if let campaign = selectedCampaign {
                CampaignApplicationView(campaign: campaign)
            }
        }
    }
    
    private var filteredCampaigns: [Campaign] {
        var campaigns = availableCampaigns
        
        // Apply search filter
        if !searchText.isEmpty {
            campaigns = campaigns.filter { campaign in
                campaign.title.localizedCaseInsensitiveContains(searchText) ||
                campaign.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply category filter
        switch selectedFilter {
        case .all:
            break
        case .nearby:
            campaigns = campaigns.filter { $0.isLocationBased }
        case .highPaying:
            campaigns = campaigns.filter { $0.monthlyPayment >= 30.0 }
        case .new:
            campaigns = campaigns.filter { 
                Calendar.current.dateInterval(of: .day, for: $0.createdAt)?.start == Calendar.current.dateInterval(of: .day, for: Date())?.start
            }
        }
        
        return campaigns
    }
    
    private func loadAvailableCampaigns() {
        // Simulate loading campaigns
        availableCampaigns = [
            Campaign(
                id: "1",
                advertiserId: "adv1",
                title: "Tech Startup - Mobile App",
                description: "Promote our new mobile app with a sleek, modern sticker design",
                stickerDesign: "",
                stickerSize: .medium,
                targetZipCodes: ["10001", "10002", "10003"],
                monthlyPayment: 35.0,
                maxStickers: 15,
                isLocationBased: true,
                isActive: true
            ),
            Campaign(
                id: "2",
                advertiserId: "adv2",
                title: "Local Restaurant - Grand Opening",
                description: "Help us spread the word about our grand opening with delicious food stickers",
                stickerDesign: "",
                stickerSize: .large,
                targetZipCodes: ["10001", "10002"],
                monthlyPayment: 25.0,
                maxStickers: 20,
                isLocationBased: true,
                isActive: true
            ),
            Campaign(
                id: "3",
                advertiserId: "adv3",
                title: "Fitness Center - New Year Special",
                description: "Join our fitness community and help others get fit with our motivational stickers",
                stickerDesign: "",
                stickerSize: .small,
                targetZipCodes: [],
                monthlyPayment: 20.0,
                maxStickers: 30,
                isLocationBased: false,
                isActive: true
            ),
            Campaign(
                id: "4",
                advertiserId: "adv4",
                title: "Eco-Friendly Products",
                description: "Promote sustainable living with our environmentally conscious sticker campaign",
                stickerDesign: "",
                stickerSize: .medium,
                targetZipCodes: ["10001", "10002", "10003", "10004"],
                monthlyPayment: 40.0,
                maxStickers: 10,
                isLocationBased: true,
                isActive: true
            )
        ]
    }
}

struct CampaignCard: View {
    let campaign: Campaign
    let onApply: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(campaign.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(campaign.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(String(format: "%.0f", campaign.monthlyPayment))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("per month")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Campaign Details
            VStack(spacing: 8) {
                HStack {
                    Label("\(campaign.maxStickers) spots available", systemImage: "person.2.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label(campaign.stickerSize.displayName, systemImage: "square.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if campaign.isLocationBased {
                    HStack {
                        Label("Location-based", systemImage: "location.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        
                        Spacer()
                        
                        Text("\(campaign.targetZipCodes.count) zip codes")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    HStack {
                        Label("Available everywhere", systemImage: "globe")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Spacer()
                    }
                }
            }
            
            // Apply Button
            Button(action: onApply) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Apply Now")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct CampaignApplicationView: View {
    let campaign: Campaign
    @Environment(\.dismiss) private var dismiss
    @State private var driverAddress = ""
    @State private var bankAccountNumber = ""
    @State private var routingNumber = ""
    @State private var bankName = ""
    @State private var accountHolderName = ""
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Campaign Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Campaign Details")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Title:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(campaign.title)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Monthly Payment:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("$\(String(format: "%.0f", campaign.monthlyPayment))")
                                    .foregroundColor(.green)
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text("Sticker Size:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(campaign.stickerSize.displayName)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Application Form
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Application Information")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Delivery Address")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            TextField("Enter your address for sticker delivery", text: $driverAddress, axis: .vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .lineLimit(2...4)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bank Account Details")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Account holder name", text: $accountHolderName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Bank name", text: $bankName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            HStack(spacing: 12) {
                                TextField("Account number", text: $bankAccountNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                                
                                TextField("Routing number", text: $routingNumber)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        }
                    }
                    
                    // Terms and Conditions
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Terms & Conditions")
                            .font(.headline)
                        
                        Text("By applying, you agree to:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Display the sticker prominently on your vehicle")
                            Text("• Submit monthly verification photos")
                            Text("• Maintain the sticker for the campaign duration")
                            Text("• Follow all local traffic laws")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Submit Button
                    Button(action: submitApplication) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text(isSubmitting ? "Submitting..." : "Submit Application")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canSubmit ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(!canSubmit || isSubmitting)
                }
                .padding(20)
            }
            .navigationTitle("Apply to Campaign")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var canSubmit: Bool {
        !driverAddress.isEmpty &&
        !bankAccountNumber.isEmpty &&
        !routingNumber.isEmpty &&
        !bankName.isEmpty &&
        !accountHolderName.isEmpty
    }
    
    private func submitApplication() {
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubmitting = false
            dismiss()
        }
    }
}

#Preview {
    AvailableAdsView()
}
