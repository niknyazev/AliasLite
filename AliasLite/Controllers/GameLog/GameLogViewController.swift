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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "logRowData")
        viewModel = GameLogViewModel()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.logData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logRowData", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = viewModel.logData[indexPath.row].player?.name ?? "" // TODO: need view model
        content.secondaryText = viewModel.logData[indexPath.row].word?.text ?? ""
        cell.contentConfiguration = content
        return cell
    }
}
