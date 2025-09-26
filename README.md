# OffWorld Advertising iOS App

A comprehensive iOS application built with SwiftUI that connects advertisers with drivers for car sticker advertising campaigns.

## Features

### For Advertisers
- **Campaign Creation**: Design and launch sticker advertising campaigns
- **Location Targeting**: Target specific zip codes or make campaigns available everywhere
- **Sticker Management**: Choose to provide stickers yourself or have them manufactured
- **Pricing Control**: Set monthly payments per driver and maximum sticker limits
- **Analytics Dashboard**: Track campaign performance and driver reach
- **Payment Management**: Handle monthly fees and per-sticker costs

### For Drivers
- **Campaign Discovery**: Browse available advertising opportunities in their area
- **Application System**: Apply for campaigns with bank account details
- **Photo Verification**: Monthly photo submissions to verify sticker display
- **Earnings Tracking**: Monitor payments and earnings from active campaigns
- **Location-Based Matching**: See campaigns relevant to their driving areas

## Technical Architecture

### Frontend (iOS)
- **SwiftUI**: Modern declarative UI framework
- **Navigation**: Tab-based navigation with modal presentations
- **Camera Integration**: Photo capture for verification
- **Location Services**: Zip code-based campaign matching
- **Secure Storage**: Bank account and payment information

### Backend (Planned)
- **Node.js/Express**: RESTful API server
- **Database**: Secure storage for user data and payments
- **Payment Processing**: Third-party payment integration
- **Image Storage**: Campaign designs and verification photos

## Project Structure

```
OffWorldAdvertising/
├── OffWorldAdvertisingApp.swift          # Main app entry point
├── ContentView.swift                     # Root view with authentication logic
├── Models/
│   └── Models.swift                      # Data models and enums
├── Views/
│   ├── WelcomeView.swift                 # Landing page with user type selection
│   ├── AuthView.swift                    # Sign in/sign up interface
│   ├── AdvertiserDashboardView.swift     # Advertiser main dashboard
│   ├── DriverDashboardView.swift        # Driver main dashboard
│   ├── AdvertiserOnboardingView.swift   # Campaign creation flow
│   ├── DriverOnboardingView.swift       # Driver setup flow
│   ├── AvailableAdsView.swift           # Campaign browsing for drivers
│   ├── CameraVerificationView.swift     # Photo verification system
│   └── PaymentView.swift                # Payment management
└── Managers/
    ├── AuthManager.swift                # Authentication state management
    └── NetworkManager.swift             # API communication
```

## Key Features Implementation

### Authentication System
- User type selection (Advertiser/Driver)
- Secure sign-in and sign-up flows
- Persistent authentication state

### Campaign Management
- Multi-step campaign creation wizard
- Location targeting with zip code selection
- Sticker design upload and size selection
- Pricing calculation and review

### Driver Experience
- Zip code-based campaign discovery
- Application system with bank details
- Monthly photo verification requirements
- Earnings tracking and payment history

### Payment Integration
- Monthly platform fees ($10)
- Per-sticker manufacturing fees ($1-2.50)
- Driver payment processing
- Payment method management

## Development Setup

### Requirements
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Clone the repository
2. Open `OffWorldAdvertising.xcodeproj` in Xcode
3. Build and run on iOS Simulator or device

### Dependencies
- SwiftUI (built-in)
- AVFoundation (camera functionality)
- Core Location (location services)

## Future Enhancements

### Backend Development
- [ ] Node.js/Express API server
- [ ] Database integration (PostgreSQL/MongoDB)
- [ ] Payment processing (Stripe/PayPal)
- [ ] Image storage (AWS S3/Cloudinary)

### Additional Features
- [ ] Push notifications for new campaigns
- [ ] Advanced analytics and reporting
- [ ] Social features and driver communities
- [ ] Automated sticker manufacturing integration
- [ ] Real-time campaign performance tracking

## Business Model

### Revenue Streams
1. **Monthly Platform Fee**: $10 per advertiser
2. **Per-Sticker Fee**: $1-2.50 per sticker per month
3. **Manufacturing Fees**: Additional fees for sticker production
4. **Transaction Fees**: Small percentage of driver payments

### Cost Structure
- Platform maintenance and development
- Sticker manufacturing and shipping
- Payment processing fees
- Customer support and verification

## Security Considerations

- Bank account information encryption
- Secure photo verification system
- User authentication and authorization
- Payment data protection
- Location data privacy

## Contributing

This is a private project for OffWorld Advertising. For development questions or contributions, contact the development team.

## License

Proprietary - All rights reserved by OffWorld Advertising.