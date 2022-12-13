//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import MessageUI
import SwiftUI


/// <#Description#>
public struct ContactOption {
    let id = UUID()
    /// <#Description#>
    public let image: Image
    /// <#Description#>
    public let title: String
    /// <#Description#>
    public let action: () -> Void
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - title: <#title description#>
    ///   - action: <#action description#>
    public init(image: Image, title: String, action: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.action = action
    }
}

extension ContactOption {
    private static var rootViewController: UIViewController? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController
    }
    
    
    /// <#Description#>
    /// - Parameter number: <#number description#>
    public static func call(_ number: String) -> ContactOption {
        ContactOption(
            image: Image(systemName: "phone.fill"),
            title: String(localized: "CONTACT_OPTION_CALL", bundle: .module)
        ) {
            guard let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) else {
                presentAlert(
                    title: String(localized: "CONTACT_OPTION_CALL", bundle: .module),
                    message: String(localized: "CONTACT_OPTION_CALL_MANUAL \(number)", bundle: .module)
                )
                return
            }
            UIApplication.shared.open(url)
        }
    }
    
    /// <#Description#>
    /// - Parameter number: <#number description#>
    public static func text(_ number: String) -> ContactOption {
        ContactOption(
            image: Image(systemName: "message.fill"),
            title: String(localized: "CONTACT_OPTION_TEXT", bundle: .module)
        ) {
            guard MFMessageComposeViewController.canSendText() else {
                presentAlert(
                    title: String(localized: "CONTACT_OPTION_TEXT", bundle: .module),
                    message: String(localized: "CONTACT_OPTION_TEXT_MANUAL \(number)", bundle: .module)
                )
                return
            }
            
            let controller = MFMessageComposeViewController()

            controller.recipients = [number]
            
            rootViewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - addresses: <#addresses description#>
    ///   - subject: <#subject description#>
    public static func email(addresses: [String], subject: String? = nil) -> ContactOption {
        ContactOption(
            image: Image(systemName: "envelope.fill"),
            title: String(localized: "CONTACT_OPTION_EMAIL", bundle: .module)
        ) {
            guard MFMailComposeViewController.canSendMail() else {
                presentAlert(
                    title: String(localized: "CONTACT_OPTION_EMAIL", bundle: .module),
                    message: String(localized: "CONTACT_OPTION_EMAIL_MANUAL \(addresses.joined(separator: ", "))", bundle: .module)
                )
                return
            }
            
            let controller = MFMailComposeViewController()
            controller.setToRecipients(addresses)
            if let subject {
                controller.setSubject(subject)
            }
            
            rootViewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    private static func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: String(localized: "CONTACT_MANUAL_DISMISS", bundle: .module), style: .default))
        rootViewController?.present(alert, animated: true, completion: nil)
    }
}
