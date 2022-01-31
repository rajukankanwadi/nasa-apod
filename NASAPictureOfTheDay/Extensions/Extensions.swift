//
//  Extensions.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 31/01/22.
//

import Foundation
import UIKit

extension UIViewController {

    func getVCFromStoryBoardInstance<T:UIViewController>(storyBoard: String, StoryBoardID: String) ->T? {
        let storyBoard = UIStoryboard.init(name: storyBoard, bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: StoryBoardID) as? T {
            return vc
        }
        return T()
    }

}

extension Date {
    /// String representation of `Date` in yyyy-MM-dd format
    var yyyyMMdd: String? {
        let dateFormatter = customDateFormat()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func customDateFormat() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
}
