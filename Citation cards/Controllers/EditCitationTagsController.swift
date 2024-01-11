//
//  EditCitationTagsController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 10.1.2024.
//

import UIKit

class EditCitationTagsController: UITableViewController {
    
    let storage = Storage()
    var tags: [Tag] = []
    var tagsIncluded: [Tag] = []
    
    var doAfterEdit: (() -> Void)?
    var citation: Citation?
    
    private func updTableView() {
        tags = storage.getAllTags()
        tagsIncluded = citation?.citationToTag?.allObjects as! [Tag]
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTagCell", for: indexPath) as! EditTagCell
        let plusImage = UIImage(systemName: "plus.circle.fill")
        let minusImage = UIImage(systemName: "minus.circle.fill")
        let isTagIncluded = tagsIncluded.firstIndex(where: {$0.tag == tags[indexPath.row].tag})
        
        cell.delegate = self
        cell.isIncluded.setImage((isTagIncluded != nil) ? minusImage : plusImage, for: .normal)
        cell.tagName.text = tags[indexPath.row].tag
        cell.tagCount.text = "0"

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

extension EditCitationTagsController: EditTagCellDelegate {
    func didTapButtonToggleTag(with tagName: String, isIncluded: Bool) {
        guard tagName != "" else { return }
        guard let index = tags.firstIndex(where: {$0.tag == tagName}) else { return }
        
        isIncluded
            ? citation?.removeFromCitationToTag(tags[index])
            : citation?.addToCitationToTag(tags[index])
        
        updTableView()
    }
}
