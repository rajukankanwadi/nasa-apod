//
//  ViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 29/01/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchDateView: UIStackView!
    
    var isSerchByDate = false
    var picInfo: PictureOfTheDay?
    var downloadedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.startAnimating()
        if isSerchByDate {
            self.title = "Search By Date"
            searchDateView.isHidden = false
            getPictureForSelectedDate()
        } else {
            self.title = "APOD"
            searchDateView.isHidden = true
            fetchCurrentDaeAPOD()
        }
        self.view.layoutSubviews()
    }
    
    func fetchCurrentDaeAPOD () {
        URLSession.shared.pictureOfTheDayTask(with: URL(string: apodURL)! ) { pictureInfo, _, error in
            if error == nil {
                if let picInfo = pictureInfo, let urlStr = picInfo.url {
                    self.picInfo = picInfo
                    DispatchQueue.main.async {
                        self.titleLabel.text = picInfo.title
                        self.subTitleLabel.text = picInfo.explanation
                        self.view.layoutSubviews()
                    }
                    self.downloadImage(urlString: urlStr)
                } else {
                   self.stopActivityIndicator()
                }
            }
        }.resume()
    }
    
    func downloadImage(urlString: String) {
        DispatchQueue.global().async {
            URLSession.shared.loadImage(url: URL(string: urlString)!) { data, _, error in
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.downloadedImage = image
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.imageView.image = image
                        self.view.layoutSubviews()
                    }
                } else {
                    self.stopActivityIndicator()
                }
            }.resume()
        }
    }
    
    @IBAction func searchByDateClicked(_ sender: Any) {
        imageView.image = UIImage()
        self.titleLabel.text = ""
        self.subTitleLabel.text = ""
        activityIndicator.startAnimating()
        getPictureForSelectedDate()
    }
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        if let picInfo = self.picInfo, !FavouritesTableViewController.favItems.contains(picInfo) {
            FavouritesTableViewController.favItems.append(picInfo)
            FavouritesTableViewController.images.append(self.downloadedImage ?? UIImage())
        }
    }
    
    fileprivate func getPictureForSelectedDate() {
        URLSession.shared.pictureOfTheDayForGivenDate(with: URL(string: apodURL)!,date: datePicker.date.yyyyMMdd ) { pictureInfo, _, error in
            if error == nil {
                if let picInfo = pictureInfo, let urlStr = picInfo.url {
                    self.picInfo = picInfo
                    DispatchQueue.main.async {
                        self.titleLabel.text = picInfo.title
                        self.subTitleLabel.text = picInfo.explanation
                        self.view.layoutSubviews()
                    }
                    self.downloadImage(urlString: urlStr)
                } else {
                    self.stopActivityIndicator()
                }
            }
        }.resume()
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
}
