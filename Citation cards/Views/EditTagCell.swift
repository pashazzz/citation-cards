//
//  EditTagCell.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 10.1.2024.
//

import UIKit

protocol EditTagCellDelegate {
    func didTapButtonToggleTag(with tagName: String, isIncluded: Bool)
}

class EditTagCell: UITableViewCell {
    var delegate: EditTagCellDelegate?
    
    @IBOutlet var isIncluded: UIButton!
    @IBOutlet var tagName: UILabel!
    @IBOutlet var tagCount: UILabel!
    
    @IBAction func didTapButtonToggleTag() {
        let includedImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        let isTagIncluded: Bool = isIncluded.currentImage == includedImage
        delegate?.didTapButtonToggleTag(with: tagName.text ?? "", isIncluded: isTagIncluded)
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
