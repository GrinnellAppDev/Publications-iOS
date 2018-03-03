import SPARCore
import UIKit

struct newsData {
    let cell: Int!
    let author: String!
    let title: String!
    let articleImage: UIImage? //there may not be an article image.
    let userImage: UIImage!
    let time: String!
}

class NewsTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let defaults:UserDefaults = UserDefaults.standard
    var publication : SPARCPublication?
    var arr = [SPARCArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (publication != nil) {
            publication?.fetchArticles(withNextPageToken: nil, completion: { (articlesArray, nextPageForArticlesToken, error) in
                if let articles = articlesArray
                    {
                        self.arr = articles
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
        } else {
            SPARCPublication.fetchAll(withNextPageToken: nil) { (pubsArray, nextPageToken, error) in
                if let publications = pubsArray
                {
                    for publication in publications
                    {
                        publication.fetchArticles(withNextPageToken: nil, completion: { (articlesArray, nextPageForArticlesToken, error) in
                            if let articles = articlesArray
                            {
                                self.arr = articles
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        }
//        arr = SPARCArticle.loadDummyArticles()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            revealViewController().rearViewRevealWidth = 220
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == arr.count - 1) {
            var newArr : [SPARCArticle] = SPARCArticle.loadDummyArticles()
            arr.append(contentsOf: newArr)
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! NewsTableViewCell
        let authorArr = arr[indexPath.row].authors
        let title = arr[indexPath.row].title
        print("TITLE: \(title ?? "no title")")
        
        if let authors = authorArr {
            cell.authorName.text = parseAuthors(authorArr: authors as! Array<Dictionary<String, String>>)
        }
        else
        {
            cell.authorName.text = "by anon"
        }
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
    
    
    // Changing cell height to 100. Was not working on storyboard
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
     }
    
    func parseAuthors (authorArr:Array<Dictionary<String, String>>) -> String
    {
        var authorText = "by "
        for auth in authorArr
        {
            authorText += "\(auth["name"] ?? "anonymous")"
        }
        return authorText
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "article"
        {
            if let destinationVC = segue.destination as? ArticleViewController,
                 let articleIndex = tableView.indexPathForSelectedRow?.row
            {
                if let title = arr[articleIndex].title {
                    destinationVC.titleTxt = title
                }
                destinationVC.text = "Loading article..."
                destinationVC.isBookmarkView = false
                destinationVC.getArticle = arr[articleIndex];
            }
        }
    } 
    

    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfArticle[indexPath.row].cell == 1 {
            return 243
        } else if arrayOfArticle[indexPath.row].cell == 2 {
            return 94
        } else {
            return 243
        }
    } */
    
}
