//
//  Extension + UIButton.swift
//  AliasLite
//
//  Created by Николай on 30.08.2022.
//

import UIKit

extension UIButton {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3
        self.layer.cornerRadius = 15
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.7
    }
}
