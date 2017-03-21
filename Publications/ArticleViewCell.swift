//
//  ArticleViewCell.swift
//  Publications
//
//  Created by Kevin Kim on 3/8/17.
//  Copyright © 2017 comp. All rights reserved.
//

import UIKit

class ArticleViewCell: UITableViewCell {
    @IBOutlet weak var articleIcon: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleTxt: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
