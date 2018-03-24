//
//  FriendsTableViewCell.swift
//  vkPhoto
//
//  Created by Semyon on 23.03.2018.
//  Copyright © 2018 Semyon. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        styleSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImage.image = nil
    }
}

// MARK: - Setup
extension FriendsTableViewCell {
    
    func styleSetup() {
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
