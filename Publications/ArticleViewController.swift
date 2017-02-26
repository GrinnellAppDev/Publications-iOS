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
    
    var text = "haha"
    

    @IBOutlet weak var articlePic: UIImageView!
    @IBOutlet weak var articleName: UILabel!
    @IBOutlet weak var lblText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        articleName.text = "Welcome to the all-new SPARC App"
        lblText.text = self.text
        lblText.isEditable = false
        lblText.isScrollEnabled = false
        articlePic.image = #imageLiteral(resourceName: "JRC")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.title = "Article"
       
    }
    
    /* ScrollView Layout
    override func viewDidLayoutSubviews() {
        let contentSize = lblText.sizeThatFits(lblText.bounds.size)
        var frame = lblText.frame
        frame.size.height = contentSize.height
        lblText.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: lblText, attribute: .height, relatedBy: .equal, toItem: lblText, attribute: .width, multiplier: lblText.bounds.height/lblText.bounds.width, constant: 1)
        lblText.addConstraint(aspectRatioTextViewConstraint)
    }
    */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
