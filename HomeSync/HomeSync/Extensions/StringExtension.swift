//
//  StringExtension.swift
//  HomeSync
//
//  Created by Loredana Gostian on 18.05.2025.
//

import Foundation

extension String {
    var localized: String {
       NSLocalizedString(self, comment: "")
   }
}

extension String {
    // Login Screen
    static let signIn = "sign_in".localized
    static let enterEmail = "enter_email".localized
    static let enterPassword = "enter_password".localized
    static let forgotPassword = "forgot_password".localized
    static let notUserYet = "not_user_yet".localized

    // Register Screen
    static let signUp = "sign_up".localized
    static let confirmPassword = "confirm_password".localized
    static let alreadyUser = "already_user".localized
    
    // Complete Profile Screen
    static let completeProfile = "complete_profile".localized
    static let enterFirstName = "enter_first_name".localized
    static let enterLastName = "enter_last_name".localized
    static let finish = "finish".localized
    
    // Home Screen
    static let split = "split".localized
    static let home = "home".localized
    static let more = "more".localized
    static let addNewHome = "add_new_home".localized
    static let homeName = "home_name".localized
    static let continueButton = "continue_button".localized
    static let fidelityCards = "fidelity_cards".localized
    
    // Fidelity Cards
    static let scanBarcode = "scan_barcode".localized
    static let cardNumber = "card_number".localized
    static let storeName = "store_name".localized
    static let addNewFidelityCard = "add_new_fidelity_card".localized
    static let chooseCardColor = "choose_card_color".localized
    static let editCard = "edit_card".localized
    static let photos = "photos".localized
    static let saveButton = "save_button".localized
    static let cardPhotos = "card_photos".localized
    static let takePhoto = "take_photo".localized
    static let chooseGallery = "choose_gallery".localized
    static let addFrontPhoto = "add_front_photo".localized
    static let addBackPhoto = "add_back_photo".localized
    static let deleteButton = "delete_button".localized
    static let cancelButton = "cancel_button".localized
    static let deleteCard = "delete_card".localized
    static let deleteCardQuestion = "delete_card_question".localized
    static let deletePhoto = "delete_photo".localized
    static let deletePhotoQuestion = "delete_photo_question".localized
    
    // Error Messages
    static let emptyFields = "empty_fields".localized
    static let passwordsNotMatch = "passwords_not_match".localized
    static let unknownError = "unknown_error".localized
    static let emailBadlyFormatted = "email_badly_formatted".localized
    static let emailAlreadyRegistered = "email_already_registered".localized
    static let passwordAtLeast6Chars = "password_at_least_6_chars".localized
    static let networkError = "network_error".localized
}
