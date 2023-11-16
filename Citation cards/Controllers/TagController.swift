//
//  TagController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 10.11.2023.
//

import UIKit

class TagController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    let storage = Storage()
    let notificationPopup = PopupNotification()
    
    var tags: [Tag] = []
    let maxSizeOfTagLabel = CGSize(width: 200, height: 20)
    
    @IBOutlet var createTagField: UITextField!
    @IBOutlet var tagsView: UIView!
    @IBOutlet var tagsCollectionView: UICollectionView!
    
    @IBAction func onTapCreateTag(_ sender: UIButton) {
        guard createTagField.text! != "" else {
            return
        }
        let tagForSave = TagForSave(tag: createTagField.text!)
        storage.createTag(tagForSave)
        
        notificationPopup.setConnectedController(self)
        notificationPopup.displayNotification(withCaption: "Created")
        
        createTagField.text = ""
//        updTagsList()
        updTagsCollectionList()
    }
    
    private func updTagsCollectionList() {
        if tags.count > 0 {
            var indexPathes: [IndexPath] = []
            for index in (0...tags.count - 1) {
                indexPathes.append(IndexPath(row: index, section: 0))
            }
            tags = []
            self.tagsCollectionView.deleteItems(at: indexPathes)
            DispatchQueue.main.async {
                self.tagsCollectionView.reloadData()
            }
        }
        tags = storage.getAllTags()
        
        DispatchQueue.main.async {
            self.tagsCollectionView.reloadData()
        }
    }
    
    private func updCellsHeight() {
        guard let createTagCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)),
              let tagsCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)),
              let citationsCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) else { return }
        
        let size = tagsCollectionView.contentSize
        // resize tags cell
        let tagsCellHeight = size.height + 26 < createTagCell.frame.height ? createTagCell.frame.height : size.height + 26
        tagsCell.frame = CGRect(origin: tagsCell.frame.origin, size: CGSize(width: tagsCell.frame.width, height: tagsCellHeight))
        // shift the next cell
        citationsCell.frame = CGRect(origin: CGPoint(x: citationsCell.frame.origin.x, y: tagsCell.frame.origin.y + tagsCell.frame.height), size: citationsCell.frame.size)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        
        let label = UILabel(frame: CGRect())
        label.text = tags[indexPath.row].tag
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        cell.backgroundColor = .systemBlue
        cell.addSubview(label)
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 6
        var labelSize = label.sizeThatFits(maxSizeOfTagLabel)
        labelSize.width = labelSize.width > maxSizeOfTagLabel.width ? maxSizeOfTagLabel.width : labelSize.width
        
        label.frame = CGRect(origin: CGPoint(x: 6, y: 2), size: labelSize)
        
        // adding recognizer of long press gesture
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        cell.addGestureRecognizer(lpgr)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect())
        label.text = tags[indexPath.row].tag
        label.font = UIFont.systemFont(ofSize: 15)
        let labelSize = label.sizeThatFits(CGSizeZero)
        
        return CGSize(width: labelSize.width + 12, height: labelSize.height + 5)
    }
    
    private func displayPopup(withCaption: String) {
        notificationPopup.setConnectedController(self)
        notificationPopup.displayNotification(withCaption: withCaption)
    }
    
    // handle long press
    @objc func longPressHandler(_ gestureReconizer: UILongPressGestureRecognizer) {
        guard gestureReconizer.state != .began else { return }
        let point = gestureReconizer.location(in: self.tagsCollectionView)
        let indexPath = self.tagsCollectionView.indexPathForItem(at: point)
        displayAlertOnTagLongPress(tag: tags[indexPath!.row])
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
                
                self.updTagsCollectionList()
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
                
                self.updTagsCollectionList()
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            deleteAlert.addAction(cancelButton)
            deleteAlert.addAction(deleteButton)
            
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        let deleteCitationsWithTagAction = UIAlertAction(title: "Delete citations with tag", style: .destructive) {[unowned self] _ in
            updTagsCollectionList()
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(renameTagAction)
        sheet.addAction(deleteTagAction)
        sheet.addAction(deleteCitationsWithTagAction)
        
        present(sheet, animated: true)
    }
    
    private func generateTagLabel(tag: Tag, lastLabel: UILabel?) -> UILabel {
        let label = UILabel(frame: CGRect())
        label.text = tag.tag
        label.backgroundColor = .systemBlue
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
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
        
        return label
    }
    
    private func updTagsList() {
        tags = storage.getAllTags()
        var lastLabel: UILabel?
        
        for tag in tags {
            let label = generateTagLabel(tag: tag, lastLabel: lastLabel)
            lastLabel = label
            tagsView.addSubview(label)
        }
    }
    
    // for citations with selected tags
    private func updTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        updTagsList()
        updTagsCollectionList()
        updTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updCellsHeight()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Tags"
        tagsCollectionView.dataSource = self
        tagsCollectionView.delegate = self

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
        return 3
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.cellForRow(at: indexPath) else { return UITableViewCell() }
//        print(cell.reuseIdentifier ?? "nil")
        
//        cell.sizeToFit()

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

// MARK: Helpers
// For positioning elements in UICollectionView
class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
