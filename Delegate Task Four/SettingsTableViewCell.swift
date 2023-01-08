//
//  SettingsTableViewCell.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 28.12.2022.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var switchStateLabel: UILabel!
    @IBOutlet weak private var settingSwitch: UISwitch!
    
    //MARK: - Variables
    
    var delegate: SwitchStatmentDelegate?
    
    private var cellIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Functions
    
    func configure(with item: ItemState) {
        settingSwitch.setOn(item.state, animated: true)
        cellIndex = item.id
        switchStateLabel.text = item.cellTitle
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
