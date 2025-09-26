import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var companyName = ""
    @State private var fullName = ""
    @State private var isSignUp = false
    @State private var isLoading = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Image(systemName: authManager.selectedUserType == .advertiser ? "building.2.fill" : "car.fill")
                            .font(.system(size: 50))
                            .foregroundColor(authManager.selectedUserType == .advertiser ? .blue : .green)
                        
                        Text(authManager.selectedUserType == .advertiser ? "Advertiser Sign In" : "Driver Sign In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(isSignUp ? "Create your account" : "Welcome back")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        if isSignUp {
                            // Company Name (for advertisers) or Full Name (for drivers)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(authManager.selectedUserType == .advertiser ? "Company Name" : "Full Name")
                                    .font(.headline)
                                TextField(authManager.selectedUserType == .advertiser ? "Enter company name" : "Enter your full name", text: authManager.selectedUserType == .advertiser ? $companyName : $fullName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        
                        // Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.headline)
                            TextField("Enter your email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.headline)
                            SecureField("Enter your password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        // Confirm Password (for sign up)
                        if isSignUp {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Confirm Password")
                                    .font(.headline)
                                SecureField("Confirm your password", text: $confirmPassword)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    // Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal, 30)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        Button(action: handleAuth) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(isSignUp ? "Sign Up" : "Sign In")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(authManager.selectedUserType == .advertiser ? Color.blue : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(isLoading || !isFormValid)
                        
                        Button(action: {
                            isSignUp.toggle()
                            errorMessage = ""
                        }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .foregroundColor(authManager.selectedUserType == .advertiser ? .blue : .green)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        if isSignUp {
            if authManager.selectedUserType == .advertiser {
                return !companyName.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword
            } else {
                return !fullName.isEmpty && !email.isEmpty && !password.isEmpty && password == confirmPassword
            }
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
    
    private func handleAuth() {
        isLoading = true
        errorMessage = ""
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if isSignUp {
                // Handle sign up
                authManager.signUp(
                    email: email,
                    password: password,
                    userType: authManager.selectedUserType,
                    additionalInfo: authManager.selectedUserType == .advertiser ? companyName : fullName
                )
            } else {
                // Handle sign in
                authManager.signIn(email: email, password: password)
            }
            
            isLoading = false
            
            if authManager.isAuthenticated {
                dismiss()
            } else {
                errorMessage = "Invalid credentials. Please try again."
            }
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
}
