import SwiftUI

struct PaymentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    @State private var paymentHistory: [Payment] = []
    @State private var upcomingPayments: [Payment] = []
    @State private var showingAddPaymentMethod = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Selector
                Picker("Payment Tabs", selection: $selectedTab) {
                    Text("History").tag(0)
                    Text("Upcoming").tag(1)
                    Text("Methods").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    // Payment History
                    paymentHistoryView
                        .tag(0)
                    
                    // Upcoming Payments
                    upcomingPaymentsView
                        .tag(1)
                    
                    // Payment Methods
                    paymentMethodsView
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Payments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadPaymentData()
        }
        .sheet(isPresented: $showingAddPaymentMethod) {
            AddPaymentMethodView()
        }
    }
    
    // MARK: - Payment History View
    private var paymentHistoryView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if paymentHistory.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No payment history")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your payment history will appear here")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(paymentHistory) { payment in
                        PaymentHistoryCard(payment: payment)
                    }
                }
            }
            .padding(20)
        }
    }
    
    // MARK: - Upcoming Payments View
    private var upcomingPaymentsView: some View {
        ScrollView {
            VStack(spacing: 16) {
                if upcomingPayments.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No upcoming payments")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Your upcoming payments will appear here")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ForEach(upcomingPayments) { payment in
                        UpcomingPaymentCard(payment: payment)
                    }
                }
            }
            .padding(20)
        }
    }
    
    // MARK: - Payment Methods View
    private var paymentMethodsView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Current Payment Methods
                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment Methods")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        PaymentMethodCard(
                            type: "Bank Account",
                            details: "****1234",
                            isDefault: true
                        )
                        
                        PaymentMethodCard(
                            type: "Credit Card",
                            details: "****5678",
                            isDefault: false
                        )
                    }
                }
                
                // Add New Method
                Button(action: {
                    showingAddPaymentMethod = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                        Text("Add Payment Method")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(12)
                }
                
                // Billing Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Billing Information")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Billing Address:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("123 Main St, City, State 12345")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Tax ID:")
                                .fontWeight(.medium)
                            Spacer()
                            Text("12-3456789")
                                .foregroundColor(.secondary)
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
    
    private func loadPaymentData() {
        // Simulate loading payment data
        paymentHistory = [
            Payment(
                id: "1",
                userId: "user1",
                amount: 10.00,
                type: .monthlyFee,
                status: .completed,
                description: "Monthly platform fee",
                createdAt: Date().addingTimeInterval(-86400 * 5),
                processedAt: Date().addingTimeInterval(-86400 * 5)
            ),
            Payment(
                id: "2",
                userId: "user1",
                amount: 15.00,
                type: .stickerFee,
                status: .completed,
                description: "Sticker manufacturing fee (10 stickers)",
                createdAt: Date().addingTimeInterval(-86400 * 3),
                processedAt: Date().addingTimeInterval(-86400 * 3)
            ),
            Payment(
                id: "3",
                userId: "user1",
                amount: 250.00,
                type: .driverPayment,
                status: .completed,
                description: "Driver payments (10 drivers)",
                createdAt: Date().addingTimeInterval(-86400 * 1),
                processedAt: Date().addingTimeInterval(-86400 * 1)
            )
        ]
        
        upcomingPayments = [
            Payment(
                id: "4",
                userId: "user1",
                amount: 10.00,
                type: .monthlyFee,
                status: .pending,
                description: "Monthly platform fee",
                createdAt: Date().addingTimeInterval(86400 * 25),
                processedAt: nil
            ),
            Payment(
                id: "5",
                userId: "user1",
                amount: 15.00,
                type: .stickerFee,
                status: .pending,
                description: "Sticker manufacturing fee (10 stickers)",
                createdAt: Date().addingTimeInterval(86400 * 25),
                processedAt: nil
            )
        ]
    }
}

struct PaymentHistoryCard: View {
    let payment: Payment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.type.displayName)
                    .font(.headline)
                
                Text(payment.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(payment.createdAt, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", payment.amount))")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(payment.status == .completed ? .green : .orange)
                
                Text(payment.status.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct UpcomingPaymentCard: View {
    let payment: Payment
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(payment.type.displayName)
                    .font(.headline)
                
                Text(payment.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Due: \(payment.createdAt, style: .date)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(String(format: "%.2f", payment.amount))")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                
                Text("Pending")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
}

struct PaymentMethodCard: View {
    let type: String
    let details: String
    let isDefault: Bool
    
    var body: some View {
        HStack {
            Image(systemName: type == "Bank Account" ? "building.columns.fill" : "creditcard.fill")
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type)
                    .font(.headline)
                
                Text(details)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isDefault {
                Text("Default")
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct AddPaymentMethodView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMethod = 0
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var bankName = ""
    @State private var accountNumber = ""
    @State private var routingNumber = ""
    
    private let paymentMethods = ["Credit Card", "Bank Account"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Payment Method Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Method")
                            .font(.headline)
                        
                        Picker("Payment Method", selection: $selectedMethod) {
                            ForEach(0..<paymentMethods.count, id: \.self) { index in
                                Text(paymentMethods[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Form Fields
                    if selectedMethod == 0 {
                        // Credit Card Form
                        VStack(spacing: 16) {
                            TextField("Card Number", text: $cardNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            HStack(spacing: 12) {
                                TextField("MM/YY", text: $expiryDate)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("CVV", text: $cvv)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                            
                            TextField("Cardholder Name", text: $cardholderName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    } else {
                        // Bank Account Form
                        VStack(spacing: 16) {
                            TextField("Bank Name", text: $bankName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("Account Number", text: $accountNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            TextField("Routing Number", text: $routingNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                    
                    // Security Notice
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
                    
                    // Add Button
                    Button("Add Payment Method") {
                        // Add payment method logic
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(20)
            }
            .navigationTitle("Add Payment Method")
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
}

#Preview {
    PaymentView()
}
