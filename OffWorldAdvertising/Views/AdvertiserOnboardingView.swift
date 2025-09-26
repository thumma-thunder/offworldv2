import SwiftUI

struct AdvertiserOnboardingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var isLocationBased = false
    @State private var selectedZipCodes: [String] = []
    @State private var newZipCode = ""
    @State private var provideStickersYourself = false
    @State private var stickerDesign = ""
    @State private var selectedStickerSize: StickerSize = .medium
    @State private var campaignTitle = ""
    @State private var campaignDescription = ""
    @State private var monthlyPayment = 25.0
    @State private var maxStickers = 10
    @State private var showingImagePicker = false
    @State private var selectedImage: UIImage?
    
    private let totalSteps = 4
    
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
                    // Step 1: Location Selection
                    locationSelectionStep
                        .tag(0)
                    
                    // Step 2: Sticker Options
                    stickerOptionsStep
                        .tag(1)
                    
                    // Step 3: Campaign Details
                    campaignDetailsStep
                        .tag(2)
                    
                    // Step 4: Pricing & Review
                    pricingReviewStep
                        .tag(3)
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
                    
                    Button(currentStep == totalSteps - 1 ? "Create Campaign" : "Next") {
                        if currentStep == totalSteps - 1 {
                            createCampaign()
                        } else {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(canProceed ? Color.blue : Color.gray)
                    .cornerRadius(8)
                    .disabled(!canProceed)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Create Campaign")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
    
    // MARK: - Step 1: Location Selection
    private var locationSelectionStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Location Targeting")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Choose whether you want to target specific areas or make your campaign available everywhere")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    // Location-based toggle
                    VStack(spacing: 16) {
                        Toggle("Location-based Campaign", isOn: $isLocationBased)
                            .font(.headline)
                        
                        if isLocationBased {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Add target zip codes:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                HStack {
                                    TextField("Enter zip code", text: $newZipCode)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .keyboardType(.numberPad)
                                    
                                    Button("Add") {
                                        if !newZipCode.isEmpty && !selectedZipCodes.contains(newZipCode) {
                                            selectedZipCodes.append(newZipCode)
                                            newZipCode = ""
                                        }
                                    }
                                    .disabled(newZipCode.isEmpty)
                                }
                                
                                if !selectedZipCodes.isEmpty {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Selected zip codes:")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        
                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                            ForEach(selectedZipCodes, id: \.self) { zipCode in
                                                HStack {
                                                    Text(zipCode)
                                                        .font(.caption)
                                                    Button(action: {
                                                        selectedZipCodes.removeAll { $0 == zipCode }
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
    
    // MARK: - Step 2: Sticker Options
    private var stickerOptionsStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "square.and.arrow.down.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Sticker Options")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Choose how you want to handle sticker production and delivery")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    // Sticker production toggle
                    VStack(spacing: 16) {
                        Toggle("Provide stickers yourself", isOn: $provideStickersYourself)
                            .font(.headline)
                        
                        if provideStickersYourself {
                            Text("You will be responsible for producing and shipping stickers to drivers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            Text("We will handle sticker production and shipping for you")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Sticker design upload
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sticker Design")
                            .font(.headline)
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxHeight: 200)
                                .cornerRadius(8)
                        } else {
                            Button(action: {
                                showingImagePicker = true
                            }) {
                                VStack {
                                    Image(systemName: "photo.badge.plus")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                    Text("Upload Design")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(40)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Sticker size selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sticker Size")
                            .font(.headline)
                        
                        Picker("Sticker Size", selection: $selectedStickerSize) {
                            ForEach(StickerSize.allCases, id: \.self) { size in
                                Text(size.displayName).tag(size)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(20)
        }
    }
    
    // MARK: - Step 3: Campaign Details
    private var campaignDetailsStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "megaphone.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Campaign Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Provide information about your advertising campaign")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Campaign Title")
                            .font(.headline)
                        TextField("Enter campaign title", text: $campaignTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Campaign Description")
                            .font(.headline)
                        TextField("Describe your campaign", text: $campaignDescription, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monthly Payment per Driver")
                            .font(.headline)
                        HStack {
                            Text("$")
                                .foregroundColor(.secondary)
                            TextField("25.00", value: $monthlyPayment, format: .currency(code: "USD"))
                                .keyboardType(.decimalPad)
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Maximum Stickers")
                            .font(.headline)
                        TextField("10", value: $maxStickers, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding(20)
            }
        }
    }
    
    // MARK: - Step 4: Pricing & Review
    private var pricingReviewStep: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Pricing Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Review your campaign details and pricing")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 20) {
                    // Campaign Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Campaign Summary")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Title:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(campaignTitle.isEmpty ? "Not set" : campaignTitle)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Location:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(isLocationBased ? "\(selectedZipCodes.count) zip codes" : "All areas")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Sticker Size:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(selectedStickerSize.displayName)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Max Stickers:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\(maxStickers)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Pricing Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pricing Breakdown")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Monthly Platform Fee:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("$10.00")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Per-Sticker Fee (\(maxStickers) stickers):")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("$\(String(format: "%.2f", selectedStickerSize.price * Double(maxStickers)))")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Driver Payments (\(maxStickers) drivers):")
                                    .fontWeight(.medium)
                                Spacer()
                                Text("$\(String(format: "%.2f", monthlyPayment * Double(maxStickers)))")
                                    .foregroundColor(.secondary)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total Monthly Cost:")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("$\(String(format: "%.2f", 10.00 + (selectedStickerSize.price * Double(maxStickers)) + (monthlyPayment * Double(maxStickers))))")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
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
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !isLocationBased || !selectedZipCodes.isEmpty
        case 1:
            return selectedImage != nil
        case 2:
            return !campaignTitle.isEmpty && !campaignDescription.isEmpty && monthlyPayment > 0 && maxStickers > 0
        case 3:
            return true
        default:
            return false
        }
    }
    
    private func createCampaign() {
        // Create campaign logic here
        print("Creating campaign with title: \(campaignTitle)")
        dismiss()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    AdvertiserOnboardingView()
}
