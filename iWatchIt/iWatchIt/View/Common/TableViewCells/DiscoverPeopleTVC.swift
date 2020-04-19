//
//  DiscoverPeopleTVC.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 17/04/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//

import UIKit

class DiscoverPeopleTVC: UITableViewCell, Reusable {

    @IBOutlet weak var actorImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tintColor = .whiteOrBlack
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        actorImage.image = nil
        titleLbl.text = ""
        subtitleLbl.text = ""
        accessoryView = UIView()
    }
    
    func configureCell(people: People?) {
        guard let people = people else {return}
        
        if let imgPath = people.image, let image = ImageHelper.createImageURL(path: imgPath, size: .profile(size: .medium)) {
            actorImage.imageFrom(url: image)
            actorImage.roundCornersForAspectFit(radius: 6)
        } else {
            actorImage.image = kEmptyStateUserMale
        }
        
        titleLbl.text = people.name
        subtitleLbl.text = people.department
        
        titleLbl.textColor = .whiteOrBlack
        subtitleLbl.textColor = .whiteOrBlack
        
        let image = DiscoverQuery.shared.peopleIsInQuery(people: people) ? UIImage(systemName: "xmark") : UIImage(systemName: "plus")
        accessoryView = UIImageView(image: image)
    }
    
    func configureEmpty() {
        titleLbl.textColor = kColorEmptyStateLabel
        titleLbl.text = "Add people to discover their content"
        actorImage?.image = kEmptyStateUserMale
    }
    
    @IBAction func didTapRemove(_ sender: Any) {
        
    }
}
