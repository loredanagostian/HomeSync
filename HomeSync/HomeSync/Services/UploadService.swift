//
//  UploadService.swift
//  HomeSync
//
//  Created by Loredana Gostian on 31.05.2025.
//

import FirebaseStorage
import FirebaseFirestore

class UploadService {
    static let shared = UploadService()
    private let storage = Storage.storage()

    func uploadSinglePhoto(image: UIImage, path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "photo.encode", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not encode image."])))
            return
        }

        let ref = storage.reference().child(path)
        ref.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url))
                }
            }
        }
    }
    
    func deletePhoto(at path: String, completion: @escaping (Error?) -> Void) {
        let storageRef = Storage.storage().reference().child(path)

        storageRef.delete { error in
            if let error = error {
                print("Firebase Storage: Failed to delete photo at path \(path): \(error.localizedDescription)")
                completion(error)
            } else {
                print("Firebase Storage: Photo successfully deleted at path: \(path)")
                completion(nil)
            }
        }
    }
}
