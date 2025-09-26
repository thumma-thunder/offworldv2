import Foundation
import SwiftUI

enum UserType: String, CaseIterable, Codable {
    case advertiser = "advertiser"
    case driver = "driver"
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userType: UserType?
    @Published var selectedUserType: UserType = .advertiser
    @Published var currentUser: User?
    
    init() {
        // Check for existing authentication
        checkAuthStatus()
    }
    
    func signUp(email: String, password: String, userType: UserType, additionalInfo: String) {
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let user = User(
                id: UUID().uuidString,
                email: email,
                userType: userType,
                companyName: userType == .advertiser ? additionalInfo : nil,
                fullName: userType == .driver ? additionalInfo : nil,
                isOnboarded: false
            )
            
            self.currentUser = user
            self.userType = userType
            self.isAuthenticated = true
            
            // Store in UserDefaults for persistence
            self.saveUser(user)
        }
    }
    
    func signIn(email: String, password: String) {
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // For demo purposes, accept any email/password combination
            let user = User(
                id: UUID().uuidString,
                email: email,
                userType: self.selectedUserType,
                companyName: self.selectedUserType == .advertiser ? "Demo Company" : nil,
                fullName: self.selectedUserType == .driver ? "Demo Driver" : nil,
                isOnboarded: true
            )
            
            self.currentUser = user
            self.userType = self.selectedUserType
            self.isAuthenticated = true
            
            // Store in UserDefaults for persistence
            self.saveUser(user)
        }
    }
    
    func signOut() {
        isAuthenticated = false
        userType = nil
        currentUser = nil
        
        // Clear stored data
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
    
    private func checkAuthStatus() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            userType = user.userType
            isAuthenticated = true
        }
    }
    
    private func saveUser(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
    }
}
