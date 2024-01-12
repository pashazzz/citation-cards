//
//  EditCitationTagsController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 10.1.2024.
//

import UIKit

class EditCitationTagsController: UITableViewController {
    
    let storage = Storage()
    var tagsBySections: [[Tag]] = []
    
    var citation: Citation?
    
    let sections = ["Included", "Available"]
    let plusImage = UIImage(systemName: "plus.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    let minusImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    
    private func updTableView() {
        tagsBySections = []
        let tags: [Tag] = storage.getAllTags()
        tagsBySections.append(citation?.citationToTag?.allObjects as? [Tag] ?? [])
        tagsBySections.append(tags.filter({!tagsBySections[0].contains($0)}))
        
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
        return sections.count
    }
    
    // titleForHeaderInSection
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsBySections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editTagCell", for: indexPath) as! EditTagCell
        
        let tag = tagsBySections[indexPath.section][indexPath.row]
        cell.delegate = self
        cell.isIncluded.setImage((indexPath.section == 0) ? minusImage : plusImage, for: .normal)
        cell.tagName.text = tag.tag
        cell.tagCount.text = String(TagsHelper.getOnlyActualCitationsFrom(tag).count)

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
        let tags: [Tag] = storage.getAllTags()
        guard let index = tags.firstIndex(where: {$0.tag == tagName}) else { return }
        
        isIncluded
            ? citation?.removeFromCitationToTag(tags[index])
            : citation?.addToCitationToTag(tags[index])
        
        updTableView()
    }
}
