//
//  ConfigurationViewController.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 27.12.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func sendMessageToLabel(message: String)
    func switchStateDidChange(state: Bool, index: Int)
}

class SettingsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var superViewForStackView: UIView!
    @IBOutlet weak private var superViewForCollection: UIView!
    @IBOutlet weak private var superViewForTableView: UIView!
    @IBOutlet weak private var settingsTextField: UITextField!
    @IBOutlet weak private var settingsTableView: UITableView!
    @IBOutlet weak private var settingsCollectionView: UICollectionView!
    @IBOutlet weak private var settingsStackView: UIStackView!
    
    var delegate: SettingsViewControllerDelegate?
    
    private var configuration: SettingsViewControllerConfiguration?
    private var items: [ItemState] = []
    private var cellTitle = ""
    private var cellColor: UIColor = .red
    var selectedIndex: Int?
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsCollectionView.delegate = self
        settingsCollectionView.dataSource = self
        settingsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        settingsTextField.delegate = self
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTextField.text = configuration?.textForTexfield
        if let selectedIndex {
            setupUI(selectedIndex: selectedIndex)
        }
        settingsStackView.addSubview(<#T##view: UIView##UIView#>)
    }
    
    func configure(with configuration: SettingsViewControllerConfiguration) {
        self.configuration = configuration
        let configureItemsArray = configuration.bunchOfSwiftStates.enumerated().map ({ (index, element) in
            if element {
                cellColor = .green
                cellTitle = "ON"
            } else {
                cellTitle = "OFF"
            }
            return ItemState(id: index, state: element, cellTitle: cellTitle, cellBackgroundColor: cellColor)
        })
        items = configureItemsArray
    }
    
    private func setupUI(selectedIndex: Int) {
        superViewForTableView.isHidden = true
        superViewForCollection.isHidden = true
        superViewForStackView.isHidden = true
        
        if selectedIndex == 0 {
            superViewForTableView.isHidden = false
        } else if selectedIndex == 1 {
            superViewForCollection.isHidden = false
        } else {
            superViewForStackView.isHidden = false
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDelegate

extension SettingsViewController: UICollectionViewDelegate {
}

//MARK: - UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "SettingsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AppConstants.Identifieers.Cells.collectionView)
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Identifieers.Cells.collectionView, for: indexPath) as? SettingsCollectionViewCell {
            cell.delegate = self
            let item = items[indexPath.item]
            cell.configure(with: item)
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 44.0
        let width = collectionView.bounds.width
        let witdhCell = width/1 - collectionView.contentInset.left - collectionView.contentInset.right
        let size = CGSize(width: witdhCell, height: height)
        return size
    }
}

//MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        settingsTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.sendMessageToLabel(message: text)
        }
    }
}


//MARK: - UITableViewDataSorce

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: AppConstants.Identifieers.Cells.tableView)
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifieers.Cells.tableView, for: indexPath) as? SettingsTableViewCell {
            cell.delegate = self
            let item = items[indexPath.row]
            cell.configure(with: item)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    
}

//MARK: - SwitchStatmentDelegate

extension SettingsViewController: SwitchStatmentDelegate {
    func changeSwitchState(index: Int, switchState: Bool) {
        items[index].state = switchState
        configuration?.bunchOfSwiftStates[index] = switchState
        delegate?.switchStateDidChange(state: switchState, index: index)
    }
}
