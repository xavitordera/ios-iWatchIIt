//
//  SectionHeader.swift
//  iWatchIt
//
//  Created by Xavi Tordera on 29/03/2020.
//  Copyright © 2020 Xavi Tordera. All rights reserved.
//
import UIKit

protocol SectionHeaderDelegate {
    func didChangeSegment(index: Int)
}

class SectionHeader: UICollectionReusableView, NibReusable {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl! {
        didSet {
            segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .allEvents)
        }
    }
    
    var delegate: SectionHeaderDelegate?
    
    private var selectedSegment = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @objc func didChangeSegment() {
        if segmentedControl.selectedSegmentIndex != selectedSegment {
            selectedSegment = segmentedControl.selectedSegmentIndex
            delegate?.didChangeSegment(index: selectedSegment)
        }
    }
    
    func configureHeader(titles: [String]) {
        segmentedControl.removeAllSegments()
        for title in titles {
            segmentedControl.insertSegment(withTitle: title, at: titles.firstIndex(of: title) ?? 0, animated: true)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
}

