//
//  ViewController.swift
//  Facebook
//
//  Created by THAMMANOON WETHANYAPORN on 19/5/2564 BE.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit

class ViewController: UIViewController {
    
  @IBOutlet private weak var shareView: UIView!
  @IBOutlet private weak var loginView: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let loginButton = FBLoginButton()
    loginButton.permissions = ["public_profile", "email"]
    loginButton.delegate = self
    loginView.addSubview(loginButton)
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    loginButton.leftAnchor.constraint(equalTo: loginView.leftAnchor).isActive = true
    loginButton.topAnchor.constraint(equalTo: loginView.topAnchor).isActive = true
    loginButton.rightAnchor.constraint(equalTo: loginView.rightAnchor).isActive = true
    loginButton.bottomAnchor.constraint(equalTo: loginView.bottomAnchor).isActive = true
    
    let shareButton = FBShareButton()
    guard let url = URL(string: "https://www.google.com") else { return }
    let shareLinkContent = ShareLinkContent()
    shareLinkContent.contentURL = url
    shareButton.shareContent = shareLinkContent
    shareView.center = loginButton.center
    shareView.addSubview(shareButton)
    shareButton.translatesAutoresizingMaskIntoConstraints = false
    shareButton.leftAnchor.constraint(equalTo: shareView.leftAnchor).isActive = true
    shareButton.topAnchor.constraint(equalTo: shareView.topAnchor).isActive = true
    shareButton.rightAnchor.constraint(equalTo: shareView.rightAnchor).isActive = true
    shareButton.bottomAnchor.constraint(equalTo: shareView.bottomAnchor).isActive = true
    
    NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
    // Print out access token
      print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
    }
  }
    
  @IBAction func navigate(_ sender: Any) {
    let storyBoard: UIStoryboard = UIStoryboard(name: "FacebookProfile", bundle: nil)
    guard let newViewController = storyBoard.instantiateViewController(withIdentifier: "facebookProfile") as? FacebookProfileViewController else { return }
    navigationController?.pushViewController(newViewController, animated: true)
  }
}

extension ViewController: LoginButtonDelegate {
  func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
  }
    
  func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
  }
}
