import SPARCore
import CoreLocation
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
    var curPageTokens = [String : String]()
    var curPublication : SPARCPublication?
    var arr = [SPARCArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add Refresh Control to Table View
        let refreshControl = UIRefreshControl()
        /*if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            //tableView.addSubview(refreshControl)
            tableView.insertSubview(refreshControl, at: 0)
        }*/
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
        //tableView.insertSubview(refreshControl, at: 0)

        
        if (curPublication != nil) {
            curPublication?.fetchArticles(withNextPageToken: nil, nextPageSize: nil, completion: { (articlesArray, nextPageForArticlesToken, error) in
                if let articles = articlesArray
                    {
                        self.arr = articles
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                })
        } else {
            print("herrerere")
            
            SPARCPublication.fetchAll(withNextPageToken: nil, nextPageSize: nil, completion: { (pubsArray, nextPageToken, error) in
                print("herrerere1")
                if let publications = pubsArray
                {
                    print("herrerere2")
                    
                    for publication in publications
                    {
                        print("herrerere3")

                        publication.fetchArticles(withNextPageToken: nil, nextPageSize: nil, completion: { (articlesArray, nextPageForArticlesToken, error) in
                            if let articles = articlesArray
                            {
                                print("herrerere4")

                                self.arr += articles
                                if (nextPageForArticlesToken != nil) {
                                    self.curPageTokens[publication.name!] = nextPageForArticlesToken
                                }
                                //print("Initial token: ")
                                //print(self.curPageToken ?? "THERE'S NO PAGE TOKEN!")
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            })
        }
        // arr = SPARCArticle.loadDummyArticles()

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
        //print("Fetching new data with " + (self.curPageToken ?? "THERE'S NO PAGE TOKEN!"))
        if (indexPath.row == arr.count - 1) {
            if (curPublication == nil){
            SPARCPublication.fetchAll(withNextPageToken: nil, nextPageSize: nil, completion: { (articlesArray, nextPageForArticlesToken, error) in
                if let publications = articlesArray
                {
                    for publication in publications
                    {
                        if let token = self.curPageTokens[publication.name!] {
                            publication.fetchArticles(withNextPageToken: token, nextPageSize: "2", completion: { (articlesArray, token, error) in
                                if let articles = articlesArray
                                {
                                    self.arr.append(contentsOf: articles)
                                    //print("We loaded " + String(articles.count) + " articles.")
                                    if (token != nil) {
                                        self.curPageTokens[publication.name!] = token!
                                    }
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                                }
                            })
                        }
                    }
                }
            })
            } else {
                if let token = self.curPageTokens[(curPublication?.name!)!] {
                    curPublication?.fetchArticles(withNextPageToken: token, nextPageSize: nil, completion: { (articlesArray, token, error) in
                        if let articles = articlesArray
                        {
                            self.arr.append(contentsOf: articles)
                            //print("We loaded " + String(articles.count) + " articles.")
                            if (token != nil) {
                                self.curPageTokens[(self.curPublication?.name!)!] = token!
                            }
                            //self.curPageToken = token
                            //print(self.curPageToken ?? "THERE'S NO PAGE TOKEN!")
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
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
        let title = arr[indexPath.row].title
        let articleImage = arr[indexPath.row].headerImage
        print("TITLE: \(title ?? "no title")")
        let authorArr = arr[indexPath.row].authors
        if let authors = authorArr {
            cell.authorName.text = parseAuthors(authorArr: authors as! Array<Dictionary<String, String>>)
        } else {
            cell.authorName.text = "by unknown author"
        }
        cell.articleTitle.text = title
        cell.authorImage.image = #imageLiteral(resourceName: "article")
        cell.articleImage.image = articleImage ?? #imageLiteral(resourceName: "appdev")
        
        // populate time published info
        let time = arr[indexPath.row].datePublished as Date?
        let dateFormatter = DateFormatter()
        let timeString = dateFormatter.string(from: time!)
        cell.timestamp.text = timeString.isEmpty ? "published at unknown spacetime coordinates" : timeString
        
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
    
    // refresh data
    func refreshData(_ sender: Any) {
        if (curPublication != nil) {
            curPublication?.fetchArticles(withNextPageToken: nil, nextPageSize: nil, completion: { (articlesArray, nextPageForArticlesToken, error) in
                if let articles = articlesArray
                {
                    self.arr = articles
                    DispatchQueue.main.async {
                        self.refreshControl?.endRefreshing()
                        self.tableView.reloadData()
                        print("Finished loading data")
                    }
                }
            })
        } else {
            SPARCPublication.fetchAll(withNextPageToken: nil, nextPageSize: nil) { (pubsArray, nextPageToken, error) in
                if let publications = pubsArray
                {
                    for publication in publications
                    {
                        publication.fetchArticles(withNextPageToken: nil, nextPageSize: "2", completion: { (articlesArray, nextPageForArticlesToken, error) in
                            if let articles = articlesArray
                            {
                                self.arr = articles
                                if (nextPageForArticlesToken != nil) {
                                    self.curPageTokens[publication.name!] = nextPageForArticlesToken!
                                }
                                //self.curPageToken = nextPageForArticlesToken!
                                //print("Initial token: ")
                                //print(self.curPageToken ?? "THERE'S NO PAGE TOKEN!")
                                DispatchQueue.main.async {
                                    self.refreshControl?.endRefreshing()
                                    self.tableView.reloadData()
                                    print("Finished loading data")
                                }
                            }
                        })
                    }
                }
            }
        }
        print("Finished loading data")
        //self.refreshControl?.endRefreshing()
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
