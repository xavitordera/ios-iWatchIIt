//
//  DiscoverSearchTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 13/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverSearchTVC: UITableViewCell, Reusable {
    
    // MARK: - Properties
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var removeBtn: UIButton!
    var keyword: Keyword?
    var genre: GenreRLM?
    var btnAdd: UIButton?
    
    // MARK: - UITVC
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.textColor = .whiteOrBlack
        self.tintColor = .whiteOrBlack
        btnAdd = accessoryButton()
        accessoryView = btnAdd
    }
    
    override func prepareForReuse() {
        keyword = nil
        genre = nil
        imageView?.image = nil
        accessoryView = UIView()
        textLabel?.text = nil
        imageView?.image = nil
    }
    
    // MARK: - Public interface
    func configureCell(keyword: Keyword?, genre: GenreRLM?) {
        self.keyword = keyword
        self.genre = genre
        textLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
        textLabel?.textColor = .whiteOrBlack
        self.textLabel?.text = keyword?.name ?? genre?.name
        self.accessoryType = .detailButton
        
        btnAdd = accessoryButton()
        accessoryView = btnAdd
        if let keyword = keyword {
            DiscoverQuery.shared.keywordIsInQuery(keyword: keyword) ? showRemove() : showAdd()
            self.imageView?.image = UIImage(systemName: "tag")
        } else if let genre = genre {
            DiscoverQuery.shared.genreIsInQuery(genre: genre) ? showRemove() : showAdd()
            self.imageView?.image = UIImage(systemName: "tv.circle")
        }
    }
    
    func configureEmpty(type: DiscoverType) {
        textLabel?.textColor = kColorEmptyStateLabel
        textLabel?.text = type == .Keywords ? "Add keywords to discover their content" : "Add genres to discover their content"
        textLabel?.font = .systemFont(ofSize: 15.0, weight: .light)
    }
    
    func configureEmpty(text: String) {
        textLabel?.textColor = kColorEmptyStateLabel
        textLabel?.text = text
        textLabel?.font = .systemFont(ofSize: 15.0, weight: .light)
        accessoryView = UIView()
    }
    
    private func accessoryButton() -> UIButton {
        let cellAudioButton = UIButton(type: .custom)
        cellAudioButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cellAudioButton.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
        cellAudioButton.contentMode = .scaleAspectFit
        cellAudioButton.tintColor = .whiteOrBlack
        return cellAudioButton
    }
    
    private func showAdd() {
        UIView.transition(with: btnAdd!, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.btnAdd?.setImage(UIImage(systemName: "plus"), for: .normal)
        }, completion: nil)
    }
    
    private func showRemove() {
        UIView.transition(with: btnAdd!, duration: 0.5, options: .transitionFlipFromTop, animations: {
            self.btnAdd?.setImage(UIImage(systemName: "xmark"), for: .normal)
        }, completion: nil)
    }
    
    @objc func accessoryButtonTapped(sender : AnyObject){
        if let keyword = keyword {
            DiscoverQuery.shared.addOrRemoveKeyword(keyword: keyword)
             DiscoverQuery.shared.keywordIsInQuery(keyword: keyword) ? showRemove() : showAdd()
        }
        
        if let genre = genre {
            DiscoverQuery.shared.addOrRemoveGenre(genre: genre)
            DiscoverQuery.shared.genreIsInQuery(genre: genre) ? showRemove() : showAdd()
        }
    }
}
