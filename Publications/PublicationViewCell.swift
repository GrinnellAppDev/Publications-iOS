import UIKit

class PublicationViewCell: UITableViewCell {
    @IBOutlet weak var publicationName:UILabel!
    @IBOutlet weak var publicationLogo:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
