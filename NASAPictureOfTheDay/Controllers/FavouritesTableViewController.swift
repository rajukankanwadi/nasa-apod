//
//  FavouritesTableViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 31/01/22.
//

import UIKit

class FavouritesTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    static var favItems: [PictureOfTheDay] = []
    static var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        tableView.estimatedRowHeight = 90
        tableView.register(UINib.init(nibName: String(describing: FavPictureTableViewCell.self), bundle: nil), forCellReuseIdentifier: "FavPictureTableViewCell")
    }

}

extension FavouritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavouritesTableViewController.favItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavPictureTableViewCell", for: indexPath) as? FavPictureTableViewCell {
            let favItem = FavouritesTableViewController.favItems[indexPath.row]
            let image = FavouritesTableViewController.images[indexPath.row]
            cell.configureCell(favItem: favItem, image: image)
        }
        return UITableViewCell()
    }
    
    
}
