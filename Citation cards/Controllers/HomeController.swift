//
//  HomeController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 31.10.2023.
//

import UIKit

class HomeController: UITableViewController {
    var citations: [Citation] = []
    var sortOrder: SortOrder = .newestFirst
    let storage = Storage()
    let settings = Settings()

    private func updTableView() {
        sortOrder = settings.getSortOrder()
        citations = storage.getAllCitations(inOrder: sortOrder)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func showSortOptions(_ sender: UIBarItem) {
        let sheet = UIAlertController(title: "Sorting", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let titleForNewest: String = "\(sortOrder == .newestFirst ? "\u{25C9}" : "\u{25CB}") Newest First"
        let newestFirstAction = UIAlertAction(title: titleForNewest, style: .default) {[unowned self] _ in
            settings.setSortOrder(order: .newestFirst)
            updTableView()
        }
        let titleForOldest: String = "\(sortOrder == .oldestFirst ? "\u{25C9}" : "\u{25CB}") Oldest First"
        let oldestFirstAction = UIAlertAction(title: titleForOldest, style: .default) {[unowned self] _ in
            settings.setSortOrder(order: .oldestFirst)
            updTableView()
        }
        sheet.addAction(cancelAction)
        sheet.addAction(newestFirstAction)
        sheet.addAction(oldestFirstAction)
        
        present(sheet, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        navigationItem.title = "Home"
        
        // MARK: action buttons
        navigationItem.leftBarButtonItems = [editButtonItem]
        
        updTableView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citations.count
    }

    // display cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citationCell", for: indexPath) as! CitationCell
        
        let citation = citations[indexPath.row]
        cell.caption?.text = citation.text
        cell.author?.text = citation.author
        cell.source?.text = citation.source

        return cell
    }
    
    // commit
    // delete row on click delete action on edit
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let citation = citations[indexPath.row]
        storage.removeCitation(citation)
        updTableView()
    }
    
    // swipe rightward actions
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") {[unowned self] _, _, _ in
            let citation = citations[indexPath.row]
            let editScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditController") as! EditController
            editScreen.editedCitation = citation
            editScreen.doAfterEdit = {[unowned self] in
                updTableView()
            }
            navigationController?.pushViewController(editScreen, animated: true)
        }
        editAction.backgroundColor = .systemOrange
        
        return UISwipeActionsConfiguration(actions: [editAction])
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditController" {
            let destination = segue.destination as! EditController
            destination.doAfterEdit = {[unowned self] in
                updTableView()
            }
        }
        
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
