//
//  ViewController.swift
//  CoreAnimationExperiment
//
//  Created by 赵一达 on 2016/11/10.
//  Copyright © 2016年 赵一达. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        let circleFrame = CGRect.init(origin: self.view.center, size: CGSize.init(width: 50, height: 50))
        var circle = CircleView.init(frame: circleFrame)
        
        
        self.view.addSubview(circle)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

