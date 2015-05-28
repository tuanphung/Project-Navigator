//
//  ExUtilities.swift
//  upaty
//
//  Created by Tuan Phung on 11/10/14.
//  Copyright (c) 2014 Tuan Phung. All rights reserved.
//

import Foundation

// Additional Utilities for your application
extension ExUtilities {
    class func timeFormatFromSeconds(totalSeconds: Int32) -> String {
        var seconds = totalSeconds % 60;
        var minutes = (totalSeconds / 60) % 60;
        var hours = totalSeconds / 3600;
        
        var output = ""
        if (hours > 0) {
            output += "\(hours)hrs "
        }
        
        if (minutes > 0) {
            output += "\(minutes)min "
        }
        
        if (seconds > 0) {
            output += "\(seconds)s"
        }
        
        return output
    }
}