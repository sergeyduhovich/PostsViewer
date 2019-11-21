//
//  UIViewController+Alert.swift
//  PostsViewer
//
//  Created by Siarhei Dukhovich on 11/22/19.
//  Copyright © 2019 Siarhei Dukhovich. All rights reserved.
//

import UIKit

extension UIViewController {
  func showAlert(message: String,
                 okAction: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: okAction)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
  }
}
