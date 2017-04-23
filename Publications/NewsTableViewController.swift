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
    
    //var arrayOfArticle = [newsData]()
    var arr = [GADArticle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr = GADArticle.loadDummyArticles()

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
    
    
    // Old function
 /*   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextNewsTableViewCell
            let authorArr = arr[indexPath.row].authors
            
            cell.userName.text = authorArr
            cell.articleLabel.text = arr[indexPath.row].title
            cell.profilePic.image = #imageLiteral(resourceName: "article")
            //cell.timeStamp.text = DateFormatter.string(arr[indexPath.row].datePublished)
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
        
        /*
        if arrayOfArticle[indexPath.row].cell == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            cell.authorLabel.text = arrayOfArticle[indexPath.row].author
            cell.postTitleLabel.text = arrayOfArticle[indexPath.row].title
            cell.postImageView.image = arrayOfArticle[indexPath.row].articleImage
            cell.authorImageView.image = arrayOfArticle[indexPath.row].userImage
            cell.timeStamp.text = arrayOfArticle[indexPath.row].time
            
            return cell
            
        } else if arrayOfArticle[indexPath.row].cell == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextNewsTableViewCell
            cell.userName.text = arrayOfArticle[indexPath.row].author
            cell.articleLabel.text = arrayOfArticle[indexPath.row].title
            cell.profilePic.image = arrayOfArticle[indexPath.row].userImage
            cell.timeStamp.text = arrayOfArticle[indexPath.row].time
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
            cell.authorLabel.text = arrayOfArticle[indexPath.row].author
            cell.postTitleLabel.text = arrayOfArticle[indexPath.row].title
            cell.postImageView.image = arrayOfArticle[indexPath.row].articleImage
            cell.authorImageView.image = arrayOfArticle[indexPath.row].userImage
            cell.timeStamp.text = arrayOfArticle[indexPath.row].time
            
            return cell
        }
        */
    }*/
    
    
    //Maddy's new function
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! NewsTableViewCell
        let authorArr = arr[indexPath.row].authors
        let title = arr[indexPath.row].title
        print("TITLE: \(title ?? "no title")")
        
        cell.authorName.text = authorArr
        //cell.articleTitle.text = arr[indexPath.row].title
        cell.articleTitle.text = title
        cell.authorImage.image = #imageLiteral(resourceName: "article")
        cell.articleImage.image = #imageLiteral(resourceName: "article")
        //cell.timestamp.text = DateFormatter.string(arr[indexPath.row].datePublished)
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
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
