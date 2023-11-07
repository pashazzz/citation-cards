//
//  FavouritesController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

class FavouritesController: UITableViewController {
    var citations: [Citation] = []
    var sortOrder: SortOrder = .newestFirst
    let storage = Storage()
    let settings = Settings()

    private func updTableView() {
        sortOrder = settings.getSortOrder()
        citations = storage.getFavouriteCitations(inOrder: sortOrder)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favourites"
        
        
        updTableView()
    }

    // display cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citationCell", for: indexPath) as! CitationCell
        
        let citation = citations[indexPath.row]
        cell.caption?.text = citation.text
        cell.author?.text = citation.author
        cell.source?.text = citation.source
        
        // createdAt or updatedAt
        let isModified = citation.updatedAt! > citation.createdAt!
        let dateTime = isModified ? citation.updatedAt! : citation.createdAt!
        let dateCaption = "\(isModified ? "Updated at:" : "Created at:") \(DateTimeHelper.getDateTimeString(from: dateTime))"
        cell.date?.text = dateCaption

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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
