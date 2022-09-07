//
//  GameLogViewController.swift
//  AliasLite
//
//  Created by Николай on 06.09.2022.
//

import UIKit

class GameLogViewController: UITableViewController {

    var viewModel: GameLogViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logRowData")
        viewModel = GameLogViewModel()
        title = "Game log"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.log(for: section).count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.playersNames.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.title(for: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logRowData", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = viewModel.log(for: indexPath.section)[indexPath.row].word?.text ?? ""
//        content.secondaryText = viewModel.logData[indexPath.row].word?.text ?? ""
        cell.contentConfiguration = content
        return cell
    }
}
