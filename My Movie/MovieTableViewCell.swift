//
//  MovieTableViewCell.swift
//  My Movie
//
//  Created by Andi Setiyadi on 12/16/15.
//  Copyright © 2015 PFI. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieFormatLabel: UILabel!
    @IBOutlet weak var userRating: UserRating!
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
