//
//  KeywordCell.swift
//  DreamWell
//
//  Created by Rohin Bhushan on 4/1/17.
//  Copyright © 2017 rohin. All rights reserved.
//

import UIKit

class KeywordCell: UITableViewCell {
	@IBOutlet weak var firstLabel: UILabel!
	@IBOutlet weak var secondLabel: UILabel!
	@IBOutlet weak var firstHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.layer.cornerRadius = 10.0
		self.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
