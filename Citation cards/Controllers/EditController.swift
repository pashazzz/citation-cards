//
//  EditController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 2.11.2023.
//

import UIKit

class EditController: UITableViewController {
    @IBOutlet var citationTextView: UITextView!
    @IBOutlet var authorTextField: UITextField!
    @IBOutlet var sourceTextField: UITextField!
    @IBOutlet var isFavouriteSwitch: UISwitch!
    
    @IBOutlet var tags: UILabel!
    
    var doAfterEdit: (() -> Void)?
    let storage = Storage()
    
    var tempCitation: CitationForSaveProtocol = CitationForSave(text: "")
    var editedCitation: Citation?
    
    @IBAction func onTapSaveButton(_ sender: UIBarButtonItem) {
        // edited or new one
        if let citation = editedCitation {
            citation.text = citationTextView.text
            citation.author = authorTextField.text
            citation.source = sourceTextField.text
            citation.isFavourite = isFavouriteSwitch.isOn
            storage.editCitation(citation)
        } else {
            let item = CitationForSave(text: citationTextView.text!,
                                       author: authorTextField.text ?? "",
                                       source: sourceTextField.text ?? "",
                                       isFavourite: isFavouriteSwitch.isOn)
            storage.saveCitation(item)
        }
        
        doAfterEdit?()
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        citationTextView.text = editedCitation?.text ?? tempCitation.text
        authorTextField.text = editedCitation?.author ?? tempCitation.author
        sourceTextField.text = editedCitation?.source ?? tempCitation.source
        isFavouriteSwitch.isOn = editedCitation?.isFavourite ?? tempCitation.isFavourite
        tags.text = "Tags: " + ("")
        citationTextView.becomeFirstResponder()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    private func updTags() {
        print("updTags")
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
         print(segue.identifier)
         if segue.identifier == "EditCitationTagsController" {
             print("EditCitationTagsController")
             let destination = segue.destination as! EditCitationTagsController
             destination.citation = editedCitation ?? tempCitation as? Citation
             destination.doAfterEdit = {[unowned self] in
                 print("segue")
                 updTags()
             }
         }
         
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }

}
