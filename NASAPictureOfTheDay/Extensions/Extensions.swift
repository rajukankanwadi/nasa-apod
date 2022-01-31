//
//  Extensions.swift
//  NASAPictureOfTheDay
//
//  Created by Raju K on 31/01/22.
//

import Foundation
import UIKit
import SystemConfiguration

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


public class InternetConnectionManager {
    
    private init() {
        
    }
    
    public static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}
