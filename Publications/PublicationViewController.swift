import SPARCore
import UIKit


class PublicationViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let defaults:UserDefaults = UserDefaults.standard
    //var arrayOfArticle = [newsData]()
    var arr = [SPARCPublication]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //      arr = SPARCArticle.loadDummyArticles()
        SPARCPublication.fetchAll(withNextPageToken: nil) { (pubsArray, nextPageToken, error) in
            if let publications = pubsArray
            {
                self.arr = publications
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! PublicationViewCell
        cell.publicationName.text = arr[indexPath.row].name
        
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
        if segue.identifier == "showPublication"
        {
            if let destinationVC = segue.destination as? NewsTableViewController,
                let articleIndex = tableView.indexPathForSelectedRow?.row
            {
                destinationVC.publication = arr[articleIndex]
            }
        }
    }
}

