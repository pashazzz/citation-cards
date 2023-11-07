//
//  CitationCell.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

class CitationCell: UITableViewCell {
    @IBOutlet var caption: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var source: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var isFavourite: UIButton!
    
    var toggleIsFavourite: (() -> Void)!
    
    @IBAction func tapOnFavourite() -> Void {
        toggleIsFavourite()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
