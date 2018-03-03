import Foundation
import UIKit
import SPARCore

struct StretchyHeader {
    
    fileprivate let headerHeight: CGFloat = 170 // the height of the initial image
    
}

class ArticleViewController: UITableViewController {
    
    var isBookmarkView : Bool = false;
    var isBookmarked : Bool = false
    var getArticle : SPARCArticle?
    var articleImage : UIImage!
    var date : String! = ""
    let defaults:UserDefaults = UserDefaults.standard
    var titleTxt = "This is a title, you know?"
    var text = "I'm currently loeading. Give me some time..."
    
    var height: CGFloat = 0.0
    var headerView: UIView!
    var newHeaderLayer: CAShapeLayer!
    
    override func viewWillAppear(_ animated: Bool) {
        // get the font size from userdefault
        //set the font of the text field
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (isBookmarkView == false) {
            DispatchQueue.main.async {
                self.getArticle?.fetchFullText(completion: { (article, err) in
                    self.text = (article?.content!)!
                    self.articleImage = article?.headerImage
                    
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date
                    formatter.dateFormat = "MM/dd/yyyy"
                    let dateString = formatter.string(from: (article?.datePublished)!)
                    self.date = dateString
                    
                    // self.author = article?.authors! as? String ?? "Mike"
                    print(article?.content ?? "not working")
                    self.tableView.reloadData()
                })
            }
            //Set up bookmark button
            let bookmarkButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector(bookmark(_:)))
            self.navigationItem.rightBarButtonItem = bookmarkButton
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
            //Check if the article is already bookmarked
            if let data = defaults.data(forKey: "bookmark"),
                var articleList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SPARCArticle] {
                var i : Int = 0
                while (i < articleList.count) {
                    if (getArticle?.articleId == articleList[i].articleId) {
                        isBookmarked = true
                        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
                        break
                    }
                    i += 1
                }
            }
        } else {
            self.text = (self.getArticle?.content)!
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        updateView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setNewView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView(){
        tableView.backgroundColor = UIColor.white
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.addSubview(headerView)
        newHeaderLayer = CAShapeLayer()
        newHeaderLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = newHeaderLayer
        let newHeight = StretchyHeader().headerHeight
        tableView.contentInset = UIEdgeInsets(top: newHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -newHeight)
        setNewView()
    }
    
    func setNewView(){
        let newHeight = StretchyHeader().headerHeight
        var getHeaderFrame =  CGRect(x: 0, y: -newHeight, width: tableView.bounds.width, height: StretchyHeader().headerHeight)
        if tableView.contentOffset.y < newHeight {
            getHeaderFrame.origin.y = tableView.contentOffset.y
            getHeaderFrame.size.height = -tableView.contentOffset.y
        }
        headerView.frame = getHeaderFrame
        let cutDirection = UIBezierPath()
        cutDirection.move(to: CGPoint(x: 0, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: 0))
        cutDirection.addLine(to: CGPoint(x: getHeaderFrame.width, y: getHeaderFrame.height))
        cutDirection.addLine(to: CGPoint(x: 0, y: getHeaderFrame.height ))
        newHeaderLayer.path = cutDirection.cgPath
    }
    
    // Bookmark action
    @IBAction func bookmark(_ sender: Any) {
        if (!isBookmarked) {

            // retrieving a value for a key
            if let data = defaults.data(forKey: "bookmark"),
                var articleList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [SPARCArticle] {
                articleList.append(getArticle!)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: articleList)
                defaults.set(encodedData, forKey: "bookmark")
            } else {
                var bookmarkArticle : [SPARCArticle] = [SPARCArticle]()
                bookmarkArticle.append(getArticle!)
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: bookmarkArticle)
                defaults.set(encodedData, forKey: "bookmark")
            }
            
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
            print("Hey it's working!")
            isBookmarked = true
        } else {
            // remove the article from userdefaults ...
            // LOOOOOOK HEREEEEEEEEEEE!!!!!
            let data = defaults.data(forKey: "bookmark")
            var articleList = NSKeyedUnarchiver.unarchiveObject(with: data!) as! [SPARCArticle]
            var i : Int = 0
            while (i < articleList.count) {
                if (getArticle?.articleId == articleList[i].articleId) {
                    articleList.remove(at: i)
                    continue
                }
                i += 1
            }
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: articleList)
            defaults.set(encodedData, forKey: "bookmark")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
            print("Removing the article from your bookmarks...")
            isBookmarked = false
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /*
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "funnyCell", for: indexPath) as! ArticleViewCell
        
        cell.username.text = "Mike Zou"
        cell.dateLabel.text = "03/17/2017"
        
        cell.articleTxt.isEditable = false;
        cell.articleTxt.isScrollEnabled = false;
        
        cell.articleTxt.text = text
        cell.titleTxt.text = titleTxt
        let p = CGFloat(defaults.integer(forKey: "font"))
        cell.articleTxt.font = UIFont(name: "Georgia", size: p)
        
//        height = cell.articleTxt.bounds.height
//        
//        let newSize = cell.articleTxt.sizeThatFits(CGSize(width: 352, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = cell.articleTxt.frame
//        newFrame.size = CGSize(width: 352, height: max(newSize.height, height))
//        cell.articleTxt.frame = newFrame
//        height = newFrame.size.height
        
    //    let rowData = data.postArray[indexPath.row]
   //     cell.dateLabel.text = rowData["date"]
    //    cell.usernameLabel.text = rowData["name"]
     //   cell.userImageView.image = UIImage(named: rowData["imageName"]!)
      //  cell.postImageView.image = UIImage(named: rowData["postImageName"]!)
        
        print(height)
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let screenSize = UIScreen.main.bounds
//        let height = screenSize.height
//        if (UITableViewAutomaticDimension <= height) {
//            return height
//        }
        return UITableViewAutomaticDimension
    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        let screenSize = UIScreen.main.bounds
//        let height = screenSize.height
//        if (UITableViewAutomaticDimension <= height) {
//            return height
//        }
//        return UITableViewAutomaticDimension
//    }
}
    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  articleName.text = "Welcome to the all-new SPARC App"
       // lblText.text = self.text
       // lblText.isEditable = false
       // lblText.isScrollEnabled = false
       // articlePic.image = #imageLiteral(resourceName: "JRC")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
       // self.navigationItem.title = "Article"
     
        
    }
    
    func updateView(){
        
    }
    
 
    /* ScrollView Layout
    override func viewDidLayoutSubviews() {
        let contentSize = lblText.sizeThatFits(lblText.bounds.size)
        var frame = lblText.frame
        frame.size.height = contentSize.height
        lblText.frame = frame
        
        let aspectRatioTextViewConstraint = NSLayoutConstraint(item: lblText, attribute: .height, relatedBy: .equal, toItem: lblText, attribute: .width, multiplier: lblText.bounds.height/lblText.bounds.width, constant: 1)
        lblText.addConstraint(aspectRatioTextViewConstraint)
    }
    */
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
 */
