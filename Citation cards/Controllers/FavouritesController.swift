//
//  FavouritesController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 1.11.2023.
//

import UIKit

class FavouritesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var citations: [Citation?] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let citation: Citation? = citations[indexPath.row] ?? nil
        let cell = tableView.dequeueReusableCell(withIdentifier: "citation", for: indexPath) as! CitationCell
//        cell.caption.text = citation?.text
//        cell.author.text = citation?.author

        return cell
    }
    
    
    // create table for citation list
    let tableView: UITableView = {
        let table = UITableView()
        table.register(CitationCell.self, forCellReuseIdentifier: "citation")
        
        return table
    }()

    private func updTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Favourites"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        
//        updTableView()
        
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
