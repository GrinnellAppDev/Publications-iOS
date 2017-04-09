import UIKit

class AboutViewController: UIViewController {
    
    var pageType = -1;
    
    var aboutImages = [#imageLiteral(resourceName: "sparc"), #imageLiteral(resourceName: "appdev")];
    var aboutTitles = ["About SPARC", "About AppDev", "Change article font size"];
    var aboutEmails = ["[sparc]", "[appdev]"];
    var aboutTexts = ["The Student Publication and Radio Committee (SPARC) funds the publication of all student media projects on campus. The Student Activity Fee provides SPARC with its budget, with which the SPARC Executive and committee fund both long-running and single-edition student publications at the beginning of each semester. The Executive is comprised of the elected SPARC Chair and Vice-Chair positions, as well as the hired SPARC Treasurer and Assistant Treasurer, and the Committee consists of the Media Heads of each applying publication in addition to SPARC's Media Coordinator.", "Grinnell AppDev is a student organiztion dedicated to creating software applications to serve both students and the larger Grinnell community. We believe that a collaborative and engaging creation environment not only produces the best applications but also provides valuable experience and skillsets for Grinnell graduates to take with them on any careet path. Since 2012 Grinnell AppDev has trained the next generation of programmers and entrepreneurs to create and publicize a wide variety of products"];

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
