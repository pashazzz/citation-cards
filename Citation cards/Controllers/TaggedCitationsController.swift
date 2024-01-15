//
//  TaggedCitationsController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 15.1.2024.
//

import UIKit

class TaggedCitationsController: UITableViewController {
    let storage = Storage()
    var tag: Tag?
    var citations: [Citation] = []

    private func updTableView() {
        guard tag != nil && tag?.tag != nil else {
            navigationController?.popViewController(animated: true)
            return
        }
        citations = tag?.tagToCitation?.allObjects as? [Citation] ?? []
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updTableView()
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updTableView()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
