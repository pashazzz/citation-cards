//
//  EditWidgetTagsController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 24.1.2024.
//

import UIKit

class EditWidgetTagsController: UITableViewController {
    
    let storage = Storage()
    let settings = Settings()
    var tagsBySections: [[Tag]] = []
    
    var includedTags: [Tag] = []
    
    let sections = ["Included", "Available"]
    let plusImage = UIImage(systemName: "plus.circle.fill")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
    let minusImage = UIImage(systemName: "minus.circle.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    
    private func updTableView() {
        includedTags = settings.getWidgetTags()
        let allTags: [Tag] = storage.getAllTags()
        tagsBySections = []
        
        tagsBySections.append(includedTags)
        tagsBySections.append(allTags.filter({!tagsBySections[0].contains($0)}))
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updTableView()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditWidgetTagsController: EditTagCellDelegate {
    func didTapButtonToggleTag(with tagName: String, isIncluded: Bool) {
        guard tagName != "" else { return }
        let tags: [Tag] = storage.getAllTags()
        guard let index = tags.firstIndex(where: {$0.tag == tagName}) else { return }
        
        isIncluded
            ? settings.removeWidgetTag(tags[index])
            : settings.addWidgetTag(tags[index])
        
        updTableView()
    }
}
