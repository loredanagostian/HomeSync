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
    static let editHome = "edit_home".localized
    static let homeName = "home_name".localized
    static let continueButton = "continue_button".localized
    static let fidelityCards = "fidelity_cards".localized
    static let settlement = "settlement".localized
    static let youOwned = "you_owned".localized
    static let youOwn = "you_own".localized
    static let viewDetails = "view_details".localized
    static let settleUp = "settle_up".localized
    
    // Edit Home Screen
    static let editHomeName = "edit_home_name".localized
    static let editHomeNameSuccess = "edit_home_name_success".localized
    static let editHomeNameError = "edit_home_name_error".localized
    static let manageMembers = "manage_members".localized
    static let homeMembers = "home_members".localized
    static let addHomeMember = "add_home_member".localized
    static let removeMember = "remove_member".localized
    static let removeMemberQuestion = "remove_member_question".localized
    static let removeMemberError = "remove_member_error".localized
    static let deleteHome = "delete_home".localized
    static let deleteHomeQuestion = "delete_home_question".localized
    static let deleteHomeError = "delete_home_error".localized
    
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
    
    // More
    static let profile = "profile".localized
    static let saveChanges = "save_changes".localized
    static let logout = "logout".localized
    static let logoutQuestion = "logout_question".localized
    
    // Split
    static let yourBalance = "your_balance".localized
    static let youGetBack = "you_get_back".localized
    static let youOwe = "you_owe".localized
    static let recentExpenses = "recent_expenses".localized
    static let markAsPaid = "mark_as_paid".localized
    static let addExpense = "add_expense".localized
    static let expenseDetails = "expense_details".localized
    static let expenseName = "expense_name".localized
    static let totalPrice = "total_price".localized
    
    // Error Messages
    static let emptyFields = "empty_fields".localized
    static let passwordsNotMatch = "passwords_not_match".localized
    static let unknownError = "unknown_error".localized
    static let emailBadlyFormatted = "email_badly_formatted".localized
    static let emailAlreadyRegistered = "email_already_registered".localized
    static let passwordAtLeast6Chars = "password_at_least_6_chars".localized
    static let networkError = "network_error".localized
}
