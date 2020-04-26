//
//  DiscoverPeopleTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 17/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverPeopleTVC: UITableViewCell, Reusable {
    
//    @IBOutlet weak var actorImage: UIImageView!
//    @IBOutlet weak var titleLbl: UILabel!
//    @IBOutlet weak var subtitleLbl: UILabel!
    
    var people: TypedSearchResult?
//    var btnAdd: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tintColor = .whiteOrBlack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    func configureCell(people: TypedSearchResult?) {
        self.people = people
        
        guard let people = people else {return}
        
//        if let imgPath = people.image, let image = ImageHelper.createImageURL(path: imgPath, size: .profile(size: .medium)) {
//            actorImage.imageFrom(url: image)
//            actorImage.roundCornersForAspectFit(radius: 6)
//        } else {
//            actorImage.image = kEmptyStateUserMale
//        }
        
        textLabel?.text = people.name
        detailTextLabel?.text = people.department ?? "" + "in People"
//
        textLabel?.textColor = .whiteOrBlack
        detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.6)
        
        imageView?.image = UIImage(systemName: "person.crop.circle")
//        btnAdd = accessoryButton()
//        accessoryView = btnAdd
//        DiscoverQuery.shared.peopleIsInQuery(people: people) ? showRemove() : showAdd()
//        btnAdd?.tintColor = .whiteOrBlack
    }
    
//    func configureEmpty() {
//        textLabel?.textColor = kColorEmptyStateLabel
//        textLabel?.text = "Add people to discover their content"
//        actorImage?.image = kEmptyStateUserMale
//    }
    
//    func configureEmpty(text: String) {
//        textLabel?.textColor = kColorEmptyStateLabel
//        textLabel?.text = text
//        imageView?.image = kEmptyStateUserMale
//        detailTextLabel?.text = text
//        accessoryView = UIView()
//    }
    
//    private func accessoryButton() -> UIButton {
//        let cellAudioButton = UIButton(type: .custom)
//        cellAudioButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        cellAudioButton.addTarget(self, action: #selector(accessoryButtonTapped(sender:)), for: .touchUpInside)
//        cellAudioButton.contentMode = .scaleAspectFit
//        cellAudioButton.tintColor = .whiteOrBlack
//        return cellAudioButton
//    }
//
//    private func showAdd() {
//        UIView.transition(with: btnAdd!, duration: 0.5, options: .transitionFlipFromBottom, animations: {
//            self.btnAdd?.setImage(UIImage(systemName: "plus"), for: .normal)
//        }, completion: nil)
//    }
//
//    private func showRemove() {
//        UIView.transition(with: btnAdd!, duration: 0.5, options: .transitionFlipFromTop, animations: {
//            self.btnAdd?.setImage(UIImage(systemName: "xmark"), for: .normal)
//        }, completion: nil)
//    }
//
//    @objc func accessoryButtonTapped(sender : AnyObject){
//        if let people = people {
//            DiscoverQuery.shared.addOrRemovePeople(people: people)
//            DiscoverQuery.shared.peopleIsInQuery(people: people) ? showRemove() : showAdd()
//        }
//    }
}
