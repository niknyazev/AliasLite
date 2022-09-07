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
        tableView.register(LogCell.self, forCellReuseIdentifier: LogCell.cellID)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: LogCell.cellID, for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = viewModel.log(for: indexPath.section)[indexPath.row].word?.text ?? ""
       
        let wordIsGuessed = viewModel.log(for: indexPath.section)[indexPath.row].guessed
        content.secondaryText = wordIsGuessed ? "guessed" : "dropped"
        cell.contentConfiguration = content
        
        cell.backgroundColor = wordIsGuessed ? .green : .red
        
        return cell
    }
}

class LogCell: UITableViewCell {
    
    static let cellID = "playerData"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
