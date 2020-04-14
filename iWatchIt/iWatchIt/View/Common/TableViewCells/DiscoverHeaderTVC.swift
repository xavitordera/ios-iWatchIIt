//
//  DiscoverHeaderTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 13/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

enum DiscoverType {
    case Keywords
    case Genres
    case People
}

protocol DiscoverHeaderDelegate {
    func didExpand(type: DiscoverType)
    func didCollapse(type: DiscoverType)
}

class DiscoverHeaderTVC: UITableViewHeaderFooterView, Reusable {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var btnCollapse: UIButton!
    var isCollapsed = true
    var delegate: DiscoverHeaderDelegate?
    var type: DiscoverType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        delegate = nil
        type = nil
    }
    
    @IBAction func setCollapsed(_ sender: UIButton) {
        if isCollapsed {
            UIView.transition(with: sender, duration: 0.65, options: .transitionCrossDissolve, animations: {
                sender.setImage(kMinusCircle, for: .normal)
            }) { (success) in
                // TODO: Notifify delegate
                self.delegate?.didExpand(type: self.type!)
                self.isCollapsed = false
            }
        } else {
            UIView.transition(with: sender, duration: 0.65, options: .transitionCrossDissolve, animations: {
                sender.setImage(kPlusCircle, for: .normal)
            }) { (success) in
                // TODO: Notifify delegate
                self.delegate?.didCollapse(type: self.type!)
                self.isCollapsed = true
            }
        }
    }
    
    private func setupLayout() {
        titleLbl.font = .systemFont(ofSize: 21.0, weight: .bold)
        titleLbl.textColor = .whiteOrBlack
        btnCollapse.tintColor = .whiteOrBlack
    }
    
    func configureCell(title: String, delegate: DiscoverHeaderDelegate, type: DiscoverType) {
        titleLbl.text = title
        self.delegate = delegate
        self.type = type
    }
}
