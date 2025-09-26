import SwiftUI
import AVFoundation

struct CameraVerificationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingCamera = false
    @State private var capturedImage: UIImage?
    @State private var isSubmitting = false
    @State private var activeCampaigns: [Campaign] = []
    @State private var selectedCampaign: Campaign?
    @State private var showingImagePicker = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Monthly Verification")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Take a photo of your stickers to verify they're still displayed on your vehicle")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    
                    // Active Campaigns
                    if !activeCampaigns.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Active Campaigns")
                                .font(.headline)
                            
                            ForEach(activeCampaigns) { campaign in
                                CampaignVerificationCard(
                                    campaign: campaign,
                                    isSelected: selectedCampaign?.id == campaign.id
                                ) {
                                    selectedCampaign = campaign
                                }
                            }
                        }
                    }
                    
                    // Photo Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Verification Photo")
                            .font(.headline)
                        
                        if let image = capturedImage {
                            VStack(spacing: 12) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxHeight: 300)
                                    .cornerRadius(12)
                                
                                HStack(spacing: 12) {
                                    Button("Retake Photo") {
                                        showingCamera = true
                                    }
                                    .foregroundColor(.blue)
                                    
                                    Button("Choose from Library") {
                                        showingImagePicker = true
                                    }
                                    .foregroundColor(.green)
                                }
                            }
                        } else {
                            VStack(spacing: 16) {
                                Button(action: {
                                    showingCamera = true
                                }) {
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.blue)
                                        
                                        Text("Take Photo")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        
                                        Text("Capture your vehicle with stickers")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(40)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    HStack {
                                        Image(systemName: "photo.on.rectangle")
                                        Text("Choose from Library")
                                    }
                                    .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Photo Requirements")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            RequirementRow(icon: "checkmark.circle.fill", text: "Stickers must be clearly visible")
                            RequirementRow(icon: "checkmark.circle.fill", text: "Photo should show the entire vehicle")
                            RequirementRow(icon: "checkmark.circle.fill", text: "Good lighting and clear image")
                            RequirementRow(icon: "checkmark.circle.fill", text: "No obstructions blocking stickers")
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Submit Button
                    if capturedImage != nil {
                        Button(action: submitVerification) {
                            HStack {
                                if isSubmitting {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                Text(isSubmitting ? "Submitting..." : "Submit Verification")
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
                    
                    Spacer(minLength: 100)
                }
                .padding(20)
            }
            .navigationTitle("Photo Verification")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingCamera) {
            CameraView(capturedImage: $capturedImage)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $capturedImage)
        }
        .onAppear {
            loadActiveCampaigns()
        }
    }
    
    private var canSubmit: Bool {
        capturedImage != nil && selectedCampaign != nil
    }
    
    private func loadActiveCampaigns() {
        // Simulate loading active campaigns
        activeCampaigns = [
            Campaign(
                id: "1",
                advertiserId: "adv1",
                title: "Tech Startup - Mobile App",
                description: "Promote our new mobile app",
                stickerDesign: "",
                stickerSize: .medium,
                targetZipCodes: ["10001"],
                monthlyPayment: 35.0,
                maxStickers: 15,
                isLocationBased: true,
                isActive: true
            ),
            Campaign(
                id: "2",
                advertiserId: "adv2",
                title: "Local Restaurant",
                description: "Grand opening promotion",
                stickerDesign: "",
                stickerSize: .large,
                targetZipCodes: ["10001"],
                monthlyPayment: 25.0,
                maxStickers: 20,
                isLocationBased: true,
                isActive: true
            )
        ]
    }
    
    private func submitVerification() {
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isSubmitting = false
            dismiss()
        }
    }
}

struct CampaignVerificationCard: View {
    let campaign: Campaign
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(campaign.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("$\(String(format: "%.0f", campaign.monthlyPayment)) per month")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                        .font(.title2)
                }
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RequirementRow: View {
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

struct CameraView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.capturedImage = image
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraVerificationView()
}
