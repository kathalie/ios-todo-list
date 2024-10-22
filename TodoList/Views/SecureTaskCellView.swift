//
//  SecureTaskCellView.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 22.10.2024.
//

import UIKit

class SecureTaskCellView: UITableViewCell {
    @IBOutlet private weak var secureTaskLabel: UILabel!
    
    func config(with secureTask: String) {
        self.secureTaskLabel.text = secureTask
    }
}
