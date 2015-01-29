//
//  ViewController.swift
//  SideBar
//
//  Created by Anil on 20/11/14.
//  Copyright (c) 2014 Dharmesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, sideBarDelegate {

    var sideBar : SideBar = SideBar()
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideBar = SideBar(sourceView: self.view, menuIteams: ["FirstIteam","SecondIteam","ThirdIteam","FourthIteam"])
        sideBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func sideBarDidSelectButtonAtIndex(index: Int) {
        
        if index == 0{
            imageView.backgroundColor = UIColor.redColor()
            imageView.image = nil
        }
    }
    @IBAction func index(sender: AnyObject) {
        
        sideBar.showSideBar(true)
        
    }
}

