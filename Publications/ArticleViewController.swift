//
//  ArticleViewController.swift
//  test4
//
//  Created by comp on 02/11/2016.
//  Copyright © 2016 comp. All rights reserved.
//
import Foundation
import UIKit
class ArticleViewController: UIViewController {
    
    let text = "afsafsadfasdfasdfas asf asfas fasdf asdf asdf adsf adfas fasdf asdf asdf sadf asd fasd fasd fasdf sadf sadf asdf sad fasd fasdf asdf asdf sa fsad fasd fasd fasd fasdfasdf sad fas fsad fasd fasd fasdfsa fsdf dsafasdfas fsa fsadfasdfsa fsa fsadfa fsd fas fasfsadf as fsdf as fasd fasfs fsa /n adsf asf asf asf asfaf sa fsa fsaf sa f /n asdf afasf asd fasdf asdf asdf adsf asdf asf asf asf sa fsdf saf sadf asdf sad f/n asdf asdf af saf sa sf s."
    
    @IBOutlet var lblText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblText.text = self.text
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
