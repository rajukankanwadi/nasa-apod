//
//  FavPictureTableViewCell.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 31/01/22.
//

import UIKit

class FavPictureTableViewCell: UITableViewCell {

    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell(favItem: PictureOfTheDay, image: UIImage) {
        self.titleLabel.text = favItem.title
        self.dateLabel.text = favItem.date
        self.favImageView.image = image
    }
    
}
