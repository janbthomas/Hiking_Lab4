//
//  MyTableViewController.swift
//  CIS55Lab4_JanThomas_NodiraMamatova
//
//  Created by Jan on 2/3/17.
//  Copyright © 2017 DeAnza. All rights reserved.
//

import UIKit
import CoreData

class MyTableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {


    var MyHikingList : [HikingListObjectMO] = []
    var hikingDict = [String: [HikingListObjectMO]]()
    var hikingSectionTitles = [String]()
        
    var searchController : UISearchController!
    var searchResults : [HikingListObjectMO] = []
    
    var fetchResultsController : NSFetchedResultsController<HikingListObjectMO>!
 
 
    //override var prefersStatusBarHidden: Bool {
    //    return true
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        // Add a searchController and searchBar to the app
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        let fetchRequest : NSFetchRequest<HikingListObjectMO> = HikingListObjectMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "hikingLocations", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects {
                       MyHikingList = fetchedObjects
                }
            }
            catch {
                print(error)
            }
        }
        CreateHikingDict()
    }

    func CreateHikingDict() {
        for hikingItem in MyHikingList {
            // Get the first letter of the hiking location name and build the dictionary
            let hikingLocation : String? = hikingItem.hikingLocations
            let hikingKey = String((hikingLocation?[(hikingLocation?.startIndex)!])!)
            
            if var hikingValues = hikingDict[hikingKey] {
                hikingValues.append(hikingItem)
                hikingDict[hikingKey] = hikingValues
            }
            else {
                hikingDict[hikingKey] = [hikingItem]
            }
        }
        
        // Get the section titles from the dictionary keys and sort them in ascending order
        hikingSectionTitles = [String](hikingDict.keys)
        hikingSectionTitles.sort()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        print("Data Reloaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        /*
        // Where changes are made, after the core data is saved, reset the loaded list and refresh
        switch type {
        //case .insert:
            //if var newIndexPath = newIndexPath {
                //tableView.insertRows(at: [newIndexPath], with: .fade)
            //}
        //case .delete:
        //    if let indexPath = indexPath {
        //         print("delete \(indexPath)\n")
        //     tableView.deleteRows(at: [indexPath], with: .fade)
        //    }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        */
        
        if let fetchedObjects = controller.fetchedObjects {
            print("Fetched Results Start")
            MyHikingList = fetchedObjects as! [HikingListObjectMO]
            
            // Reset the Dictionary and the section titles
            hikingDict.removeAll()
            hikingSectionTitles.removeAll()
            CreateHikingDict()
            print("Fetched Results End")
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if searchController.isActive {
            return 1
        }
        else {
            print("numberOfSections: \(hikingSectionTitles.count)")
            return hikingSectionTitles.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print ("HikingLocation: \(MyHikingList.count)")
        
        if searchController.isActive {
            print("number of Rows in section: \(searchResults.count)")
            return searchResults.count
        }
        else {
            let hikingKey = hikingSectionTitles[section]
            if let hikingValues = hikingDict[hikingKey] {
                print("hiking values: \(hikingValues.count)")
                return hikingValues.count
            }
            else {
                print("hikingValues: 0")
                return 0
                //return MyHikingList.count
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchController.isActive {
            return ""
        }
        else {
            return hikingSectionTitles[section]
        }

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "HikingCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyTableViewCell
        
        //Add Section Titles
        let hikingKey = hikingSectionTitles[indexPath.section]
        
        var cellItem : HikingListObjectMO
        if searchController.isActive {
            cellItem = searchResults[indexPath.row]
        }
        else {
            //cellItem = MyHikingList[indexPath.row]
                cellItem = (hikingDict[hikingKey]![indexPath.row])

        }
        // Configure the cell...

        cell.cellItemName?.text = cellItem.hikingLocations
        
        if cellItem.hikingImages != nil {
            cell.cellImage?.image = UIImage(data: cellItem.hikingImages as! Data)
        }
        
        //Display a rounded image
        //cell.cellImage?.layer.cornerRadius = cell.cellImage.frame.size.width/8.0
        //cell.cellImage?.clipsToBounds = true
        //cell.cellImage?.layer.masksToBounds = true
        
        /*
        if (cellItem.hikingChecked) {
            cell.accessoryType = .checkmark
            print("Row checked: \(indexPath.row)")
            
        }
        else {
            cell.accessoryType = .none
            print("Row not checked: \(indexPath.row)")
            
        }
        
    */
        return cell
    }
    
    override func sectionIndexTitles( for tableView: UITableView) -> [String]? {
        return hikingSectionTitles
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        if searchController.isActive {
            return false
        }
        else {
            return true
        }
    }

   
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            //MyHikingList.remove(at: indexPath.row)
            print("Remove at indexPath row: \(indexPath.row)")
            print("Remove at indexPath section: \(indexPath.section)")
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let itemToDelete = self.fetchResultsController.object(at: indexPath)
                print("delete commit: \(indexPath)\n")
                context.delete(itemToDelete)
                appDelegate.saveContext()
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            print("insert now")
        }
    }
    

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
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if segue.identifier == "ShowItemDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! MyDetailViewController
                
                //Add Section Titles
                let hikingKey = hikingSectionTitles[indexPath.section]
                
                if searchController.isActive {
                    detailVC.myHikingList = searchResults[indexPath.row]
                }
                else {
                    detailVC.myHikingList = (hikingDict[hikingKey]![indexPath.row])
                    
                }
                
                
                //detailVC.myHikingList = searchController.isActive ? searchResults[indexPath.row] : MyHikingList[indexPath.row]

            }
        }
        //else if segue.identifier == "AddNewItem" {
        //    let addVC = segue.destination as! AddViewController
        //    addVC.newHikingItem = addData
        //}
    }
    
    func addData(newItem : HikingListObjectMO) {
        MyHikingList.append(newItem)
    }
    
    func filterContentForSearchText(searchText: String) {
        searchResults = MyHikingList.filter({ (hikingItem: HikingListObjectMO) -> Bool in
            let nameMatch = hikingItem.hikingLocations?.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let textToSearch = searchController.searchBar.text {
            filterContentForSearchText(searchText: textToSearch)
            tableView.reloadData()
        }
    }

}
