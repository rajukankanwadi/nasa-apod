//
//  MainViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 31/01/22.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func podButtonClicked(_ sender: Any) {
        if let podVC: ViewController = getVCFromStoryBoardInstance(storyBoard: "Main", StoryBoardID: "ViewController") {
            self.navigationController?.pushViewController(podVC, animated: true)
        }
    }
    
    @IBAction func favButtonClicked(_ sender: Any) {
        if let podVC: FavouritesTableViewController = getVCFromStoryBoardInstance(storyBoard: "Main", StoryBoardID: "FavouritesTableViewController") {
            self.navigationController?.pushViewController(podVC, animated: true)
        }
    }
    
    @IBAction func searchByDate(_ sender: Any) {
        if let podVC: ViewController = getVCFromStoryBoardInstance(storyBoard: "Main", StoryBoardID: "ViewController") {
            podVC.isSerchByDate = true
            self.navigationController?.pushViewController(podVC, animated: true)
        }
    }
}
