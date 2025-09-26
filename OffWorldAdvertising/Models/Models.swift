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
    
    // Custom Codable implementation to handle Date encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, email, userType, companyName, fullName, isOnboarded, createdAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        userType = try container.decode(UserType.self, forKey: .userType)
        companyName = try container.decodeIfPresent(String.self, forKey: .companyName)
        fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
        isOnboarded = try container.decode(Bool.self, forKey: .isOnboarded)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(userType, forKey: .userType)
        try container.encodeIfPresent(companyName, forKey: .companyName)
        try container.encodeIfPresent(fullName, forKey: .fullName)
        try container.encode(isOnboarded, forKey: .isOnboarded)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
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
    
    // Custom Codable implementation to handle Date encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, advertiserId, title, description, stickerDesign, stickerSize, targetZipCodes, monthlyPayment, maxStickers, isLocationBased, isActive, createdAt, updatedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        advertiserId = try container.decode(String.self, forKey: .advertiserId)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        stickerDesign = try container.decode(String.self, forKey: .stickerDesign)
        stickerSize = try container.decode(StickerSize.self, forKey: .stickerSize)
        targetZipCodes = try container.decode([String].self, forKey: .targetZipCodes)
        monthlyPayment = try container.decode(Double.self, forKey: .monthlyPayment)
        maxStickers = try container.decode(Int.self, forKey: .maxStickers)
        isLocationBased = try container.decode(Bool.self, forKey: .isLocationBased)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(advertiserId, forKey: .advertiserId)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(stickerDesign, forKey: .stickerDesign)
        try container.encode(stickerSize, forKey: .stickerSize)
        try container.encode(targetZipCodes, forKey: .targetZipCodes)
        try container.encode(monthlyPayment, forKey: .monthlyPayment)
        try container.encode(maxStickers, forKey: .maxStickers)
        try container.encode(isLocationBased, forKey: .isLocationBased)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
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
    
    // Custom Codable implementation to handle Date encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, driverId, campaignId, status, appliedAt, reviewedAt, approvedAt, driverAddress, bankAccountDetails
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        driverId = try container.decode(String.self, forKey: .driverId)
        campaignId = try container.decode(String.self, forKey: .campaignId)
        status = try container.decode(ApplicationStatus.self, forKey: .status)
        appliedAt = try container.decode(Date.self, forKey: .appliedAt)
        reviewedAt = try container.decodeIfPresent(Date.self, forKey: .reviewedAt)
        approvedAt = try container.decodeIfPresent(Date.self, forKey: .approvedAt)
        driverAddress = try container.decode(String.self, forKey: .driverAddress)
        bankAccountDetails = try container.decode(BankAccountDetails.self, forKey: .bankAccountDetails)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(driverId, forKey: .driverId)
        try container.encode(campaignId, forKey: .campaignId)
        try container.encode(status, forKey: .status)
        try container.encode(appliedAt, forKey: .appliedAt)
        try container.encodeIfPresent(reviewedAt, forKey: .reviewedAt)
        try container.encodeIfPresent(approvedAt, forKey: .approvedAt)
        try container.encode(driverAddress, forKey: .driverAddress)
        try container.encode(bankAccountDetails, forKey: .bankAccountDetails)
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
    
    // Custom Codable implementation to handle Date encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, userId, amount, type, status, description, createdAt, processedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        amount = try container.decode(Double.self, forKey: .amount)
        type = try container.decode(PaymentType.self, forKey: .type)
        status = try container.decode(PaymentStatus.self, forKey: .status)
        description = try container.decode(String.self, forKey: .description)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        processedAt = try container.decodeIfPresent(Date.self, forKey: .processedAt)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(amount, forKey: .amount)
        try container.encode(type, forKey: .type)
        try container.encode(status, forKey: .status)
        try container.encode(description, forKey: .description)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(processedAt, forKey: .processedAt)
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
    
    // Custom Codable implementation to handle Date encoding/decoding
    enum CodingKeys: String, CodingKey {
        case id, driverId, campaignId, photoUrl, submittedAt, verifiedAt, status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        driverId = try container.decode(String.self, forKey: .driverId)
        campaignId = try container.decode(String.self, forKey: .campaignId)
        photoUrl = try container.decode(String.self, forKey: .photoUrl)
        submittedAt = try container.decode(Date.self, forKey: .submittedAt)
        verifiedAt = try container.decodeIfPresent(Date.self, forKey: .verifiedAt)
        status = try container.decode(VerificationStatus.self, forKey: .status)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(driverId, forKey: .driverId)
        try container.encode(campaignId, forKey: .campaignId)
        try container.encode(photoUrl, forKey: .photoUrl)
        try container.encode(submittedAt, forKey: .submittedAt)
        try container.encodeIfPresent(verifiedAt, forKey: .verifiedAt)
        try container.encode(status, forKey: .status)
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
