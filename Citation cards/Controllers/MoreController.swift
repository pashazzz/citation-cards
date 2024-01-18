//
//  SettingsController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

enum ExportTypes {
    case TXT
    case CSV
}

class MoreController: UITableViewController {
    let storage = Storage()
    let notificationPopup = PopupNotification()
    
    private func dateToString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    
    private func displayPopup(withCaption: String) {
        notificationPopup.setConnectedController(self)
        notificationPopup.displayNotification(withCaption: withCaption)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
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
        return 2
    }
    
    let exportFields = ["text", "author", "source", "createdAt", "isFavourite"]
    
    @IBAction func exportButton(_ sender: Any?) {
        let sheet = UIAlertController(title: "Export", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let exportTxtAction = UIAlertAction(title: "Export into .txt", style: .default) {[unowned self] _ in
            let data = prepareDataForExport(type: .TXT)
            saveAndExport(exportString: data)
        }
        let exportCsvAction = UIAlertAction(title: "Export into .csv (separator is '|')", style: .default) {[unowned self] _ in
            let data = prepareDataForExport(type: .CSV)
            saveAndExport(exportString: data)
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(exportTxtAction)
        sheet.addAction(exportCsvAction)
        
        present(sheet, animated: true)
    }
    
    private func generateTxtString(from citations: [Citation]) -> String {
        var exportString = ""
        for citation in citations {
            exportString += "«\(citation.text!)»\n"
            if citation.author != nil && citation.author != "" {
                exportString += "\(citation.author!)\n"
            }
            if citation.source != nil && citation.source != "" {
                exportString += "\(citation.source!)\n"
            }
            exportString += "---\n"
        }
        return exportString
    }
    private func generateCsvString(from citations: [Citation]) -> String {
        var exportString = exportFields.joined(separator: "|")
        exportString += "\n"

        for citation in citations {
            for (index, field) in exportFields.enumerated() {
                var value = ""
                let valueRaw = citation.value(forKey: field)
                
                switch field {
                case "createdAt":
                    value = dateToString(from: valueRaw as! Date)
                case "isFavourite":
                    value = valueRaw as! Bool ? "true" : "false"
                default:
                    value = valueRaw as? String ?? ""
                }
                print(value)

                exportString += value
                exportString += index == exportFields.count - 1 ? "\n" : "|"
            }
        }
        return exportString
    }
    
    func prepareDataForExport(type: ExportTypes = .TXT) -> String {
        var exportString = ""
        let citationsArray = storage.getAllCitations(inOrder: .oldestFirst)

        switch type {
        case .TXT:
            exportString = generateTxtString(from: citationsArray)
        case .CSV:
            exportString = generateCsvString(from: citationsArray)
        }
        return exportString
    }

    func saveAndExport(exportString: String) {
        let todayString = dateToString(from: Date())
        let exportFilePath = NSTemporaryDirectory() + "citations_\(todayString).txt"
        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: NSData() as Data, attributes: nil)

        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL as URL)
        } catch {
            print("Error with fileHandle")
            displayPopup(withCaption: "Error with fileHandle")
        }

        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let data = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false)
            fileHandle!.write(data!)

            fileHandle!.closeFile()

            let firstActivityItem = NSURL(fileURLWithPath: exportFilePath)
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem], applicationActivities: nil)

            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo
            ]

            self.present(activityViewController, animated: true, completion: nil)
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
