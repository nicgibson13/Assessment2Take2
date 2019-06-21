//
//  ItemListTableViewCell.swift
//  Assessment2Take2
//
//  Created by Nic Gibson on 6/21/19.
//  Copyright © 2019 Nic Gibson. All rights reserved.
//

import UIKit


class ItemListTableViewCell: UITableViewCell {
    
    var delegate: ItemListTableViewCellDelegate?
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()}
        
    @IBAction func buttonTapped(_ sender: Any) {
        delegate?.cellButtonTapped(self)
    }
    
    func updateButton(_ isCollected: Bool) {
        if isCollected {
            cellButton.setImage(#imageLiteral(resourceName: "complete"), for: .normal)
        } else {
            cellButton.setImage(#imageLiteral(resourceName: "incomplete"), for: .normal)
        }
    }
}

extension ItemListTableViewCell {
    func update(withItem item: Item) {
        textLabel?.text = item.name
        updateButton(item.isCollected)
    }
}
protocol ItemListTableViewCellDelegate {
    func cellButtonTapped (_ sender: ItemListTableViewCell)
}
