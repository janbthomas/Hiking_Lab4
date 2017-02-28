//
//  HikingListObject.swift
//  CIS55Lab2_JanThomas_NodiaMamatova
//
//  Created by Jan on 2/13/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit

class HikingListObject: NSObject {
    var hikingLocations = ""
    var hikingImages = UIImage(named: "")
    var hikingDetail = ""
    var hikingChecked = false
    
    init( hikingLocations: String, hikingImages: UIImage, hikingDetail: String, hikingChecked: Bool) {
        
        self.hikingLocations = hikingLocations
        self.hikingImages = hikingImages
        self.hikingDetail = hikingDetail
        self.hikingChecked = hikingChecked
    }

}
