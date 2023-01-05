//
//  SettingsCollectionViewCell.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 28.12.2022.
//

import UIKit

protocol SwitchStatmentDelegate {
    func changeSwitchState(index: Int, switchState: Bool)
}

class SettingsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var switchStateLabel: UILabel!
    @IBOutlet weak private var settingSwitch: UISwitch!
    
    var delegate: SwitchStatmentDelegate?
    
    private var cellIndex: Int?
    
    func configure(with item: ItemState) {
        settingSwitch.setOn(item.state, animated: true)
        cellIndex = item.id
        switchStateLabel.text = item.cellTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func valueChanged(_ sender: UISwitch) {
        if let cellIndex {
            delegate?.changeSwitchState(index: cellIndex, switchState: settingSwitch.isOn)
            if settingSwitch.isOn {
                switchStateLabel.text = "ON"
            } else {
                switchStateLabel.text = "OFF"
            }
        }
    }
}
