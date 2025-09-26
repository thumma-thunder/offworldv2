import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    static let shared = NetworkManager()
    
    private let baseURL = "https://api.offworldadvertising.com" // Replace with actual API URL
    private let session = URLSession.shared
    
    private init() {}
    
    // MARK: - Authentication
    func signUp(email: String, password: String, userType: UserType, additionalInfo: String) async throws -> User {
        let endpoint = "/auth/signup"
        let body = [
            "email": email,
            "password": password,
            "userType": userType.rawValue,
            "additionalInfo": additionalInfo
        ]
        
        return try await performRequest(endpoint: endpoint, method: "POST", body: body, responseType: User.self)
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let endpoint = "/auth/signin"
        let body = [
            "email": email,
            "password": password
        ]
        
        return try await performRequest(endpoint: endpoint, method: "POST", body: body, responseType: User.self)
    }
    
    // MARK: - Campaigns
    func createCampaign(_ campaign: Campaign) async throws -> Campaign {
        let endpoint = "/campaigns"
        return try await performRequest(endpoint: endpoint, method: "POST", body: campaign, responseType: Campaign.self)
    }
    
    func getCampaigns(for userId: String, userType: UserType) async throws -> [Campaign] {
        let endpoint = "/campaigns?userId=\(userId)&userType=\(userType.rawValue)"
        return try await performRequest(endpoint: endpoint, method: "GET", responseType: [Campaign].self)
    }
    
    func getAvailableCampaigns(for zipCodes: [String]) async throws -> [Campaign] {
        let endpoint = "/campaigns/available"
        let body = ["zipCodes": zipCodes]
        return try await performRequest(endpoint: endpoint, method: "POST", body: body, responseType: [Campaign].self)
    }
    
    // MARK: - Applications
    func submitApplication(_ application: Application) async throws -> Application {
        let endpoint = "/applications"
        return try await performRequest(endpoint: endpoint, method: "POST", body: application, responseType: Application.self)
    }
    
    func getApplications(for userId: String) async throws -> [Application] {
        let endpoint = "/applications?userId=\(userId)"
        return try await performRequest(endpoint: endpoint, method: "GET", responseType: [Application].self)
    }
    
    // MARK: - Payments
    func getPayments(for userId: String) async throws -> [Payment] {
        let endpoint = "/payments?userId=\(userId)"
        return try await performRequest(endpoint: endpoint, method: "GET", responseType: [Payment].self)
    }
    
    func processPayment(_ payment: Payment) async throws -> Payment {
        let endpoint = "/payments"
        return try await performRequest(endpoint: endpoint, method: "POST", body: payment, responseType: Payment.self)
    }
    
    // MARK: - Photo Verification
    func submitPhotoVerification(_ verification: PhotoVerification) async throws -> PhotoVerification {
        let endpoint = "/verifications"
        return try await performRequest(endpoint: endpoint, method: "POST", body: verification, responseType: PhotoVerification.self)
    }
    
    func getVerifications(for userId: String) async throws -> [PhotoVerification] {
        let endpoint = "/verifications?userId=\(userId)"
        return try await performRequest(endpoint: endpoint, method: "GET", responseType: [PhotoVerification].self)
    }
    
    // MARK: - Generic Request Method
    private func performRequest<T: Codable>(
        endpoint: String,
        method: String,
        body: Any? = nil,
        responseType: T.Type
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add authentication token if available
        if let token = getAuthToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Add body if provided
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                throw NetworkError.encodingError
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard httpResponse.statusCode == 200 else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(responseType, from: data)
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.networkError(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Methods
    private func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
    
    private func saveAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    private func clearAuthToken() {
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}

// MARK: - Network Error Types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case invalidResponse
    case serverError(Int)
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .encodingError:
            return "Failed to encode request data"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

// MARK: - Mock Data for Development
extension NetworkManager {
    func getMockCampaigns() -> [Campaign] {
        return [
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
            )
        ]
    }
    
    func getMockPayments() -> [Payment] {
        return [
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
    }
}
