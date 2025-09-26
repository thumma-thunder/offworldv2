import SwiftUI

struct DriverOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var zipCodes: [String] = []
    @State private var newZipCode = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var bankAccountNumber = ""
    @State private var routingNumber = ""
    @State private var bankName = ""
    @State private var accountHolderName = ""
    
    private let totalSteps = 3
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                
                // Step Content
                TabView(selection: $currentStep) {
                    // Step 1: Location Setup
                    locationSetupStep
                        .tag(0)
                    
                    // Step 2: Personal Information
                    personalInfoStep
                        .tag(1)
                    
                    // Step 3: Payment Information
                    paymentInfoStep
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
                
                // Navigation Buttons
                HStack {
                    if currentStep > 0 {
                        Button("Previous") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    Button(currentStep == totalSteps - 1 ? "Complete Setup" : "Next") {
                        if currentStep == totalSteps - 1 {
                            completeSetup()
                        } else {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(canProceed ? Color.green : Color.gray)
                    .cornerRadius(8)
                    .disabled(!canProceed)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Driver Setup")
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
    
    // MARK: - Step 1: Location Setup
    private var locationSetupStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Where do you drive?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Add the zip codes where you typically drive to see relevant advertising opportunities")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    // Zip code input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add Zip Codes")
                            .font(.headline)
                        
                        HStack {
                            TextField("Enter zip code", text: $newZipCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            Button("Add") {
                                if !newZipCode.isEmpty && !zipCodes.contains(newZipCode) {
                                    zipCodes.append(newZipCode)
                                    newZipCode = ""
                                }
                            }
                            .disabled(newZipCode.isEmpty)
                        }
                        
                        if !zipCodes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Your zip codes:")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                    ForEach(zipCodes, id: \.self) { zipCode in
                                        HStack {
                                            Text(zipCode)
                                                .font(.caption)
                                            Button(action: {
                                                zipCodes.removeAll { $0 == zipCode }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .font(.caption)
                                            }
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Benefits
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Benefits of adding zip codes:")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            BenefitRow(icon: "dollarsign.circle.fill", text: "Higher paying campaigns in your area")
                            BenefitRow(icon: "location.circle.fill", text: "Location-specific opportunities")
                            BenefitRow(icon: "bell.circle.fill", text: "Notifications for new campaigns")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(20)
        }
    }
    
    // MARK: - Step 2: Personal Information
    private var personalInfoStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Personal Information")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("We need some basic information to verify your identity and process payments")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.headline)
                        TextField("Enter your full name", text: $fullName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.headline)
                        TextField("(555) 123-4567", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Address")
                            .font(.headline)
                        TextField("Street address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("City")
                                .font(.headline)
                            TextField("City", text: $city)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("State")
                                .font(.headline)
                            TextField("State", text: $state)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ZIP")
                                .font(.headline)
                            TextField("ZIP", text: $zipCode)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
    
    // MARK: - Step 3: Payment Information
    private var paymentInfoStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Payment Information")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Add your bank account details to receive payments for displaying stickers")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Account Holder Name")
                            .font(.headline)
                        TextField("Name on bank account", text: $accountHolderName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bank Name")
                            .font(.headline)
                        TextField("Your bank name", text: $bankName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Account Number")
                            .font(.headline)
                        TextField("Account number", text: $bankAccountNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Routing Number")
                            .font(.headline)
                        TextField("Routing number", text: $routingNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    // Security notice
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.green)
                            Text("Your information is secure")
                                .font(.headline)
                        }
                        
                        Text("We use bank-level encryption to protect your financial information. Your data is never shared with third parties.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(20)
            }
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !zipCodes.isEmpty
        case 1:
            return !fullName.isEmpty && !phoneNumber.isEmpty && !address.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
        case 2:
            return !accountHolderName.isEmpty && !bankName.isEmpty && !bankAccountNumber.isEmpty && !routingNumber.isEmpty
        default:
            return false
        }
    }
    
    private func completeSetup() {
        // Complete setup logic here
        print("Completing driver setup for: \(fullName)")
        dismiss()
    }
}

struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
    }
}

#Preview {
    DriverOnboardingView()
}
