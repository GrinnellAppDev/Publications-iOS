import UIKit

class AboutViewController: UIViewController {
    
    var pageType = -1;
    
    var aboutImages = [#imageLiteral(resourceName: "s_and_b"), #imageLiteral(resourceName: "appdev")];
    var aboutTitles = ["About S&B", "About AppDev", "Change article font size"];
    var aboutEmails = ["[thesanddb]", "[appdev]"];
    var aboutTexts = ["The Scarlet and Black is a weekly student-run newspaper that covers different facets of life at Grinnell College and in the town of Grinnell. \n\nFor advertising opportunities, please contact sandbands@grinnell.edu. \n\nFor general information, please email newspapr@grinnell.edu", "Grinnell AppDev is a student-based mobile application development team from Grinnell College that designs, develops, and deploys mobile applications on the iOS and Android platforms. We come from different backgrounds, and parts of the world. Each one of us is an irreplacable part of the team that brings something unique and valuable to the team. \n\nWe are commited to bringing high quality applications to our campus and the rest of the world.\n\nGrinnell Appdev is strongly committed to a collaborative programming process.  Check out our code on GitHub: https://github.com/GrinnellAppDev"];

    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var aboutTitle: UILabel!
    @IBOutlet weak var aboutEmail: UILabel!
    @IBOutlet weak var aboutText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(pageType)

        self.aboutImage.image = (aboutImages[pageType]);
        self.aboutTitle.text = aboutTitles[pageType].uppercased()
        self.aboutEmail.text = aboutEmails[pageType].lowercased()
        self.aboutText.text = aboutTexts[pageType]
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
