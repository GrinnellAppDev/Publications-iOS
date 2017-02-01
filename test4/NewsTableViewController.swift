//
//  NewsTableViewController.swift
//  test4
//
//  Created by comp on 28/10/2016.
//  Copyright © 2016 comp. All rights reserved.
//

import UIKit

class NewsTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = "revealToggle:"
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            revealViewController().rearViewRevealWidth = 220
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 4
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        // Configure the cell...
        if (indexPath as NSIndexPath).row == 0 {
            cell.postImageView.image = UIImage(named: "article")
            cell.postTitleLabel.text = "There was theater performance. Everyone was great"
            cell.authorLabel.text = "Sarah Trop"
            cell.authorImageView.image = UIImage(named: "article")
            
        } else if (indexPath as NSIndexPath).row == 1 {
            cell.postImageView.image = UIImage(named: "article")
            cell.postTitleLabel.text = "A cool person made a beautiful and intriguing art gallery"
            cell.authorLabel.text = "Author"
            cell.authorImageView.image = UIImage(named: "article")
            
        } else if (indexPath as NSIndexPath).row == 2 {
            cell.postImageView.image = UIImage(named: "article")
            cell.postTitleLabel.text = "A cool person made a beautiful and intriguing art gallery"
            cell.authorLabel.text = "Author"
            cell.authorImageView.image = UIImage(named: "article")
            
        } else {
            cell.postImageView.image = UIImage(named: "article")
            cell.postTitleLabel.text = "This article is about sports"
            cell.authorLabel.text = "Author"
            cell.authorImageView.image = UIImage(named: "article")
            
        }
        
        return cell
}
    
}
