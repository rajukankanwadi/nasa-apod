//
//  PictureOfTheDay.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 29/01/22.
//

import Foundation

let apiKey = "JfzKegXogMdh7EkWc9jnJtP7X8iuoWYcg6Ui1boS"
let apodURL = "https://api.nasa.gov/planetary/apod"


class PictureOfTheDay: Codable {
    let copyright: String?
    let date: String?
    let explanation: String?
    let hdurl: String?
    let mediaType: String?
    let serviceVersion: String?
    let title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case copyright
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title
        case url
    }
}

extension PictureOfTheDay: Equatable {
  static func == (lhs: PictureOfTheDay, rhs: PictureOfTheDay) -> Bool {
    return lhs.url == rhs.url
  }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func fetchAPOD(url: URL, completionHandler: @escaping (PictureOfTheDay?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(PictureOfTheDay.self, from: data), response, nil)
        }
    }

    func pictureOfTheDayTask(with url: URL, completionHandler: @escaping (PictureOfTheDay?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        var urlComps = URLComponents(string: apodURL)!
        urlComps.queryItems = queryItems
        let apodURL = urlComps.url!
        
        return self.fetchAPOD(url: apodURL, completionHandler: completionHandler)
    }
    func pictureOfTheDayForGivenDate(with url: URL, date: String? = nil, completionHandler: @escaping (PictureOfTheDay?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let date = date ?? Date().yyyyMMdd
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey),URLQueryItem(name: "date", value: date)]
        var urlComps = URLComponents(string: apodURL)!
        urlComps.queryItems = queryItems
        let apodURL = urlComps.url!
        
        return self.fetchAPOD(url: apodURL, completionHandler: completionHandler)
    }
    
    
    func loadImage(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(data, response, nil)
        }
    }
}
