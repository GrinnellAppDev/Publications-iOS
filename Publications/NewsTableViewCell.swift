import UIKit

class NewsTableViewCell: UITableViewCell {
    
  /*  @IBOutlet weak var postImageView:UIImageView!
    @IBOutlet weak var authorImageView:UIImageView!
    @IBOutlet weak var postTitleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    */
    
    
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var articleImage: UIImageView!     
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
