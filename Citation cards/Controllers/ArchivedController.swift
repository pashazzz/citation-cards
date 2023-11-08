//
//  ArchivedController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

class ArchivedController: UITableViewController {
    var citations: [Citation] = []
    let storage = Storage()
    let settings = Settings()

    private func updTableView() {
        citations = storage.getArchivedCitations()
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updTableView()
    }

    // display cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citationCell", for: indexPath) as! CitationCell
        
        let citation = citations[indexPath.row]
        cell.caption?.text = citation.text
        cell.author?.text = citation.author
        cell.source?.text = citation.source
        
        let dateCaption = "Archived at: \(DateTimeHelper.getDateTimeString(from: citation.archivedAt!))"
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
        let restoreAction = UIContextualAction(style: .normal, title: "Restore") {[unowned self] _, _, _ in
            let citation = citations[indexPath.row]
            storage.restoreCitation(citation)
            updTableView()
        }
        restoreAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [restoreAction])
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
