//
//  FavouritesTableViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 31/01/22.
//

import UIKit

class FavouritesTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var savedPics: [SavedPictureModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favourites"
        tableView.estimatedRowHeight = 90
        tableView.register(UINib.init(nibName: String(describing: FavPictureTableViewCell.self), bundle: nil), forCellReuseIdentifier: "FavPictureTableViewCell")
        tableView.tableFooterView = UIView()
        savedPics = CoreDataHelper.retrieveSavedData()
        tableView.reloadData()
    }

}

extension FavouritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedPics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FavPictureTableViewCell", for: indexPath) as? FavPictureTableViewCell {
            let favItem = savedPics[indexPath.row]
            cell.configureCell(favItem: favItem, imageData: favItem.imageData ?? Data())
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension SavedPictureModel {
    static func == (lhs: SavedPictureModel, rhs: SavedPictureModel) -> Bool {
      return lhs.url == rhs.url
    }
  }
