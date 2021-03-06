//
//  PosterCell.swift
//  Flix
//
//  Created by Sanaz Khosravi on 9/12/18.
//  Copyright © 2018 GirlsWhoCode. All rights reserved.
//

import UIKit

class PosterCell: UICollectionViewCell {
    
    
    @IBOutlet var myImageView: UIImageView!
    
    var movie: Movie? {
        didSet {
            myImageView.af_setImage(withURL: (movie?.posterURL)!)
        }
    }
    
}
