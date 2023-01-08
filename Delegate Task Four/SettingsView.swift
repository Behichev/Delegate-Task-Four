//
//  SettingsView.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 03.01.2023.
//

import UIKit

class SettingsView: UIView {

    //MARK: - Outlets
    
    @IBOutlet weak private var settingSwitch: UISwitch!
    @IBOutlet weak private var switchStateLabel: UILabel!
    
    //MARK: - Variables
    
    private var cellIndex: Int?
    
    var delegate: SwitchStatmentDelegate?

    //MARK: - Functions
    
    func configure(with item: ItemState) {
        settingSwitch.setOn(item.state, animated: true)
        cellIndex = item.id
        switchStateLabel.text = item.cellTitle
    }
    
    //MARK: - Actions
    
    @IBAction private func valueChanged(_ sender: UISwitch) {
        if let cellIndex {
            delegate?.changeSwitchState(index: cellIndex, switchState: settingSwitch.isOn)
        }
    }
}
