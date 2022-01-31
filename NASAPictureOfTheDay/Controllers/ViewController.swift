//
//  ViewController.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 29/01/22.
//

import UIKit
import CoreData

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
    var downloadedImage: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        
        //Check if any saved item is present for selected day
        if let savedPicInfo = CoreDataHelper.retrieveData(forDate: datePicker.date.yyyyMMdd ?? Date().yyyyMMdd!), let title = savedPicInfo.title, let explnaination = savedPicInfo.explaination, let imageData = savedPicInfo.imageData {
            setUpTextlabels(title: title, explanation: explnaination)
            imageView.image = UIImage(data: imageData)
            stopActivityIndicator()
        }

        if isSerchByDate {
            self.title = "Search By Date"
            searchDateView.isHidden = false
            getPictureForSelectedDate()
        } else {
            self.title = "APOD"
            searchDateView.isHidden = true
            fetchCurrentDateAPOD()
        }
        if !InternetConnectionManager.isConnectedToNetwork() {
            stopActivityIndicator()
            showAlert(title: "No Internet", message: "Please check your connection and retry")
        }
        self.view.layoutSubviews()
    }
    
    fileprivate func setUpTextlabels(title: String?, explanation: String?) {
        self.titleLabel.isHidden = false
        self.subTitleLabel.isHidden = false
        self.titleLabel.text = title
        self.subTitleLabel.text = explanation
        self.view.layoutSubviews()
    }
    
    func fetchCurrentDateAPOD () {
        URLSession.shared.pictureOfTheDayTask(with: URL(string: apodURL)! ) { pictureInfo, _, error in
            if error == nil {
                if let picInfo = pictureInfo, let urlStr = picInfo.url {
                    self.picInfo = picInfo
                    self.downloadImage(urlString: urlStr)
                    DispatchQueue.main.async {
                        self.setUpTextlabels(title: picInfo.title, explanation: picInfo.explanation)
                    }
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
                    self.downloadedImage = imageData
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
        if !InternetConnectionManager.isConnectedToNetwork() {
            stopActivityIndicator()
            showAlert(title: "No Internet", message: "Please check your connection and retry")
        }
    }

    fileprivate func showAlert(title: String, message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func favouriteButtonClicked(_ sender: Any) {
        if let picInfo = self.picInfo {
            let savedDates = CoreDataHelper.retrieveSavedData().map{$0.date}
            if savedDates.contains(picInfo.date) {
                showAlert(title: "Saved Already", message: "This image alredy exists in Favourites")
                return
            }
            //Save favourite records in coreData
            CoreDataHelper.createData(picInfo: picInfo, imageData: self.downloadedImage ?? Data())
            showAlert(title: "Saved", message: "This image is now saved in Favourites")
        }
    }
    
    fileprivate func getPictureForSelectedDate() {
        URLSession.shared.pictureOfTheDayForGivenDate(with: URL(string: apodURL)!,date: datePicker.date.yyyyMMdd ) { pictureInfo, _, error in
            if error == nil {
                if let picInfo = pictureInfo, let urlStr = picInfo.url {
                    self.picInfo = picInfo
                    self.downloadImage(urlString: urlStr)
                    DispatchQueue.main.async {
                        self.setUpTextlabels(title: picInfo.title, explanation: picInfo.explanation)
                    }
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
