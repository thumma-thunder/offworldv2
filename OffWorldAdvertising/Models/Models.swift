import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    let email: String
    let userType: UserType
    let companyName: String?
    let fullName: String?
    let isOnboarded: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String, email: String, userType: UserType, companyName: String?, fullName: String?, isOnboarded: Bool) {
        self.id = id
        self.email = email
        self.userType = userType
        self.companyName = companyName
        self.fullName = fullName
        self.isOnboarded = isOnboarded
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Campaign Model
struct Campaign: Codable, Identifiable {
    let id: String
    let advertiserId: String
    let title: String
    let description: String
    let stickerDesign: String // Base64 encoded image or URL
    let stickerSize: StickerSize
    let targetZipCodes: [String]
    let monthlyPayment: Double
    let maxStickers: Int
    let isLocationBased: Bool
    let isActive: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(id: String, advertiserId: String, title: String, description: String, stickerDesign: String, stickerSize: StickerSize, targetZipCodes: [String], monthlyPayment: Double, maxStickers: Int, isLocationBased: Bool, isActive: Bool) {
        self.id = id
        self.advertiserId = advertiserId
        self.title = title
        self.description = description
        self.stickerDesign = stickerDesign
        self.stickerSize = stickerSize
        self.targetZipCodes = targetZipCodes
        self.monthlyPayment = monthlyPayment
        self.maxStickers = maxStickers
        self.isLocationBased = isLocationBased
        self.isActive = isActive
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Sticker Size Enum
enum StickerSize: String, CaseIterable, Codable {
    case small = "small"
    case medium = "medium"
    case large = "large"
    case extraLarge = "extra_large"
    
    var displayName: String {
        switch self {
        case .small: return "Small (4\" x 4\")"
        case .medium: return "Medium (6\" x 6\")"
        case .large: return "Large (8\" x 8\")"
        case .extraLarge: return "Extra Large (12\" x 12\")"
        }
    }
    
    var price: Double {
        switch self {
        case .small: return 1.00
        case .medium: return 1.50
        case .large: return 2.00
        case .extraLarge: return 2.50
        }
    }
}

// MARK: - Application Model
struct Application: Codable, Identifiable {
    let id: String
    let driverId: String
    let campaignId: String
    let status: ApplicationStatus
    let appliedAt: Date
    let reviewedAt: Date?
    let approvedAt: Date?
    let driverAddress: String
    let bankAccountDetails: BankAccountDetails
    
    init(id: String, driverId: String, campaignId: String, status: ApplicationStatus, appliedAt: Date, reviewedAt: Date?, approvedAt: Date?, driverAddress: String, bankAccountDetails: BankAccountDetails) {
        self.id = id
        self.driverId = driverId
        self.campaignId = campaignId
        self.status = status
        self.appliedAt = appliedAt
        self.reviewedAt = reviewedAt
        self.approvedAt = approvedAt
        self.driverAddress = driverAddress
        self.bankAccountDetails = bankAccountDetails
    }
}

// MARK: - Application Status Enum
enum ApplicationStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    case completed = "completed"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending Review"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        case .completed: return "Completed"
        }
    }
    
    var color: String {
        switch self {
        case .pending: return "orange"
        case .approved: return "green"
        case .rejected: return "red"
        case .completed: return "blue"
        }
    }
}

// MARK: - Bank Account Details
struct BankAccountDetails: Codable {
    let accountNumber: String
    let routingNumber: String
    let accountHolderName: String
    let bankName: String
    
    init(accountNumber: String, routingNumber: String, accountHolderName: String, bankName: String) {
        self.accountNumber = accountNumber
        self.routingNumber = routingNumber
        self.accountHolderName = accountHolderName
        self.bankName = bankName
    }
}

// MARK: - Payment Model
struct Payment: Codable, Identifiable {
    let id: String
    let userId: String
    let amount: Double
    let type: PaymentType
    let status: PaymentStatus
    let description: String
    let createdAt: Date
    let processedAt: Date?
    
    init(id: String, userId: String, amount: Double, type: PaymentType, status: PaymentStatus, description: String, createdAt: Date, processedAt: Date?) {
        self.id = id
        self.userId = userId
        self.amount = amount
        self.type = type
        self.status = status
        self.description = description
        self.createdAt = createdAt
        self.processedAt = processedAt
    }
}

// MARK: - Payment Type Enum
enum PaymentType: String, CaseIterable, Codable {
    case monthlyFee = "monthly_fee"
    case stickerFee = "sticker_fee"
    case driverPayment = "driver_payment"
    case manufacturingFee = "manufacturing_fee"
    
    var displayName: String {
        switch self {
        case .monthlyFee: return "Monthly Platform Fee"
        case .stickerFee: return "Per-Sticker Fee"
        case .driverPayment: return "Driver Payment"
        case .manufacturingFee: return "Sticker Manufacturing"
        }
    }
}

// MARK: - Payment Status Enum
enum PaymentStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    case refunded = "refunded"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending"
        case .processing: return "Processing"
        case .completed: return "Completed"
        case .failed: return "Failed"
        case .refunded: return "Refunded"
        }
    }
}

// MARK: - Photo Verification Model
struct PhotoVerification: Codable, Identifiable {
    let id: String
    let driverId: String
    let campaignId: String
    let photoUrl: String
    let submittedAt: Date
    let verifiedAt: Date?
    let status: VerificationStatus
    
    init(id: String, driverId: String, campaignId: String, photoUrl: String, submittedAt: Date, verifiedAt: Date?, status: VerificationStatus) {
        self.id = id
        self.driverId = driverId
        self.campaignId = campaignId
        self.photoUrl = photoUrl
        self.submittedAt = submittedAt
        self.verifiedAt = verifiedAt
        self.status = status
    }
}

// MARK: - Verification Status Enum
enum VerificationStatus: String, CaseIterable, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    
    var displayName: String {
        switch self {
        case .pending: return "Pending Review"
        case .approved: return "Approved"
        case .rejected: return "Rejected"
        }
    }
}
