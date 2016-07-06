//
//  ItemTableViewCell.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/23/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var barcodeTextField: UILabel!
    @IBOutlet weak var assignedToTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
