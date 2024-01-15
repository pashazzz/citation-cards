//
//  TagsListController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 9.1.2024.
//

import UIKit

class TagListController: UITableViewController {
    let storage = Storage()
    let notificationPopup = PopupNotification()
    
    var tags: [Tag] = []
    
    @IBAction func onClickAddTag() {
        let createAlert = UIAlertController(title: "Create new tag", message: nil, preferredStyle: .alert)
        createAlert.addTextField { textField in
            textField.placeholder = "Tag name"
        }
        let createButton = UIAlertAction(title: "Create", style: .default) { _ in
            guard let tagName = createAlert.textFields?[0].text else { return }
            let tagForSave = TagForSave(tag: tagName)
            self.storage.createTag(tagForSave)
            
            self.displayPopup(withCaption: "Created")
            
            self.updTableView()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        createAlert.addAction(cancelButton)
        createAlert.addAction(createButton)
        
        self.present(createAlert, animated: true, completion: nil)
    }
    
    private func updTableView() {
        tags = storage.getAllTags()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func displayPopup(withCaption: String) {
        notificationPopup.setConnectedController(self)
        notificationPopup.displayNotification(withCaption: withCaption)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updTableView()
        
        // gestures
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updTableView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TagCell
        let tag = tags[indexPath.row]
        cell.tagName?.text = tag.tag
        cell.tagCount?.text = String(TagsHelper.getOnlyActualCitationsFrom(tag).count)

        return cell
    }
    
    // handle long press
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                displayAlertOnTagLongPress(tag: tags[indexPath.row])
            }
        }
    }
    private func displayAlertOnTagLongPress(tag: Tag) {
        let sheet = UIAlertController(title: tag.tag, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let renameTagAction = UIAlertAction(title: "Rename tag", style: .default) {[unowned self] _ in
            let renameAlert = UIAlertController(title: tag.tag, message: "Rename tag", preferredStyle: .alert)
            renameAlert.addTextField { textField in
                textField.placeholder = "New tag name"
            }
            let renameButton = UIAlertAction(title: "Rename", style: .default) { _ in
                guard let newName = renameAlert.textFields?[0].text else { return }
                guard newName != tag.tag else { return }
                tag.tag = newName
                self.storage.editTag(tag)
                
                self.updTableView()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            renameAlert.addAction(cancelButton)
            renameAlert.addAction(renameButton)
            
            self.present(renameAlert, animated: true, completion: nil)
        }
        
        let deleteTagAction = UIAlertAction(title: "Delete tag", style: .destructive) {[unowned self] _ in
            let deleteAlert = UIAlertController(title: tag.tag, message: "Delete tag", preferredStyle: .alert)
            let deleteButton = UIAlertAction(title: "Delete", style: .default) { _ in
                self.storage.deleteTag(tag)
                
                self.updTableView()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            deleteAlert.addAction(cancelButton)
            deleteAlert.addAction(deleteButton)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        let deleteCitationsWithTagAction = UIAlertAction(title: "Delete citations with tag", style: .destructive) {[unowned self] _ in
            updTableView()
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(renameTagAction)
        sheet.addAction(deleteTagAction)
        sheet.addAction(deleteCitationsWithTagAction)
        
        present(sheet, animated: true)
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaggedCitationsController" {
            let destination = segue.destination as! TaggedCitationsController
            let tagName = (sender as! TagCell).tagName.text
            let currentTag = tags.first(where: {$0.tag == tagName})
            destination.tag = currentTag
        }
    }

}
