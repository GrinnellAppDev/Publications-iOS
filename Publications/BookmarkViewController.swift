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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //defaults.removeObject(forKey: "bookmark")
        if let data = defaults.data(forKey: "bookmark") {
            arr = (NSKeyedUnarchiver.unarchiveObject(with: data) as? [SPARCArticle])!
            self.tableView.reloadData()   // ...and it is also visible here.
        }
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
        var authorNames=""
        for author in authorArr! {
            authorNames+=author["name"] as! String
        }
        
        let title = arr[indexPath.row].title
        print("TITLE: \(title ?? "no title")")
        
        cell.authorName.text = String("by ") + "\(authorNames)"
        cell.articleTitle.text = arr[indexPath.row].title
        cell.bigImage.image = #imageLiteral(resourceName: "s_and_b")
        cell.bigImage.image = arr[indexPath.row].headerImage ?? #imageLiteral(resourceName: "s_and_b")
        cell.article.text = ""
        
        
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

