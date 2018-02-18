import UIKit
import SPARCore

struct bookmarkData {
    let cell: Int!
    let author: String!
    let title: String!
    let articleImage: UIImage? //there may not be an article image.
    let userImage: UIImage!
    let time: String!
}

class BookmarkViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    let defaults:UserDefaults = UserDefaults.standard
    var arr = [SPARCArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr = SPARCArticle.loadDummyArticles()
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            revealViewController().rearViewRevealWidth = 220
        }
        // Do any additional setup after loading the view.
        // let data = defaults.data(forKey: "bookmarkArticles")
        //arr = (NSKeyedUnarchiver.unarchiveObject(with: data!) as? [SPARCArticle])!
        
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
        return 1
    }
    
    //Dequeue function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! NewsTableViewCell
        //let authorArr = arr[indexPath.row].authors
        let authorArr = arr[indexPath.row].authors
        var authorNames=""
        for author in authorArr! {
            authorNames+=author["name"] as! String
        }
        
        let title = arr[indexPath.row].title
        print("TITLE: \(title ?? "no title")")
        
        
        cell.authorName.text = String("by ") + "\(authorNames)"
        cell.articleTitle.text = title
        if (title == "Testarticle 0"){
            cell.articleTitle.text = "This article has a very verbose title so that you can see two lines!"}
        cell.authorImage.image = #imageLiteral(resourceName: "article")
        cell.articleImage.image = #imageLiteral(resourceName: "article")
        //cell.timestamp.text = DateFormatter.string(arr[indexPath.row].datePublished)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    
    // Changing cell height to 80. Was not working on storyboard
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
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
                destinationVC.text = "Loading article..."
                destinationVC.isBookmarkView = true
                destinationVC.getArticle = arr[articleIndex];
            }
        }
    }
    
}

