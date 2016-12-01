//
//  ViewController.swift
//  RollImgView
//
//  Created by sqluo on 2016/12/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let img = UIImage(named: "111.jpg")
        let rollView = RollView(frame: self.view.bounds, image: img!)

        self.view.addSubview(rollView)
        
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

