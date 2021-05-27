//
//  FacebookProfile.swift
//  Facebook
//
//  Created by THAMMANOON WETHANYAPORN on 20/5/2564 BE.
//

import UIKit

class FacebookProfileViewController: UIViewController {
  
  @IBOutlet private weak var nameLabel: UILabel!
  @IBOutlet private weak var emailLabel: UILabel!
  @IBOutlet private weak var idLabel: UILabel!
  @IBOutlet private weak var facebookButton: UIButton!
    
  var manager = FacebookManager.share

  override func viewDidLoad() {
    super.viewDidLoad()
    updateProfile()
    manager.delegate = self
    let login = UIImage(named: "fb_login")
    facebookButton.setImage(login, for: .normal)
    let logout = UIImage(named: "fb_logout")
    facebookButton.setImage(logout, for: .selected)
  }
    
  func updateProfile() {
    if FacebookManager.isLogined() {
      facebookButton.isSelected = true
    } else {
      facebookButton.isSelected = false
    }
    guard let profile = FacebookManager.getProfile() else {
      idLabel.text = "Null"
      nameLabel.text = "Null"
      return
    }
    idLabel.text = profile.userID
    emailLabel.text = profile.email
    nameLabel.text = profile.name ?? "Null"
  }
    
  @IBAction func loginButtonTapped(_ sender: Any) {
    FacebookManager.login(viewController: self) {
      self.updateProfile()
    }
  }
    
  @IBAction func shareContentTapped(_ sender: Any) {
    let text = "https://static.robinhood.in.th/share_link.html?utm_source=consumerapp&utm_medium=sharefavshopbutton&utm_campaign=sharefavshop&utm_content=992974&URI=robinhoodth://merchantlanding/id/992974"
    FacebookManager.share.getLinkSharingContent(url: text)
  }
    
  @IBAction func shareImageTapped(_ sender: Any) {
    guard let login = UIImage(named: "fb_login"), let logout = UIImage(named: "fb_logout") else { return }
    let image = [login, logout]
    FacebookManager.share.getPhotoSharingContent(photos: image)
  }
    
  @IBAction func shareStoryTapped(_ sender: Any) {
    FacebookManager.share.shareBackgroundImageStory()
  }
}

extension FacebookProfileViewController: FacebookManagerDelegate {
  func shareCallBack() {
  }
}
