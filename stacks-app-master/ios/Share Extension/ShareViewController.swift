//
//  ShareViewController.swift
//  Share Extension
//
//  Created by Denis Costa on 31/12/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    let hostAppBundleIdentifier = "com.tanay.stacks"
    let sharedKey = "ShareKey"
    var sharedText: [String] = []
    let urlContentType = kUTTypeURL as String

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func viewDidLoad() {
        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            if let contents = content.attachments {
                for (index, attachment) in (contents as! [NSItemProvider]).enumerated() {
                    if attachment.hasItemConformingToTypeIdentifier(urlContentType) {
                    handleUrl(content: content, attachment: attachment, index: index)
                    }
                }
            }
        }
    }

    override func didSelectPost() {
        print("didSelectPost");
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func handleUrl (content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: urlContentType, options: nil) { [weak self] data, error in
            
            if error == nil, let item = data as? URL, let this = self {
                
                this.sharedText.append(item.absoluteString)
                
                // If this is the last item, save imagesData in userDefaults and redirect to host app
                if index == (content.attachments?.count)! - 1 {
                    let userDefaults = UserDefaults(suiteName: "group.\(this.hostAppBundleIdentifier)")
                    userDefaults?.set(this.sharedText, forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    this.redirectToHostApp(type: .text)
                }
                
            } else {
                self?.dismiss(animated: true, completion: {
                    print("Error");
                })
            }
        }
    }
    
    private func redirectToHostApp(type: RedirectType) {
        let url = URL(string: "SharePhotos://dataUrl=\(sharedKey)#\(type)")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    enum RedirectType {
        case media
        case text
    }
}
