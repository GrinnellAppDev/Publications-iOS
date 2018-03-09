import UIKit

class ArticleViewCell: UITableViewCell {
    
    @IBOutlet weak var articleIcon: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleTxt: UITextView!
    @IBOutlet weak var titleTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
