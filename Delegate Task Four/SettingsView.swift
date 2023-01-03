//
//  SettingsView.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 03.01.2023.
//

import UIKit

class SettingsView: UIView {

    @IBOutlet weak private var settingsSwitch: UISwitch!
    @IBOutlet weak private var stateLabel: UILabel!
    
    private var cellIndex: Int?
    
    var delegate: SwitchStatmentDelegate?
    
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: SettingsView.self)
        let nib = UINib(nibName: "SettingsView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func configure(with item: ItemState) {
        settingsSwitch.setOn(item.state, animated: true)
        cellIndex = item.id
        stateLabel.text = item.cellTitle
    }
    
    @IBAction private func valueChanged(_ sender: UISwitch) {
        if let cellIndex {
            delegate?.changeSwitchState(index: cellIndex, switchState: settingsSwitch.isOn)
        }
    }
}
