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
    
    //MARK: - Outlets
    
    @IBOutlet weak private var switchStateLabel: UILabel!
    @IBOutlet weak private var settingSwitch: UISwitch!
    
    var delegate: SwitchStatmentDelegate?
    
    //MARK: - Variables
    
    private var cellIndex: Int?
    
    //MARK: - Functions
    
    func configure(with item: ItemState) {
        settingSwitch.setOn(item.state, animated: true)
        cellIndex = item.id
        switchStateLabel.text = item.cellTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        settingSwitch.isOn = false
        switchStateLabel.text = nil
    }
    
    //MARK: - Actions
    
    @IBAction private func valueChanged(_ sender: UISwitch) {
        if let cellIndex {
            delegate?.changeSwitchState(index: cellIndex, switchState: settingSwitch.isOn)
        }
    }
}
