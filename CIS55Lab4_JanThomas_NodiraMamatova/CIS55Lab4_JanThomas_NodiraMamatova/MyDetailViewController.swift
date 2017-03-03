//
//  MyDetailViewController.swift
//  CIS55Lab4_JanThomas_NodiraMamatova
//
//  Created by Jan on 2/3/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class MyDetailViewController: UIViewController {
    
    @IBOutlet weak var HikingSeason: UILabel!
    @IBOutlet weak var HikingDifficulty: UILabel!
    @IBOutlet weak var LabelDetail: UITextView!
    @IBOutlet weak var LabelItem: UILabel!
    @IBOutlet weak var ImageItem: UIImageView!

    var myHikingList : HikingListObjectMO!
    
     override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.LabelItem.text = self.myHikingList.hikingLocations
        self.LabelDetail.text = self.myHikingList.hikingDetail
        if self.myHikingList.hikingSeason != nil {
            self.HikingSeason.text = "Best Season to Visit: " + self.myHikingList.hikingSeason!
        }
        
        if self.myHikingList.hikingDifficulty != nil {
            self.HikingDifficulty.text = "Hike Difficulty: " + self.myHikingList.hikingDifficulty!
        }
        
        //if self.myHikingList.hikingImages != nil {
        //    self.ImageItem.image = UIImage(data: self.myHikingList.hikingImages as! Data)
        //}
        navigationItem.title = self.myHikingList.hikingLocations
        
    }

    
    //UIView.animate( withDuration: 1, animations: { fish.alpha=0})
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.myHikingList.hikingImages != nil {
            self.ImageItem.image = UIImage(data: self.myHikingList.hikingImages as! Data)
            UIView.animate( withDuration: 0, animations: { self.ImageItem.alpha=0})
        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.myHikingList.hikingImages != nil {
            UIView.animate( withDuration: 3, animations: { self.ImageItem.alpha=1})
        }

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
