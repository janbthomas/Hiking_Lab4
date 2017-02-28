//
//  AboutViewController.swift
//  CIS55Lab2_JanThomas
//
//  Created by Jan on 2/4/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class AboutViewController: UIViewController {

    @IBOutlet weak var Nodira: UIImageView!
    @IBOutlet weak var JansPhoto: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.JansPhoto.image = UIImage(named: "JansPhoto")
        self.Nodira.image = UIImage(named: "Nodira")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
