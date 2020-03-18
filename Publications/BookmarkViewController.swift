import UIKit
import SPARCore

struct bookmarkData {
    let cell: Int!
    let author: String!
    let title: String!
    let bigImage: UIImage? //there may not be an article image.
    let userImage: UIImage!
    let time: String!
}

class BookmarkViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    let defaults:UserDefaults = UserDefaults.standard
    var arr = [SPARCArticle]()
    let images = [#imageLiteral(resourceName: "Image-15"),#imageLiteral(resourceName: "Image-16"),#imageLiteral(resourceName: "Image-3"),#imageLiteral(resourceName: "Image-2"),#imageLiteral(resourceName: "Image"),#imageLiteral(resourceName: "Image-10"),#imageLiteral(resourceName: "Image-9"),#imageLiteral(resourceName: "siliconvalley"),#imageLiteral(resourceName: "Image-4"),#imageLiteral(resourceName: "Image-1"),#imageLiteral(resourceName: "Image-14"),#imageLiteral(resourceName: "Image-8"),#imageLiteral(resourceName: "Image-13"),#imageLiteral(resourceName: "Image-6"),#imageLiteral(resourceName: "Image-12"),#imageLiteral(resourceName: "Image-11")]
    var haveReadDict : Dictionary <String, Double> = Dictionary <String, Double>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //defaults.removeObject(forKey: "bookmark")
        if let data = defaults.data(forKey: "bookmark") {
            arr = (NSKeyedUnarchiver.unarchiveObject(with: data) as? [SPARCArticle])!
        }
        
        if (defaults.object(forKey: "haveReadDictionary") == nil) {
            defaults.set(Dictionary <String, Double>(), forKey: "haveReadDictionary")
        } else {
            haveReadDict = defaults.object(forKey: "haveReadDictionary") as! Dictionary <String, Double>
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            revealViewController().rearViewRevealWidth = 220
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        // return arr.count
        return arr.count
    }
  
    
    //Dequeue function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! NewsTableViewCell
        let authorArr = arr[indexPath.row].authors
        if let authors = authorArr {
            cell.authorName.text = SPARCArticle.parseAuthors(authors as? Array<Dictionary<String, Any>>)
        } else {
            cell.authorName.text = "by Anonymous"
        }
        
        let title = arr[indexPath.row].title
        print("TITLE: \(title ?? "no title")")
        cell.articleTitle.text = arr[indexPath.row].title
        cell.bigImage.image = #imageLiteral(resourceName: "s_and_b")
        let bigImage = arr[indexPath.row].headerImage ?? nil
        cell.bigImage.image = bigImage ?? images[(indexPath.row)%16]

        var minutes = "\(arr[indexPath.row].minutes ?? " ") min read"
        if haveReadDict[title!] != nil {
            minutes = "Finished Reading"
        }
        cell.article.text =  minutes
        
        let time = arr[indexPath.row].datePublished
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeString = dateFormatter.string(from: time!)
        cell.timestamp.text = timeString.isEmpty ? "published at unknown spacetime coordinates" : timeString

        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    
    // Changing cell height to 80. Was not working on storyboard
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450;
    }
    
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookmark"
        {
            // Unarchive the Userdefaults bookmarked articles
            
            // Pass bookmarked articles through segue
            if let destinationVC = segue.destination as? ArticleViewController,
                let articleIndex = tableView.indexPathForSelectedRow?.row
            {
                if let title = arr[articleIndex].title {
                    destinationVC.titleTxt = title
                }
                destinationVC.isBookmarkView = true
                destinationVC.getArticle = arr[articleIndex];
                destinationVC.text = arr[articleIndex].content!
                destinationVC.articleImage = arr[articleIndex].headerImage
            }
        }
    }
    
}

