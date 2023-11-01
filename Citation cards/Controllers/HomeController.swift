//
//  HomeController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 31.10.2023.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var citations: [Citation] = []
    let storage = Storage()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let citation = citations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "citation", for: indexPath) as! CitationCell
        cell.caption.text = citation.text
        cell.author.text = citation.author

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
        title = "Home"
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        citations = storage.getAllCitations()
        
        updTableView()
        
    }


}

