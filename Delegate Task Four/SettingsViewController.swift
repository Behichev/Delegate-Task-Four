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
    
    //MARK: - Variables
    
    private var items: [ItemState] = []
    private var cellTitle = ""
    private var myView: SettingsView?
    private var firstScreenArrayOfStates: [Bool] = []
    private var selectedIndex: Int?
    private var textForTexfield: String?
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTextField.delegate = self
        items = transformStateArrayToStruct(array: firstScreenArrayOfStates)
        if let selectedIndex, let textForTexfield {
            setupUI(selectedIndex: selectedIndex)
            settingsTextField.text = textForTexfield
        }
    }
    
    //MARK: - Functions
    
    func configure(with configuration: SettingsViewControllerConfiguration) {
        firstScreenArrayOfStates = configuration.bunchOfSwiftStates
        selectedIndex = configuration.selectedIndex
        textForTexfield = configuration.textForTexfield
    }
    
    private func transformStateArrayToStruct(array: [Bool]) -> [ItemState] {
        
        let transformedArray = array.enumerated().map ({ (index, element) in
            if element {
                cellTitle = "ON"
            } else {
                cellTitle = "OFF"
            }
            return ItemState(id: index, state: element, cellTitle: cellTitle)
        })
        return transformedArray
    }
    
    private func setupUI(selectedIndex: Int) {
        superViewForTableView.isHidden = true
        superViewForCollection.isHidden = true
        superViewForStackView.isHidden = true
        
        switch selectedIndex {
            
        case 0:
            superViewForTableView.isHidden = false
            settingsTableView.delegate = self
            settingsTableView.dataSource = self
            
        case 1:
            superViewForCollection.isHidden = false
            settingsCollectionView.dataSource = self
            settingsCollectionView.delegate = self
            settingsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            
        case 2:
            superViewForStackView.isHidden = false
            for item in items {
                if let myView = UINib.init(nibName: "SettingsView", bundle: nil).instantiate(withOwner: self)[0] as? SettingsView {
                    settingsStackView.addArrangedSubview(myView)
                    myView.configure(with: item)
                    myView.delegate = self
                    
                }
            }
            
        default:
            break
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
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
        firstScreenArrayOfStates[index] = switchState
        items = transformStateArrayToStruct(array: firstScreenArrayOfStates)
        delegate?.switchStateDidChange(state: switchState, index: index)
    }
}
