//
//  TagCell.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 9.1.2024.
//

import UIKit

class TagCell: UITableViewCell {
    @IBOutlet var tagName: UILabel!
    @IBOutlet var tagCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
