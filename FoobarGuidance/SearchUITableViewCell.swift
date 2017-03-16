//
//  SearchUITableViewCell.swift
//  FoobarGuidance
//
//  Created by Jakub Mazur on 15/03/2017.
//  Copyright © 2017 wingu AG. All rights reserved.
//

import UIKit

protocol CellDelegate {
    func cellAddButtonTapped()
}

class SearchUITableViewCell: UITableViewCell {
    
    
    var delegate : CellDelegate?
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        self.delegate?.cellAddButtonTapped()
        self.addButton.setTitle("✔️", for: .normal)
    }
}
