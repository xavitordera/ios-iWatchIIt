//
//  SimpleTextCVX.swift
//  iWatchIt
//
//  Created by Xavier Tordera on 04/11/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class SimpleButtonCVC: UICollectionViewCell, NibLoadable, Reusable {
    @objc private var action: (() -> ())?
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupLayout()
    }
    
    func configureWith(text: String, action: @escaping () -> ()) {
        actionButton.setTitle(text, for: .normal)
        self.action = action
    }

    @IBAction func action(_ sender: Any) {
        action?()
    }
    
    private func setupLayout() {
        actionButton.backgroundColor = .clear
//        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.85)
    }
}
