import UIKit

class TextNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var articleLabel:UILabel!
    @IBOutlet weak var profilePic:UIImageView!
    @IBOutlet weak var userName:UILabel!
    @IBOutlet weak var timeStamp:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
