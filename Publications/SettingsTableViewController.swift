import UIKit

class SettingsTableViewController: UITableViewController{

    let defaults:UserDefaults = UserDefaults.standard
    var rowSelected = -1;
    var numSections = 1;
    var cellIds = ["aboutSPARCCell", "aboutAppdevCell", "aboutFontsCell"]
    //var settingsLabels = ["About SPARC", "About AppDev", "Change article font size"];
    var settingsLabels = ["About The Scarlet and Black", "About AppDev", "Change Your Font Size"];
    
    var cellDequeueCount = 0;
    
    var haveReadDictionary: [String:Double] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.set(16, forKey: "font")
        //self.tableView.allowsSelection = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        defaults.setValue(haveReadDictionary, forKey: "haveReadDictionary")
        print(haveReadDictionary)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Changing cell height to 80. Was not working on storyboard
     override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90;
     }

    // MARK: - Table view data source

    override func numberOfSections(in settingsTableView: UITableView) -> Int {
        return numSections
    }

    override func tableView(_ settingsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsLabels.count
    }
    
    override func tableView(_ settingsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> SettingsTableViewCell {
        let identifier = cellIds[cellDequeueCount%3];
        print (identifier)
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SettingsTableViewCell

        cell.settingLabel.text = settingsLabels[indexPath.row];
        cellDequeueCount += 1
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.rowSelected = indexPath.row
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }*/ //this function is not working


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showAboutSPARC"
        {
            //print(tableView.indexPathsForSelectedRows)
            if let destinationVC = segue.destination as? AboutViewController {
                destinationVC.pageType = 0
            }
        }
        else if segue.identifier == "showAboutAppdev"
        {
            if let destinationVC = segue.destination as? AboutViewController {
                destinationVC.pageType = 1
                print ("HERE")
            }
        }
        else if segue.identifier == "showFontSetting"
        {
            if let destinationVC = segue.destination as? FontViewController {
                destinationVC.test = 2
            }
        }
    }
}
