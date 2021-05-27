//
//  FacebookManager.swift
//  Facebook
//
//  Created by THAMMANOON WETHANYAPORN on 20/5/2564 BE.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

protocol FacebookManagerDelegate: class {
  func shareCallBack()
}

final class FacebookManager: NSObject {
  static let share = FacebookManager()
  static let loginManager = LoginManager()
  weak var delegate: FacebookManagerDelegate?
  static func setupFacebook(application: UIApplication,
                            launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  static func openUrl(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ApplicationDelegate.shared.application(app, open: url, options: options)
  }
    
  static func login(viewController: UIViewController?, completion: @escaping () -> Void) {
    if isLogined() {
      loginManager.logOut()
      completion()
    } else {
      loginManager.logIn(permissions: [.publicProfile, .email], viewController: viewController) { result in
        switch result {
        case .success(granted: let granted, declined: let declined, token: let token):
          print("===\(granted)")
          print("===\(declined)")
          print("===\(token as Any)")
          completion()
        case .cancelled: 
          completion()
        case .failed(_):
          completion()
        }
      }
    }
  }
    
  static func getProfile() -> Profile? {
    return Profile.current
  }
    
  static var token: String? {
    return AccessToken.current?.tokenString
  }
    
  static func isLogined() -> Bool {
    guard let token = AccessToken.current else { return false }
    return !token.isExpired
  }
    
  func shareBackgroundImageStory() {
    guard let image = UIImage(named: "fb_logout") else { return }
    if let pngImage = image.pngData() {
      backgroundImage(pngImage, appId: "480426483266855")
    }
  }

  private func backgroundImage(_ backgroundImage: Data, appId: String) {
    // Verify app can open custom URL scheme, open if able
    guard let urlScheme = URL(string: "facebook-stories://share"),
      UIApplication.shared.canOpenURL(urlScheme) else {
        // Handle older app versions or app not installed case
        return
      }
    let pasteboardItems = [["com.facebook.sharedSticker.backgroundImage": backgroundImage,
                            "com.facebook.sharedSticker.appID": appId]]
    let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
    // This call is iOS 10+, can use 'setItems' depending on what versions you support
    UIPasteboard.general.setItems(pasteboardItems, options: pasteboardOptions)
    UIApplication.shared.open(urlScheme)
  }
    
  func getPhotoSharingContent(photos: [UIImage]) {
    // Create `SharePhoto` object
    let contentPhoto: [SharePhoto] = photos.map {
      return SharePhoto(image: $0, userGenerated: true)
    }
    
    // Add data to `SharePhotoContent`
    let photoContent = SharePhotoContent()
    photoContent.photos = contentPhoto
    // Optional:
    photoContent.hashtag = Hashtag("#rbhHashTag")
    showDialog(content: photoContent)
  }
    
  func getLinkSharingContent(url: String) {
    let shareLinkContent = ShareLinkContent()
    guard let url = URL(string: url) else { return }
    shareLinkContent.contentURL = url
    // Optional:
    shareLinkContent.hashtag = Hashtag("#rbhHashTag")
    shareLinkContent.quote = "rbhQuote"
    showDialog(content: shareLinkContent)
  }
    
  private func showDialog(content: SharingContent, mode: ShareDialog.Mode = .feedWeb) {
    let dialog = ShareDialog()
    let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
    if var topController = keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      dialog.delegate = self
      dialog.shareContent = content
      dialog.mode = mode
      dialog.fromViewController = topController
    }
    dialog.show()
  }
}

extension FacebookManager: SharingDelegate {
  func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
    print("didCompleteWithResults")
    delegate?.shareCallBack()
  }

  func sharer(_ sharer: Sharing, didFailWithError error: Error) {
    print("didFailWithError: \(error.localizedDescription)")
    delegate?.shareCallBack()
  }

  func sharerDidCancel(_ sharer: Sharing) {
    print("sharerDidCancel")
    delegate?.shareCallBack()
  }
}
