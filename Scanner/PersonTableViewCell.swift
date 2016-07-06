//
//  PersonTableViewCell.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/22/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {

    
    @IBOutlet weak var fullNameField: UILabel!
    @IBOutlet weak var emailField: UITextField!

    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
