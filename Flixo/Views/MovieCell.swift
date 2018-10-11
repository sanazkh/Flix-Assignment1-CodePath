//
//  CustomCell.swift
//  Flix
//
//  Created by Sanaz Khosravi on 9/6/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    
    @IBOutlet var myImageView: UIImageView!
    
    @IBOutlet var myDescLabel: UILabel!
    @IBOutlet var myTitleLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            myTitleLabel.text = movie?.title
            myDescLabel.text = movie?.overview
            myImageView.af_setImage(withURL: (movie?.posterURL)!)
        }
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
