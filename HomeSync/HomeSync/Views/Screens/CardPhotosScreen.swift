//
//  CardPhotosScreen.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import SwiftUI
import FirebaseFirestore

struct CardPhotosScreen: View {
    @Binding var segue: Segues
    @Binding var fidelityCard: FidelityCardItem
    @Binding var homeId: String
    @State var photosUploaded: Bool = false
    @State private var frontImage: UIImage? = nil
    @State private var backImage: UIImage? = nil
    @State private var isFrontPhoto = true
    @State private var currentPage = 0
    @State private var imagePickerSource: PhotoPicker.SourceType? = nil
    @State private var selectedPhotoTarget: PhotoTarget? = nil
    @State private var isUploadingFront = false
    @State private var isUploadingBack = false
    @State private var showDeleteAlert = false

    enum PhotoTarget {
        case front, back
    }
    
    var body: some View {
        VStack {
            TopHeaderView(screenTitle: .cardPhotos, icons: [], backAction: goBack)
            
            VStack {
                TabView(selection: $currentPage) {
                    CardPhotoUploadView(title: .addFrontPhoto, image: frontImage, onDelete: {
                        showDeleteAlert = true
                    }, isLoading: isUploadingFront)
                    .tag(0)
                    
                    CardPhotoUploadView(title: .addBackPhoto, image: backImage, onDelete: {
                        showDeleteAlert = true
                    }, isLoading: isUploadingBack)
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 550)
                .onChange(of: currentPage) { _, newValue in
                    isFrontPhoto = (newValue == 0)
                }
                
                GenericActionTile(iconName: "camera", title: .takePhoto) {
                    selectedPhotoTarget = currentPage == 0 ? .front : .back
                    imagePickerSource = .camera
                }
                
                Spacer()
                    .frame(height: 10)
                
                GenericActionTile(iconName: "photo", title: .chooseGallery) {
                    selectedPhotoTarget = currentPage == 0 ? .front : .back
                    imagePickerSource = .photoLibrary
                }
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
        .sheet(item: $imagePickerSource) { source in
            PhotoPicker(sourceType: source) { image in
                guard let target = selectedPhotoTarget else { return }

                let isFront = (target == .front)
                let path = "homes/\(homeId)/cards/\(fidelityCard.cardNumber)/\(isFront ? "front.jpg" : "back.jpg")"

                if isFront {
                    isUploadingFront = true
                } else {
                    isUploadingBack = true
                }

                UploadService.shared.uploadSinglePhoto(image: image, path: path) { result in
                    switch result {
                    case .success(let url):
                        loadImage(from: url) { loadedImage in
                            if isFront {
                               frontImage = loadedImage
                               isUploadingFront = false
                               updatePhotoURLsForCard(cardNumber: fidelityCard.cardNumber, isFront: true, url: url)
                           } else {
                               backImage = loadedImage
                               isUploadingBack = false
                               updatePhotoURLsForCard(cardNumber: fidelityCard.cardNumber, isFront: false, url: url)
                           }
                        }
                        
                    case .failure(let error):
                        print("Upload failed: \(error.localizedDescription)")
                        if isFront {
                            isUploadingFront = false
                        } else {
                            isUploadingBack = false
                        }
                    }
                }
                
                photosUploaded = frontImage != nil || backImage != nil
            }
        }
        .alert(String.deletePhoto, isPresented: $showDeleteAlert) {
            Button(String.deleteButton, role: .destructive) {
                deletePhotoFromStorage(isFront: isFrontPhoto)
                if isFrontPhoto {
                    self.frontImage = nil
                } else {
                    self.backImage = nil
                }
            }
            Button(String.cancelButton, role: .cancel) {}
        } message: {
            Text(String.deletePhotoQuestion)
        }
        .onAppear(perform: loadExistingPhotos)
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    private func loadExistingPhotos() {
        isUploadingFront = true
        isUploadingBack = true
        
        let docRef = Firestore.firestore().collection("homes").document(homeId)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Home document doesn't exist: \(error?.localizedDescription ?? "Unknown error")")
                isUploadingFront = false
                isUploadingBack = false
                return
            }
            
            let sharedPhotos = document.data()?["sharedPhotos"] as? [String: [String: String]] ?? [:]
            if let cardEntry = sharedPhotos[fidelityCard.cardNumber] {
                if let frontURLString = cardEntry["frontPhotoURL"], let url = URL(string: frontURLString) {
                    loadImage(from: url) { loadedImage in
                        self.frontImage = loadedImage
                        isUploadingFront = false
                   }
               } else {
                   self.frontImage = nil
                   isUploadingFront = false
               }
                
                if let backURLString = cardEntry["backPhotoURL"], let url = URL(string: backURLString) {
                    loadImage(from: url) { loadedImage in
                        self.backImage = loadedImage
                        isUploadingBack = false
                    }
                } else {
                    self.backImage = nil
                    isUploadingBack = false
                }
            } else {
                self.frontImage = nil
                self.backImage = nil
                isUploadingFront = false
                isUploadingBack = false
            }
        }
    }

    private func deletePhotoFromStorage(isFront: Bool) {
        let path = "homes/\(homeId)/cards/\(fidelityCard.cardNumber)/\(isFront ? "front.jpg" : "back.jpg")"
        
        UploadService.shared.deletePhoto(at: path) { error in
            if let error = error {
                print("Error deleting photo from storage: \(error.localizedDescription)")
            } else {
                print("Photo deleted successfully from storage.")
                
                updatePhotoURLsForCard(
                    cardNumber: fidelityCard.cardNumber,
                    isFront: isFront,
                    url: nil
                )
            }
        }
    }
    
    private func goBack() {
        segue = .fidelityCardSegue
    }
    
    private func updatePhotoURLsForCard(cardNumber: String, isFront: Bool, url: URL?) {
        let docRef = Firestore.firestore().collection("homes").document(homeId)

        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                print("Home document doesn't exist: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var sharedPhotos = document.data()?["sharedPhotos"] as? [String: [String: String]] ?? [:]
            var cardEntry = sharedPhotos[cardNumber] ?? [:]

            if isFront {
                if let newURL = url {
                    cardEntry["frontPhotoURL"] = newURL.absoluteString
                } else {
                    cardEntry.removeValue(forKey: "frontPhotoURL") // Remove if nil (deletion)
                }
            } else { // It's the back photo
                if let newURL = url {
                    cardEntry["backPhotoURL"] = newURL.absoluteString
                } else {
                    cardEntry.removeValue(forKey: "backPhotoURL") // Remove if nil (deletion)
                }
            }

            sharedPhotos[cardNumber] = cardEntry

            docRef.updateData(["sharedPhotos": sharedPhotos]) { err in
                if let err = err {
                    print("Failed to update sharedPhotos: \(err)")
                } else {
                    print("Successfully updated sharedPhotos for card \(cardNumber)")
                }
            }
        }
    }
}
