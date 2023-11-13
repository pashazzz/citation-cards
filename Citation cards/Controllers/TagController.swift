//
//  TagController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 10.11.2023.
//

import UIKit

class TagController: UITableViewController {
    let storage = Storage()
    let notificationPopup = PopupNotification()
    
    var tags: [Tag] = []
    let maxSizeOfTagLabel = CGSize(width: 200, height: 20)
    
    @IBOutlet var createTagField: UITextField!
    @IBOutlet var tagsView: UIView!
    
    @IBAction func onTapCreateTag(_ sender: UIButton) {
        guard createTagField.text! != "" else {
            return
        }
        let tagForSave = TagForSave(tag: createTagField.text!)
        storage.createTag(tagForSave)
        
        notificationPopup.setConnectedController(self)
        notificationPopup.displayNotification(withCaption: "Created")
        
        createTagField.text = ""
        updTagsList()
    }
    
    private func updTagsList() {
        tags = storage.getAllTags()
        var lastLabel: UILabel?
        
        for tag in tags {
            let label = UILabel(frame: CGRect())
            label.text = tag.tag
            label.backgroundColor = .systemBlue
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 6
            tagsView.addSubview(label)
            var labelSize = label.sizeThatFits(maxSizeOfTagLabel)
            labelSize.width = labelSize.width > maxSizeOfTagLabel.width ? maxSizeOfTagLabel.width : labelSize.width
            
            var startXPoint = lastLabel != nil ? (lastLabel?.frame.origin.x)! + (lastLabel?.frame.width)! + 16 : 0
            let isNeedNewLine = labelSize.width + startXPoint > self.view.bounds.width
            // here +4 needed because after insets for frame and bounds the origin coordinates shifted
            var startYPoint = lastLabel != nil ? (lastLabel?.frame.origin.y)! + 4 : 0
            if isNeedNewLine {
                startXPoint = 0
                startYPoint += 34
            }
            
            label.frame = CGRect(origin: CGPoint(x: startXPoint, y: startYPoint), size: labelSize)
            label.frame = label.frame.insetBy(dx: -14, dy: -10)
            label.bounds = label.bounds.insetBy(dx: 6, dy: 6)
            
            lastLabel = label
        }
    }
    
    private func updTableView() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updTagsList()
        updTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Tags"

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
        return 0
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
