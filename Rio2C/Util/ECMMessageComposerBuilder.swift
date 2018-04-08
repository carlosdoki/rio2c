//
//  ECMMessageComposerBuilder.swift
//  Rio2C
//
//  Created by Carlos Doki on 08/04/18.
//  Copyright © 2018 Carlos Doki. All rights reserved.
//

import UIKit
import MessageUI

class ECMMessageComposerBuilder: NSObject {
    
    @objc private dynamic var customWindow: UIWindow?
    private var body: String?
    private var phoneNumber: String?
    fileprivate var messageController: MFMessageComposeViewController?
    
    var canCompose: Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func body(_ body: String?) -> ECMMessageComposerBuilder {
        self.body = body
        return self
    }
    
    func phoneNumber(_ phone: String?) -> ECMMessageComposerBuilder {
        self.phoneNumber = phone
        return self
    }
    
    func build() -> UIViewController? {
        guard canCompose else { return nil }
        
        messageController = MFMessageComposeViewController()
        messageController?.body = body
        if let phone = phoneNumber {
            messageController?.recipients = [phone]
        }
        messageController?.messageComposeDelegate = self
        
        return messageController
    }
    
    func show() {
        customWindow = UIWindow(frame: UIScreen.main.bounds)
        customWindow?.rootViewController = UIViewController()
        
        // Move it to the top
        let topWindow = UIApplication.shared.windows.last
        customWindow?.windowLevel = (topWindow?.windowLevel ?? 0) + 1
        
        // and present it
        customWindow?.makeKeyAndVisible()
        
        if let messageController = build() {
            customWindow?.rootViewController?.present(messageController, animated: true, completion: nil)
        }
    }
    
    func hide(animated: Bool = true) {
        messageController?.dismiss(animated: animated, completion: nil)
        messageController = nil
        customWindow?.isHidden = true
        customWindow = nil
    }
}

extension ECMMessageComposerBuilder: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        hide()
    }
}
