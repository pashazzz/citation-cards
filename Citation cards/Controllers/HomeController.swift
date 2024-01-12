//
//  HomeController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 31.10.2023.
//

import UIKit

class HomeController: UITableViewController, UIGestureRecognizerDelegate {
    let storage = Storage()
    let settings = Settings()
    let notificationPopup = PopupNotification()
    
    var citations: [Citation] = []
    var sortOrder: SortOrder = .newestFirst
    var onlyFavourites: Bool = false

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
    
    @IBOutlet var onlyFavouritesButton: UIBarItem!
    @IBAction func toggleOnlyFavourites(_ sender: UIBarItem) {
        settings.setOnlyFavourites(!settings.getOnlyFavourites())
        updTableView()
    }
    
    private func updTableView() {
        storage.context.reset()
        sortOrder = settings.getSortOrder()
        onlyFavourites = settings.getOnlyFavourites()
        onlyFavouritesButton.title = "\(onlyFavourites ? "\u{25C9}" : "\u{25CB}") Only favourites"
        citations = onlyFavourites ? storage.getFavouriteCitations(inOrder: sortOrder) : storage.getAllCitations(inOrder: sortOrder)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    private func displayPopup(withCaption: String) {
        notificationPopup.setConnectedController(self)
        notificationPopup.displayNotification(withCaption: withCaption)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        navigationItem.title = "Citations"
        
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
    
    // copy to clipboard on long press
    @objc func longPressHandler(_ gestureReconizer: UILongPressGestureRecognizer) {
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.tableView)
        let indexPath = self.tableView?.indexPathForRow(at: point)
        var citationString: String = "«\(citations[indexPath!.row].text!)»"
        if citations[indexPath!.row].author != "" {
            citationString += " \(citations[indexPath!.row].author!)"
        }
        
        UIPasteboard.general.string = citationString
        displayPopup(withCaption: "Copied to clipboard")
    }

    // display cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citationCell", for: indexPath) as! CitationCell
        
        let citation = citations[indexPath.row]
        cell.caption?.text = citation.text
        cell.author?.text = citation.author
        cell.source?.text = citation.source
        
        let tagsIncluded = citation.citationToTag?.allObjects as! [Tag]
        cell.tags?.text = "Tags: " + (tagsIncluded.map({$0.tag!})).joined(separator: ", ")
        
        // is favourite
        cell.isFavourite.setTitle("", for: .normal)
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let isFavouriteImage = UIImage(systemName: citation.isFavourite ? "star.fill" : "star", withConfiguration: imageConfiguration)
        cell.isFavourite.setImage(isFavouriteImage, for: .normal)
        
        cell.toggleIsFavourite = {[unowned self] in
            citation.isFavourite = !citation.isFavourite
            storage.editCitation(citation, needToModifyDate: false)
            updTableView()
        }
        
        // adding recognizer of long press gesture
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        cell.addGestureRecognizer(lpgr)

        return cell
    }

    // archive row on tap archive action on leftward swipe
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archiveAction = UIContextualAction(style: .normal, title: "Archive") {[unowned self] _, _, _ in
            let citation = citations[indexPath.row]
            storage.archiveCitation(citation)
            updTableView()
            displayPopup(withCaption: "Archived")
        }
        archiveAction.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [archiveAction])
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
